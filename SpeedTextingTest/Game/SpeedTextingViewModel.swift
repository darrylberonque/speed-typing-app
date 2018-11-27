//
//  SpeedTextingViewModel.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/21/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class SpeedTextingViewModel {

    private var paragraphText = Constants.defaultParagraph
    private var numCharactersTyped = 0
    private var metricsModel = MetricsModel()
    private var disposeBag = DisposeBag()

    var didFinishTest = false
    var userInput = PublishRelay<String>()
    var currentParagraphMutableText = PublishRelay<NSMutableAttributedString>()

    var timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
    var cpm = BehaviorRelay(value: 0.0)
    var wpm = BehaviorRelay(value: 0.0)
    var accuracy = BehaviorRelay(value: 0.0)


    init() {
        setupBindings()
    }

    private func setupBindings() {
        bindParagraphText()
        bindParagraphTextDisplay()
        bindMetrics()
    }

    private func bindParagraphText() {
        RequestManager.getAllParagraphs().asObservable()
            .single()
            .map({ [weak self] paragraphsModel in
                guard let welf = self else { return NSMutableAttributedString(string: "") }
                let paragraphs = paragraphsModel.paragraphs
                let randomIndex = Int.randomIntInRange(low: 0, high: paragraphs.count-1)
                let randomParagraph = paragraphs[randomIndex].content
                welf.paragraphText = randomParagraph
                return NSMutableAttributedString(string: randomParagraph)
            })
            .bind(to: currentParagraphMutableText)
            .disposed(by: disposeBag)
    }

    private func bindParagraphTextDisplay() {
        userInput.asObservable()
            .map({ [unowned self] input in
                let paragraph = self.paragraphText
                let attributedText = NSMutableAttributedString(string: self.paragraphText)

                if input.count <= paragraph.count {
                    for i in 0..<paragraph.count {
                        var correctColorIndicator: UIColor
                        let paragraphIndex = paragraph.index(paragraph.startIndex, offsetBy: i)

                        if i <= input.count-1 {
                            let textIndex = input.index(input.startIndex, offsetBy: i)
                            correctColorIndicator = paragraph[paragraphIndex] == input[textIndex] ? .green : .red
                        } else {
                            correctColorIndicator = .black
                        }

                        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: correctColorIndicator, range: NSRange(location: i, length: 1))
                    }
                } else {
                    // TODO: Show modal of typing test results, update trial model with time, capture current time as well
                    self.didFinishTest = true
                }

                return attributedText
            })
            .bind(to: currentParagraphMutableText)
            .disposed(by: disposeBag)
    }

    // TODO: - Update wpm calculation to net wpm
    private func bindMetrics() {
        userInput.asObservable()
            .distinctUntilChanged()
            .skip(1)
            .map({ [unowned self] input in
                // TODO: - Look over this logic if you can improve the structure by binding
                if input.count <= self.paragraphText.count {
                    self.numCharactersTyped += 1
                    self.metricsModel.calculateAccuracy(userInput: input, paragraph: self.paragraphText, numCharactersTyped: self.numCharactersTyped)
                }
                return self.metricsModel.accuracy
            })
            .bind(to: accuracy)
            .disposed(by: disposeBag)

        Observable.combineLatest(userInput.asObservable(), timer.asObservable())
            .map({ [unowned self] input, time in
                if input.count <= self.paragraphText.count {
                    self.metricsModel.calculateCPM(userInput: input, time: time)
                }
                return self.metricsModel.cpm
            })
            .bind(to: cpm)
            .disposed(by: disposeBag)

        Observable.combineLatest(userInput.asObservable(), timer.asObservable())
            .map({ [unowned self] input, time in
                if input.count <= self.paragraphText.count {
                    self.metricsModel.calculateWPM(userInput: input, time: time)
                }
                return self.metricsModel.wpm
            })
            .bind(to: wpm)
            .disposed(by: disposeBag)
    }
}
