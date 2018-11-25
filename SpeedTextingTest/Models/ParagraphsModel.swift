//
//  ParagraphsModel.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/24/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation

struct ParagraphsModel: Codable {
    var paragraphs: [ParagraphModel]
}

struct ParagraphModel: Codable {
    var content: String
}
