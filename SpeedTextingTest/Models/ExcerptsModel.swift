//
//  ExcerptModel.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/23/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation

struct ExcerptsModel: Codable {
    var excerpts: [ExcerptModel]

    enum CodingKeys: String, CodingKey {
        case excerpts = "items"
    }
}

struct ExcerptModel: Codable {
    var body: String
    var excerpt: String
}

