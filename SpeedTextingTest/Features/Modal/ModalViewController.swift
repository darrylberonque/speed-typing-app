//
//  GameModalViewController.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/28/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ModalViewController: UIViewController {

    @IBOutlet private weak var modalView: UIView!
    @IBOutlet private weak var headerView: HeaderView!
    @IBOutlet private weak var resultsView: ResultsView!
    @IBOutlet private weak var buttonView: ButtonView!

    private var disposeBag = DisposeBag()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        initViewModels()
    }

//    private func initViewModels() {
//        headerView.viewModel = HeaderViewModel(username: "Son Goku", url: "https://vignette.wikia.nocookie.net/dragonball/images/b/b9/Ultra_Instinct_Goku.png/revision/latest/scale-to-width-down/1000?cb=20180930060236", type: .result)
//        let metrics = MetricsModel(time: 30, cpm: 250, wpm: 50, accuracy: 92)
//        let trial = TrialModel(id: "1243", paragraph: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.", userID: "321", userInput: "userinput", metrics: metrics)
//        resultsView.viewModel = ResultsViewModel(trial: trial, displayType: .display)
//
//        buttonView.viewModel = ButtonViewModel(closable: false)
//
//        buttonView.viewModel.buttonViewState.asObservable().subscribe(onNext: { [unowned self] state in
//            switch state {
//            case .home:
//                ViewControllerPresenter.presentViewController(presenter: self, type: .home)
//            case .restart:
//                ViewControllerPresenter.presentViewController(presenter: self, type: .countdown)
//            case .closed:
//                self.view.removeFromSuperview()
//            }
//        }).disposed(by: disposeBag)
//    }
}
