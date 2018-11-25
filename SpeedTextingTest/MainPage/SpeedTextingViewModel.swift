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

    private var paragraphText = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
    private var metricsModel = MetricsModel()
    private var displayableParagraphMutableText: NSMutableAttributedString

    var userInput = PublishRelay<String>()
    var currentParagraphMutableText = PublishRelay<NSMutableAttributedString>()
    var numCharactersTyped = 0

    var timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
    var cpm = BehaviorRelay(value: 0.0)
    var wpm = BehaviorRelay(value: 0.0)
    var accuracy = BehaviorRelay(value: 0.0)

    var disposeBag = DisposeBag()

    init() {
        displayableParagraphMutableText = NSMutableAttributedString(string: paragraphText)
        setupBindings()
    }

    private func setupBindings() {
        // TODO: - Organize the bindings into readable functions
        userInput.asObservable()
            .map({ [unowned self] text in
                for i in 0..<self.paragraphText.count {
                    var correctColorIndicator: UIColor
                    let paragraphIndex = self.paragraphText.index(self.paragraphText.startIndex, offsetBy: i)

                    if i <= text.count-1 {
                        let textIndex = text.index(text.startIndex, offsetBy: i)
                        correctColorIndicator = self.paragraphText[paragraphIndex] == text[textIndex] ? .green : .red
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
                // TODO: - Look over this logic if you can improve the structure
                self.numCharactersTyped += 1
                self.metricsModel.calculateAccuracy(userInput: input, paragraph: self.paragraphText, numCharactersTyped: self.numCharactersTyped)
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
