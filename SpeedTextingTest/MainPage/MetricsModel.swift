//
//  MetricsModel.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/22/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation

struct MetricsModel: Codable {
    var rank: Int?

    var cpm = 0.0
    var wpm = 0.0
    var accuracy = 0.0
    var numCharactersTyped = 0

    mutating func calculateCPM(userInput: String, time: Int) {
        cpm = time > 0 ? (Double(userInput.count) / Double(time)) * 60 : 0
    }

    mutating func calculateWPM(userInput: String, time: Int) {
        wpm = time > 0 ? ((Double(userInput.count) / Constants.oneWordCount) / Double(time)) * 60 : 0
    }

    mutating func calculateAccuracy(userInput: String, paragraph: String) {
        var numCorrect = 0

        for i in 0..<userInput.count {
            let paragraphIndex = paragraph.index(paragraph.startIndex, offsetBy: i)
            let textIndex = userInput.index(userInput.startIndex, offsetBy: i)

            if paragraph[paragraphIndex] == userInput[textIndex] {
                numCorrect += 1
            }
        }

        accuracy = userInput.count > 0 ? ((Double(numCorrect) / Double(numCharactersTyped)) * 100).rounded(.down) : 0.0
    }
}
