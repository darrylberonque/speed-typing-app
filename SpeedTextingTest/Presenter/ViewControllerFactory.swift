//
//  ViewControllerFactory.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/26/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation
import UIKit

struct ViewControllerFactory {

    // MARK: - Configures view models for view controllers to be presented

    static func getViewController(type: ViewControllerType) -> UIViewController {

        switch type {
        case .login:
            return LoginViewController()
        case .home:
            return HomeViewController()
        case .countdown:
            return CountdownTimerViewController()
        case .game:
            return SpeedTextingViewController()
        case .trials:
            return TrialsViewController()
        case .leaderboard:
            return LeaderboardViewController()
        }

    }


}
