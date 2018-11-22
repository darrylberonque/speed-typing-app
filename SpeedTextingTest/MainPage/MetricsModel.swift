//
//  MetricsModel.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/22/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation

struct MetricModel: Codable {
    var cpm: Double?
    var wpm: Double?
    var accuracy: Double?

    func calculateCPM(userInput: String, time: Int) -> Double {
        return time > 0 ? (Double(userInput.count) / Double(time)) * 60 : 0
    }

    func calculateWPM(userInput: String, time: Int) -> Double {
        return time > 0 ? ((Double(userInput.count) / Constants.oneWordCount) / Double(time)) * 60 : 0
    }

    func calculateAccuracy(userInput: String, paragraph: String) -> Double {
        var numCorrect = 0

        for i in 0..<userInput.count {
            let paragraphIndex = paragraph.index(paragraph.startIndex, offsetBy: i)
            let textIndex = userInput.index(userInput.startIndex, offsetBy: i)
            numCorrect = paragraph[paragraphIndex] == userInput[textIndex] ? numCorrect + 1 : numCorrect
        }

        return userInput.count > 0 ? ((Double(numCorrect) / Double(userInput.count)) * 100).rounded(.down) : 0.0
    }
}
