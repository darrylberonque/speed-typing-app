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

    // TODO: - Possibly make paragraph a model
    var paragraphText = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
    var paragraphMutableText: NSMutableAttributedString
    var currentUserInput = PublishRelay<String>()
    var currentParagraphMutableText = PublishRelay<NSMutableAttributedString>()

    // TODO: - Could also be a model
    var cpm = BehaviorRelay(value: 0)
    var wpm = BehaviorRelay(value: 0)
    var accuracy = BehaviorRelay(value: 0.0)

    var disposeBag = DisposeBag()

    init() {
        paragraphMutableText = NSMutableAttributedString(string: paragraphText)
        setupBindings()
    }

    private func setupBindings() {
        currentUserInput.asObservable()
            .map({ [unowned self] text in
                // TODO: - Could also be a model that manages returning an NSMutableAttributedString

                for i in 0...self.paragraphText.count-1 {
                    var correctColorIndicator: UIColor
                    let paragraphIndex = self.paragraphText.index(self.paragraphText.startIndex, offsetBy: i)

                    if i <= text.count-1 {
                        let textIndex = text.index(text.startIndex, offsetBy: i)
                        correctColorIndicator = self.paragraphText[paragraphIndex] == text[textIndex] ? .green : .red
                    } else {
                        correctColorIndicator = .black
                    }

                    self.paragraphMutableText.addAttribute(NSAttributedString.Key.foregroundColor, value: correctColorIndicator, range: NSRange(location: i, length: 1))
                }

                return self.paragraphMutableText
            })
            .bind(to: currentParagraphMutableText)
            .disposed(by: disposeBag)

        currentUserInput.asObservable()
            .map({ $0.count })
            .bind(to: cpm)
            .disposed(by: disposeBag)

    }


}
