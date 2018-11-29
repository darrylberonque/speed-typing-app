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
    private var viewModel: ModalViewModel?

    init(viewModel: ModalViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initModalState()
        setupButtonBindings()
    }

    private func initModalState() {
        modalView.addShadow(radius: 3.0, color: .black, opacity: 0.25)
        
        guard let viewModel = self.viewModel else { return }
        headerView.viewModel = viewModel.configuredHeaderViewModel()
        resultsView.viewModel = viewModel.configuredResultsViewModel()
        buttonView.viewModel = viewModel.configuredButtonViewModel()
    }

    private func setupButtonBindings() {
        buttonView.viewModel.buttonViewState.asObservable().subscribe(onNext: { [unowned self] state in
            switch state {
            case .home:
                ViewControllerPresenter.presentViewController(presenter: self, type: .home)
            case .restart:
                ViewControllerPresenter.presentViewController(presenter: self, type: .countdown)
            case .closed:
                self.view.removeFromSuperview()
            }
        }).disposed(by: disposeBag)
    }
}
