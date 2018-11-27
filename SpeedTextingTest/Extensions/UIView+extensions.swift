//
//  UIView+extensions.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/26/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addShadow(radius: CGFloat, color: UIColor, opacity: Float) {
        layer.shadowRadius = radius
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}
