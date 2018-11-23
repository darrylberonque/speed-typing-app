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

class SpeedTextingViewModel {
    
    private var paragraphModel = ParagraphModel()
    private var metricsModel = MetricsModel()
    private var displayableParagraphMutableText: NSMutableAttributedString

    var userInput = PublishRelay<String>()
    var currentParagraphMutableText = PublishRelay<NSMutableAttributedString>()

    var timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
    var cpm = BehaviorRelay(value: 0.0)
    var wpm = BehaviorRelay(value: 0.0)
    var accuracy = BehaviorRelay(value: 0.0)

    var disposeBag = DisposeBag()

    init() {
        displayableParagraphMutableText = NSMutableAttributedString(string: paragraphModel.paragraphText)
        setupBindings()
    }

    private func setupBindings() {
        userInput.asObservable()
            .map({ [unowned self] text in
                for i in 0..<self.paragraphModel.paragraphText.count {
                    var correctColorIndicator: UIColor
                    let paragraphIndex = self.paragraphModel.paragraphText.index(self.paragraphModel.paragraphText.startIndex, offsetBy: i)

                    if i <= text.count-1 {
                        let textIndex = text.index(text.startIndex, offsetBy: i)
                        correctColorIndicator = self.paragraphModel.paragraphText[paragraphIndex] == text[textIndex] ? .green : .red
                    } else {
                        correctColorIndicator = .black
                    }

                    self.displayableParagraphMutableText.addAttribute(NSAttributedString.Key.foregroundColor, value: correctColorIndicator, range: NSRange(location: i, length: 1))
                }

                return self.displayableParagraphMutableText
            })
            .bind(to: currentParagraphMutableText)
            .disposed(by: disposeBag)

        userInput.asObservable()
            .distinctUntilChanged()
            .skip(1)
            .map({ [unowned self] input in
                self.metricsModel.numCharactersTyped += 1
                self.metricsModel.calculateAccuracy(userInput: input, paragraph: self.paragraphModel.paragraphText)
                return self.metricsModel.accuracy
            })
            .bind(to: accuracy)
            .disposed(by: disposeBag)

        Observable.combineLatest(userInput.asObservable(), timer.asObservable())
            .map({ [unowned self] input, time in
                self.metricsModel.calculateCPM(userInput: input, time: time)
                return self.metricsModel.cpm
            })
            .bind(to: cpm)
            .disposed(by: disposeBag)

        Observable.combineLatest(userInput.asObservable(), timer.asObservable())
            .map({ [unowned self] input, time in
                self.metricsModel.calculateWPM(userInput: input, time: time)
                return self.metricsModel.wpm
            })
            .bind(to: wpm)
            .disposed(by: disposeBag)
    }


}
