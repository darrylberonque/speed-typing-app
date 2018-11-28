//
//  UserDisplayViewModel.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/28/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation

final class HeaderViewModel {

    var headerType: HeaderViewType
    var usernameText: String?
    var imageURLString: String?

    init(username: String? = nil, url: String? = nil, type: HeaderViewType) {
        usernameText = username
        imageURLString = url
        headerType = type
    }

}
