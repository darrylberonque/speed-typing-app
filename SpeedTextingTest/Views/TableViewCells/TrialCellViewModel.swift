//
//  TrialCellViewModel.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/29/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation

final class TrialCellViewModel {

    var user: UserModel
    var trial: TrialModel
    var metricsRowViewModel: MetricsRowViewModel

    init(user: UserModel, trial: TrialModel) {
        self.user = user
        self.trial = trial
        self.metricsRowViewModel = MetricsRowViewModel(metrics: trial.metrics!)
    }
}
