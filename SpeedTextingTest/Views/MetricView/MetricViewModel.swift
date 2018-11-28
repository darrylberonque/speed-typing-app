//
//  MetricViewModel.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/27/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum MetricType: String {
    case wpm = "WPM"
    case cpm = "CPM"
    case accuracy = "Accuracy (%)"

    var maxValue: Int {
        switch self {
        case .wpm:
            return Constants.wpmMax
        case .cpm:
            return Constants.cpmMax
        case .accuracy:
            return Constants.accuracyMax
        }
    }
}

enum MetricDisplayType {
    case live
    case animate
    case display
}

final class MetricViewModel {

    private var metricCircleViewModel = MetricCircleViewModel()

    var type: MetricType
    var title: String
    var displayType: MetricDisplayType
    var value = BehaviorRelay(value: 0.0)
    var strokeEnd = BehaviorRelay(value: 0.0)

    init(type: MetricType, value: Double, displayType: MetricDisplayType) {
        self.type = type
        self.title = type.rawValue
        self.displayType = displayType
        self.value.accept(value)
        self.strokeEnd.accept(value.convertToStrokeEndValue(type: type))
    }


}
