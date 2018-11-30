//
//  TrialsViewController.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/26/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class TrialsViewController: UIViewController {

    @IBOutlet private weak var navBarView: NavBarView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var topMetricsView: TopMetricsView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var loadingScreen: UIView!

    var viewModel: TrialsViewModel
    private var disposeBag = DisposeBag()
    private var popUp = false

    // MARK: - Lifecycle

    init(type: ViewControllerType = .userTrials) {
        viewModel = TrialsViewModel(type: type)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.startAnimating()
        configureTableView()
        setupBindings()
    }

    // MARK: - Bindings and UI Setup

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Constants.userTrialCellNibName, bundle: Bundle.main), forCellReuseIdentifier: Constants.userTrialCellNibName)
        tableView.register(UINib(nibName: Constants.leaderboardTrialCellNibName, bundle: Bundle.main), forCellReuseIdentifier: Constants.leaderboardTrialCellNibName)
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
    }

    private func setupBindings() {
        setupUIAnimationBindings()
        setupViewModelBindings()
    }
    
    private func setupUIAnimationBindings() {
        topMetricsView.rx
            .panGesture(configuration: { gestureRecognizer, delegate in
                delegate.otherFailureRequirementPolicy = .always
            })
            .subscribe(onNext: { [unowned self] gesture in
                let translation = gesture.translation(in: self.topMetricsView)
                if (self.topMetricsView.center.y > (UIScreen.main.bounds.height - CGFloat(Constants.topMetricsUpperLimitOffset)) && translation.y <= 0) || (self.topMetricsView.center.y  < (UIScreen.main.bounds.height + CGFloat(Constants.topMetricsLowerLimitOffset)) && translation.y >= 0) {
                    self.topMetricsView.center = CGPoint(x: self.topMetricsView.center.x, y: self.topMetricsView.center.y + translation.y)
                    gesture.setTranslation(CGPoint.zero, in: self.topMetricsView)
                }
            })
            .disposed(by: disposeBag)
        
        tableView.rx.contentOffset.asObservable().subscribe(onNext: { offset in
            if offset.y <= 0.0 {
                self.navBarView.addShadow(radius: 0.0, color: .clear, opacity: 0.0)
            } else {
                self.navBarView.addShadow(radius: 5.0, color: .black, opacity: 1.0)
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupViewModelBindings() {
        viewModel.sort.asDriver().drive(onNext: { [unowned self] sort in
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.dismiss.asDriver().drive(onNext: { dismiss in
            if dismiss {
                ViewControllerPresenter.presentViewController(presenter: self, type: .home)
            }
        }).disposed(by: disposeBag)
        
        viewModel.initialize.asObservable()
            .skip(1)
            .single()
            .subscribe(onNext: { [weak self] initialize in
                guard let welf = self else { return }
                if initialize {
                    guard let navBarViewModel = welf.viewModel.navBarViewModel, let topMetricsViewModel = welf.viewModel.topMetricsViewModel else { return }
                    DispatchQueue.main.async {
                        welf.spinner.stopAnimating()
                        welf.loadingScreen.isHidden = true
                        welf.navBarView.viewModel = navBarViewModel
                        welf.topMetricsView.viewModel = topMetricsViewModel
                        welf.tableView.reloadData()
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}

extension TrialsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.trialCellViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.type == .userTrials, let userTrialCell = tableView.dequeueReusableCell(withIdentifier: Constants.userTrialCellNibName) as? UserTrialTableViewCell {
            userTrialCell.viewModel = viewModel.sortedTrialCells()[indexPath.row]
            userTrialCell.selectionStyle = .none
            return userTrialCell
        } else if viewModel.type == .leaderboard, let leaderboardTrialCell = tableView.dequeueReusableCell(withIdentifier: Constants.leaderboardTrialCellNibName) as? LeaderboardTrialTableViewCell {
            leaderboardTrialCell.viewModel = viewModel.sortedTrialCells()[indexPath.row]
            leaderboardTrialCell.selectionStyle = .none
            return leaderboardTrialCell
        } else {
            return UITableViewCell()
        }
    }
}

extension TrialsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let modalVC = ModalViewController(viewModel: viewModel.configureModalViewModel(row: indexPath.row))
        modalVC.view.frame = view.frame
        view.addSubview(modalVC.view)
    }
}
