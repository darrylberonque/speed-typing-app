//
//  SpeedTextingViewController.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/21/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import RxSwift
import RxCocoa

class SpeedTextingViewController: UIViewController {

    @IBOutlet private weak var paragraphTextView: UITextView!
    @IBOutlet private weak var userTextInput: UITextField!

    @IBOutlet private weak var cpmLabel: UILabel!
    @IBOutlet private weak var wpmLabel: UILabel!
    @IBOutlet private weak var accuracyLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!

    private var viewModel = SpeedTextingViewModel()
    private var disposeBag = DisposeBag()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.enable = true
        userTextInput.becomeFirstResponder()
        setupBindings()
    }

    private func setupBindings() {
        userTextInput.autocorrectionType = .no
        userTextInput.rx.text
            .orEmpty
            .bind(to: viewModel.currentUserInput)
            .disposed(by: disposeBag)

        viewModel.cpm.asDriver().drive(onNext: { currentCPM in
            print(currentCPM)
        }).disposed(by: disposeBag)

        viewModel.wpm.asDriver().drive(onNext: { currentWPM in
            print(currentWPM)
        }).disposed(by: disposeBag)

        viewModel.accuracy.asDriver().drive(onNext: { currentAccuracy in
            print(currentAccuracy)
        }).disposed(by: disposeBag)

        viewModel.currentParagraphMutableText.asDriver(onErrorJustReturn: NSMutableAttributedString(string: viewModel.paragraphText)).drive(onNext: { [unowned self] currentParagraph in
            self.paragraphTextView.attributedText = currentParagraph
        }).disposed(by: disposeBag)

    }
}
