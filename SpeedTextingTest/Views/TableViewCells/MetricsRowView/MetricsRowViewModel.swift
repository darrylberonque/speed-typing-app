//
//  MetricsRowViewModel.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/28/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation

final class MetricsRowViewModel {

    var metrics: MetricsModel

    init(metrics: MetricsModel) {
        self.metrics = metrics
    }

    func configuredMetricViewModel(type: MetricType) -> MetricViewModel {
        switch type {
        case .accuracy:
            return MetricViewModel(type: .accuracy, value: metrics.accuracy, displayType: .display)
        case .wpm:
            return MetricViewModel(type: .wpm, value: metrics.wpm, displayType: .display)
        case .cpm:
            return MetricViewModel(type: .cpm, value: metrics.cpm, displayType: .display)
        default:
            return MetricViewModel(type: .accuracy, value: 0.0, displayType: .display)
        }
    }
}
