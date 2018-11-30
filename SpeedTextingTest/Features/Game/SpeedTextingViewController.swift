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
    @IBOutlet private weak var accuracyMetricView: MetricView!
    @IBOutlet private weak var wpmMetricView: MetricView!
    @IBOutlet private weak var cpmMetricView: MetricView!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var timeViewContainer: UIView!

    private var viewModel = SpeedTextingViewModel()
    private var disposeBag = DisposeBag()
    private var timer = Timer()
    private var user: UserModel?

    // MARK: - Lifecycle

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()
        setupMetricCounters()
        setupBindings()
        setupUI()
    }

    // MARK: - Configure properties

    // TODO: - Generalized with inheritance using a top level VC
    private func getUser() {
        guard let userID = UserDefaults.standard.object(forKey: Constants.cachedID) as? String else { return }
        RequestManager.getUser(userID: userID).subscribe(onNext: { userResult in
            self.user = userResult.user
        }).disposed(by: disposeBag)
    }

    private func setupMetricCounters() {
        accuracyMetricView.viewModel = MetricViewModel(type: .accuracy, value: 0.0, displayType: .live)
        wpmMetricView.viewModel = MetricViewModel(type: .wpm, value: 0.0, displayType: .live)
        cpmMetricView.viewModel = MetricViewModel(type: .cpm, value: 0.0, displayType: .live)
    }

    private func setupUI() {
        IQKeyboardManager.shared.enable = true
        userTextInput.becomeFirstResponder()
        timeViewContainer.addShadow(radius: 3.0, color: .black, opacity: 0.25)
    }

    private func setupBindings() {
        userTextInput.autocorrectionType = .no
        userTextInput.rx.text
            .orEmpty
            .bind(to: viewModel.userInput)
            .disposed(by: disposeBag)

        viewModel.currentParagraphMutableText.asDriver(onErrorJustReturn: NSMutableAttributedString(string:"")).drive(onNext: { [unowned self] currentParagraph in
            self.paragraphTextView.attributedText = currentParagraph
            self.paragraphTextView.textAlignment = .center
        }).disposed(by: disposeBag)

        viewModel.timer.asObservable().subscribe(onNext: { [unowned self] time in
            self.timeLabel.text = "\(time) s"
        }).disposed(by: disposeBag)

        viewModel.cpm.asDriver().drive(onNext: { [unowned self] cpm in
            self.cpmMetricView.updateGameState(value: cpm.rounded(.toNearestOrAwayFromZero))
        }).disposed(by: disposeBag)

        viewModel.wpm.asDriver().drive(onNext: { [unowned self] wpm in
            self.wpmMetricView.updateGameState(value: wpm.rounded(.toNearestOrAwayFromZero))
        }).disposed(by: disposeBag)

        viewModel.accuracy.asDriver().drive(onNext: { [unowned self] accuracy in
            self.accuracyMetricView.updateGameState(value: accuracy)
        }).disposed(by: disposeBag)

        viewModel.trial.asObservable()
            .skip(1)
            .single()
            .subscribe(onNext: { [unowned self] trial in
                self.timeLabel.isHidden = true
                guard let user = self.user else { return }
                let modalVC = ModalViewController(viewModel: ModalViewModel(type: .result, trial: trial, user: user ))
                self.userTextInput.resignFirstResponder()

                modalVC.view.frame = self.view.frame
                self.view.addSubview(modalVC.view)

                RequestManager.postTrial(trialResult: TrialEncodableResult(trial: trial))
                    .subscribe()
                    .disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
    }
}
