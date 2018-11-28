//
//  Constants.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/22/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation
import UIKit

class Constants {
    // MARK: - UI Constants
    static let buttonCornerRadius = 25
    static let leaderboardImageName = "leaderboard"
    static let trialsImageName = "trials"
    static let countdownTimerFinalText = "Go!"
    static let metricCircleStartAngle = (3/2) * CGFloat.pi
    static let metricCircleEndAngle = metricCircleStartAngle + (2 * CGFloat.pi)
    static let backButtonBorderWidth = 2.0


    // MARK: - Login Constants
    static let defaultProfileImageURL = "http://mainenordmenn.com/wp-content/uploads/2017/09/Maine-Nordmenn-Board-Generic-Profile.jpg"
    static let cachedID = "userID"

    // MARK: - Main Page Constants
    static let oneWordCount = 5.0
    static let stackOverFlowPageLimit = 1000
    static let minimumBodyWordCount = 350
    static let defaultParagraph = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."

    // MARK: - Network Constants
    static let baseURL = "https://speed-typing-app.herokuapp.com"
    static let stackOverflowBaseURL = "https://api.stackexchange.com/2.2"
    static let postHeader = "application/json"
    static let contentType = "Content-Type"
    static let accept = "Accept"
    static let rootQueryString = "data"

    // MARK: - Metric View Constants
    static let metricCircleLineWidth = 30
    static let circleAnimationDuration = 1.0

    static let lowStrokeEndLimit = 0.33
    static let mediumStrokeEndLimit = 0.66
    static let highStrokeEndLimit = 1.0

    static let cpmMax = 450
    static let wpmMax = 90
    static let accuracyMax = 100

    static let strokeEndKeypath = "strokeEnd"
    static let metricCircleAnimateKeypath = "animateMetricCircle"

}
