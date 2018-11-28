//
//  MetricCircleViewModel.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/27/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class MetricCircleViewModel {
    var strokeEnd = BehaviorRelay(value: 0.0)
    var valueLevel = BehaviorRelay(value: MetricLevel.low)

    private var disposeBag = DisposeBag()

    init() {
        setupBindings()
    }

    private func setupBindings() {
        strokeEnd.asObservable()
            .map({ currentStrokeEnd in
                if currentStrokeEnd <= Constants.lowStrokeEndLimit {
                    return MetricLevel.low
                } else if currentStrokeEnd <= Constants.mediumStrokeEndLimit {
                    return MetricLevel.medium
                } else if currentStrokeEnd <= Constants.highStrokeEndLimit {
                    return MetricLevel.high
                } else {
                    return MetricLevel.perfect
                }
            })
            .bind(to: valueLevel)
            .disposed(by: disposeBag)
    }
}
