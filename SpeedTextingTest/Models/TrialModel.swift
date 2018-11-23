//
//  SpeedTextingResultModel.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/22/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation

struct TrialModel: Codable {
    var rank: Int
    var paragraphModel: ParagraphModel
    var metricsModel: MetricsModel
}
