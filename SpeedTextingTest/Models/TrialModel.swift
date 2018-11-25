//
//  SpeedTextingResultModel.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/22/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation

struct TrialsModel: Codable {
    var trials: [TrialModel]
}

struct TrialEncodableResult: Codable {
    var trial: TrialModel?

    enum CodingKeys: String, CodingKey {
        case trial = "postTrial"
    }
}

struct TrialModel: Codable {
    var id: String?
    var paragraph: String?
    var userID: String?
    var userInput: String?
    var metrics: MetricsModel?
}
