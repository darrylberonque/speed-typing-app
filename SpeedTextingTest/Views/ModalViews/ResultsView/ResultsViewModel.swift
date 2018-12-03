//
//  ResultsViewModel.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/28/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation

final class ResultsViewModel {

    var trial: TrialModel?
    var displayType: MetricDisplayType

    init(trial: TrialModel? = nil, displayType: MetricDisplayType) {
        self.trial = trial
        self.displayType = displayType
    }

    
}
