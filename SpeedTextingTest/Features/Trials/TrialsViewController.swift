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

    var viewModel: TrialsViewModel
    private var disposeBag = DisposeBag()

    init(type: ViewControllerType = .userTrials) {
        viewModel = TrialsViewModel(type: type)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        configureTableView()
    }

    private func setupBindings() {
        viewModel.sort.asDriver().drive(onNext: { [unowned self] sort in
            self.tableView.reloadData()
        }).disposed(by: disposeBag)

        viewModel.dismiss.asDriver().drive(onNext: { dismiss in
            if dismiss {
                ViewControllerPresenter.presentViewController(presenter: self, type: .home)
            }
        }).disposed(by: disposeBag)

        viewModel.initialize.asObservable()
            .subscribe(onNext: { [weak self] initialize in
                guard let welf = self else { return }
                if initialize {
                    guard let navBarViewModel = welf.viewModel.navBarViewModel, let topMetricsViewModel = welf.viewModel.topMetricsViewModel else { return }
                    DispatchQueue.main.async {
                        welf.navBarView.viewModel = navBarViewModel
                        welf.topMetricsView.viewModel = topMetricsViewModel
                        welf.tableView.reloadData()
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Constants.userTrialCellNibName, bundle: Bundle.main), forCellReuseIdentifier: Constants.userTrialCellNibName)
        tableView.register(UINib(nibName: Constants.leaderboardTrialCellNibName, bundle: Bundle.main), forCellReuseIdentifier: Constants.leaderboardTrialCellNibName)
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
    }
}

extension TrialsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.trialCellViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let trial = viewModel.sortedTrialCells()[indexPath.row].trial

        if viewModel.type == .userTrials, let userTrialCell = tableView.dequeueReusableCell(withIdentifier: Constants.userTrialCellNibName) as? UserTrialTableViewCell {
            userTrialCell.viewModel = TrialCellViewModel(user: UserModel(), trial: trial)
            userTrialCell.selectionStyle = .none
            return userTrialCell
        } else if viewModel.type == .leaderboard, let leaderboardTrialCell = tableView.dequeueReusableCell(withIdentifier: Constants.leaderboardTrialCellNibName) as? LeaderboardTrialTableViewCell {
            leaderboardTrialCell.viewModel = TrialCellViewModel(user: viewModel.sortedTrialCells()[indexPath.row].user, trial: trial)
            leaderboardTrialCell.selectionStyle = .none
            return leaderboardTrialCell
        } else {
            return UITableViewCell()
        }
    }
}

extension TrialsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
