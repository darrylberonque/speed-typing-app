//
//  HomeViewController.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/26/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {

    @IBOutlet private weak var trialsButtonContainer: UIView!
    @IBOutlet private weak var trialsButton: UIButton!
    @IBOutlet private weak var leaderboardButton: UIButton!
    @IBOutlet private weak var leaderboardButtonContainer: UIView!
    @IBOutlet private weak var startTypingButton: UIButton!

    private var disposeBag = DisposeBag()

    // MARK: - Lifecycle

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupBindings()
    }

    // MARK: - UI Configuration

    private func configureUI() {
        leaderboardButtonContainer.layer.cornerRadius = trialsButtonContainer.frame.width/2
        leaderboardButtonContainer.addShadow(radius: 3, color: .black, opacity: 0.25)
        trialsButtonContainer.layer.cornerRadius = trialsButtonContainer.frame.width/2
        trialsButtonContainer.addShadow(radius: 3, color: .black, opacity: 0.25)
        startTypingButton.configureRoundedButton(color: .blueThemeColor)
        startTypingButton.addShadow(radius: 3, color: .black, opacity: 0.25)
    }

    private func setupBindings() {
        leaderboardButton.rx.tap.asObservable()
            .single()
            .subscribe(onNext: { [unowned self] _ in
                ViewControllerPresenter.presentViewController(presenter: self, type: .leaderboard)
            })
            .disposed(by: disposeBag)
        trialsButton.rx.tap.asObservable()
            .single()
            .subscribe(onNext: { [unowned self] _ in
                ViewControllerPresenter.presentViewController(presenter: self, type: .userTrials)
            })
            .disposed(by: disposeBag)
        startTypingButton.rx.tap.asObservable()
            .single()
            .subscribe(onNext: { [unowned self] _ in
                ViewControllerPresenter.presentViewController(presenter: self, type: .countdown)
            })
            .disposed(by: disposeBag)
    }
}
