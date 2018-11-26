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

final class SpeedTextingViewController: UIViewController {

    @IBOutlet private weak var paragraphTextView: UITextView!
    @IBOutlet private weak var userTextInput: UITextField!

    @IBOutlet private weak var cpmLabel: UILabel!
    @IBOutlet private weak var wpmLabel: UILabel!
    @IBOutlet private weak var accuracyLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!

    private var viewModel = SpeedTextingViewModel()
    private var disposeBag = DisposeBag()
    private var timer = Timer()

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
            .bind(to: viewModel.userInput)
            .disposed(by: disposeBag)

        viewModel.timer.asObservable().subscribe(onNext: { [unowned self] time in
            self.timeLabel.text = "\(time) s"
        }).disposed(by: disposeBag)

        viewModel.cpm.asDriver().drive(onNext: { [unowned self] cpm in
            self.cpmLabel.text = "\(cpm.rounded(.toNearestOrAwayFromZero))"
        }).disposed(by: disposeBag)

        viewModel.wpm.asDriver().drive(onNext: { [unowned self] wpm in
            self.wpmLabel.text = "\(wpm.rounded(.toNearestOrAwayFromZero))"
        }).disposed(by: disposeBag)

        viewModel.accuracy.asDriver().drive(onNext: { [unowned self] accuracy in
            self.accuracyLabel.text = "\(accuracy) %"
        }).disposed(by: disposeBag)

        viewModel.currentParagraphMutableText.asDriver(onErrorJustReturn: NSMutableAttributedString(string:"")).drive(onNext: { [unowned self] currentParagraph in
            self.paragraphTextView.attributedText = currentParagraph
        }).disposed(by: disposeBag)

    }
}
