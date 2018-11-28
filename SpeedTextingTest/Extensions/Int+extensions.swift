//
//  Integer+extension.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/23/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation

extension Int {
    static func randomIntInRange(low: Int, high: Int) -> Int {
        return Int(arc4random_uniform(UInt32(high)) + UInt32(low))
    }
}
