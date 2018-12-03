//
//  Double.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/27/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation

extension Double {
    func convertToStrokeEndValue(type: MetricType) -> Double {
        return self / Double(type.maxValue)
    }

    func truncate(decimals: Int) -> Double {

        let divisor = pow(10.0, Double(decimals))

        return (self * divisor).rounded() / divisor
    }
}
