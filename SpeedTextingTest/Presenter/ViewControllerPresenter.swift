//
//  ViewControllerPresenter.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/26/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation
import UIKit

enum ViewControllerType {
    case login
    case game
}

final class ViewControllerPresenter {
    class func presentViewController(presenter: UIViewController, type: ViewControllerType) {
        presenter.present(ViewControllerFactory.getViewController(type: type), animated: true, completion: nil)
    }
}
