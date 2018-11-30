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

    var userInput = PublishRelay<String>()
    var currentParagraphMutableText = PublishRelay<NSMutableAttributedString>()

    var trial = BehaviorRelay(value: TrialModel())
    var timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
    var cpm = BehaviorRelay(value: 0.0)
    var wpm = BehaviorRelay(value: 0.0)
    var accuracy = BehaviorRelay(value: 0.0)

    init() {
        setupBindings()
    }

    // MARK: - Bindings

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

                let font = UIFont(name: "HelveticaNeue-Medium", size: 13)!
                let attributedParagraphText = NSMutableAttributedString(string: randomParagraph)
                attributedParagraphText.addAttribute(.foregroundColor, value: UIColor.blueThemeColor, range: NSRange(location: 0, length: randomParagraph.count-1))
                attributedParagraphText.addAttribute(.font, value: font, range: NSRange(location: 0, length: randomParagraph.count-1))

                return attributedParagraphText
            })
            .bind(to: currentParagraphMutableText)
            .disposed(by: disposeBag)
    }

    private func bindParagraphTextDisplay() {
        userInput.asObservable()
            .map({ [unowned self] input in
                let paragraph = self.paragraphText
                let attributedText = NSMutableAttributedString(string: self.paragraphText)

                if input.count < paragraph.count {
                    for i in 0..<paragraph.count {
                        var correctColorIndicator: UIColor
                        let paragraphIndex = paragraph.index(paragraph.startIndex, offsetBy: i)

                        if i <= input.count-1 {
                            let textIndex = input.index(input.startIndex, offsetBy: i)
                            correctColorIndicator = paragraph[paragraphIndex] == input[textIndex] ? .highScoreColor : .lowScoreColor
                        } else {
                            correctColorIndicator = .blueThemeColor
                        }

                        attributedText.addAttribute(.foregroundColor, value: correctColorIndicator, range: NSRange(location: i, length: 1))
                    }

                    let font = UIFont(name: "HelveticaNeue-Medium", size: 13)!
                    attributedText.addAttribute(.font, value: font, range: NSRange(location: 0, length: paragraph.count-1))

                } else {
                    self.trial.accept(TrialModel(id: "", paragraph: paragraph, userID: UserDefaults.standard.object(forKey: Constants.cachedID) as? String, userInput: input, metrics: self.metricsModel))
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
                if input.count < self.paragraphText.count {
                    self.numCharactersTyped += 1
                    self.metricsModel.calculateAccuracy(userInput: input, paragraph: self.paragraphText, numCharactersTyped: self.numCharactersTyped)
                }
                return self.metricsModel.accuracy
            })
            .bind(to: accuracy)
            .disposed(by: disposeBag)

        Observable.combineLatest(userInput.asObservable(), timer.asObservable())
            .map({ [unowned self] input, time in
                if input.count < self.paragraphText.count {
                    self.metricsModel.calculateCPM(userInput: input, time: time)
                    self.metricsModel.time = time
                }
                return self.metricsModel.cpm
            })
            .bind(to: cpm)
            .disposed(by: disposeBag)

        Observable.combineLatest(userInput.asObservable(), timer.asObservable())
            .map({ [unowned self] input, time in
                if input.count < self.paragraphText.count {
                    self.metricsModel.calculateWPM(userInput: input, time: time)
                }
                return self.metricsModel.wpm
            })
            .bind(to: wpm)
            .disposed(by: disposeBag)
    }
}
