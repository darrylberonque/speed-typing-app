//
//  UserModel.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/24/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation

struct UserEncodableResult: Codable {
    var user: UserModel?

    enum CodingKeys: String, CodingKey {
        case user = "postUser"
    }
}

struct UserDecodableResult: Codable {
    var user: UserModel?
}

struct UserModel: Codable {
    var id: String?
    var name: String?
    var email: String?
    var imageURL: String?
    var authID: String?
    var trials: [TrialModel]?
}
