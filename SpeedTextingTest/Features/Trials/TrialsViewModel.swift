//
//  TrialsViewModel.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/29/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class TrialsViewModel {

    var type: ViewControllerType
    var navBarViewModel: NavBarViewModel?
    var topMetricsViewModel: TopMetricsViewModel?
    var trialCellViewModels: [TrialCellViewModel] = []
    
    var initialize = BehaviorRelay(value: false)
    var sort = BehaviorRelay(value: MetricType.time)

    private var fetchUsers = BehaviorRelay(value: false)
    private var disposeBag = DisposeBag()

    init(type: ViewControllerType) {
        self.type = type
        initializeTrials()
        setupBindings()
    }

    private func initializeTrials() {
        switch type {
        case .userTrials:
            initUserTrials()
            navBarViewModel = NavBarViewModel(title: Constants.userTrialsTitle)
        case .leaderboard:
            initLeaderboardTrials()
            navBarViewModel = NavBarViewModel(title: Constants.leaderboardTitle)
        default:
            initUserTrials()
        }
    }

    private func setupBindings() {
        // TODO: - Setup bindings with nav bar sorting and back button, also gestures from top metrics vm
        guard let navBarViewModel = navBarViewModel else { return }
        navBarViewModel.selectedSort.asObservable()
            .bind(to: sort)
            .disposed(by: disposeBag)
    }

    // MARK: - UITableViewDataSource
    func sortedTrialCells() -> [TrialCellViewModel] {
        guard let navBarViewModel = navBarViewModel else { return [] }
        switch navBarViewModel.selectedSort.value {
        case .time:
            return trialCellViewModels
        case .accuracy:
            return trialCellViewModels.sorted(by: { first, second in
                return first.metricsRowViewModel.metrics.accuracy > second.metricsRowViewModel.metrics.accuracy
            })
        case .wpm:
            return trialCellViewModels.sorted(by: { first, second in
                return first.metricsRowViewModel.metrics.wpm > second.metricsRowViewModel.metrics.wpm
            })
        case .cpm:
            return trialCellViewModels.sorted(by: { first, second in
                return first.metricsRowViewModel.metrics.cpm > second.metricsRowViewModel.metrics.cpm
            })
        }
    }

    // MARK: - UITableViewDelegate

    func configureModalViewModel() {
        
    }

}

extension TrialsViewModel {
    private func initUserTrials() {
        guard let userID = UserDefaults.standard.object(forKey: Constants.cachedID) as? String else { return }
        RequestManager.getUser(userID: userID).subscribe(onNext: { [weak self] userResult in
            guard let welf = self, let user = userResult.user, let trials = user.trials else { return }
            
            trials.forEach({ trial in
                welf.trialCellViewModels.append(TrialCellViewModel(user: user, trial: trial))
            })

            welf.topMetricsViewModel = TopMetricsViewModel(metricsRowViewModel: MetricsRowViewModel(metrics: welf.getMaxMetricsModel()))

            welf.initialize.accept(true)
        }).disposed(by: disposeBag)
    }

    private func initLeaderboardTrials() {
        RequestManager.getAllTrials()
            .flatMap { Observable.from($0.trials) }
            .flatMap { [weak self] trial -> Observable<UserDecodableResult> in
                guard let welf = self, let userID = trial.userID else { return Observable.just(UserDecodableResult())}
                welf.trialCellViewModels.append(TrialCellViewModel(user: UserModel(), trial: trial))
                welf.topMetricsViewModel = TopMetricsViewModel(metricsRowViewModel: MetricsRowViewModel(metrics: welf.getMaxMetricsModel()))
                return RequestManager.getUser(userID: userID)
            }.subscribe(onNext: { [weak self] userResult in
                guard let welf = self, let user = userResult.user else { return }
                let userTrials = welf.trialCellViewModels.filter({ viewModel in
                    viewModel.trial.userID == user.id
                })
                userTrials.forEach({ $0.user = user })
                welf.initialize.accept(true)
            })
            .disposed(by: disposeBag)
    }

    private func getMaxMetricsModel() -> MetricsModel {
        let maxCPMTrialCellViewModel = trialCellViewModels.max(by: { first, second in
            return first.metricsRowViewModel.metrics.cpm < second.metricsRowViewModel.metrics.cpm
        })

        let maxWPMTrialCellViewModel = trialCellViewModels.max(by: { first, second in
            return first.metricsRowViewModel.metrics.wpm < second.metricsRowViewModel.metrics.wpm
        })

        let maxAccuracyTrialCellViewModel = trialCellViewModels.max(by: { first, second in
            return first.metricsRowViewModel.metrics.accuracy < second.metricsRowViewModel.metrics.accuracy
        })

        guard let maxCPMCell = maxCPMTrialCellViewModel, let maxWPMCell = maxWPMTrialCellViewModel, let maxAccuracyCell = maxAccuracyTrialCellViewModel else { return MetricsModel() }

        return MetricsModel(time: 0, cpm: maxCPMCell.metricsRowViewModel.metrics.cpm, wpm: maxWPMCell.metricsRowViewModel.metrics.wpm, accuracy: maxAccuracyCell.metricsRowViewModel.metrics.accuracy)
    }
}
