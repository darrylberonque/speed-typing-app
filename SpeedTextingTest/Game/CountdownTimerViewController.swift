//
//  CounterViewController.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/27/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class CountdownTimerViewController: UIViewController {

    @IBOutlet private weak var counterLabel: UILabel!

    private var countdownValues = [3,2,1]
    private var timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
    private var disposeBag = DisposeBag()

    init() {
        super.init(nibName: nil, bundle: nil)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

    private func setupBindings() {
        timer.asObservable()
            .map({ index in
                let countdownLabelText = index < self.countdownValues.count ? String(self.countdownValues[index]) : Constants.countdownTimerFinalText
                return countdownLabelText
            })
            .bind(to: counterLabel.rx.text)
            .disposed(by: disposeBag)

        timer.asObservable().subscribe(onNext: { time in
            if time == self.countdownValues.count {
                ViewControllerPresenter.presentViewController(presenter: self, type: .game)
            }
        }).disposed(by: disposeBag)
    }
}
