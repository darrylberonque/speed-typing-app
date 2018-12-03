//
//  UIButton+extensions.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/26/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func configureRoundedButton(color: UIColor) {
        backgroundColor = color
        layer.cornerRadius = CGFloat(Constants.buttonCornerRadius)
        tintColor = .white
    }
}
