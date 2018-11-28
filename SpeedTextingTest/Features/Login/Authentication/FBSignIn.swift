//
//  FBSignIn.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/26/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation
import FacebookLogin

protocol FBSignInDelegate {
    func signIn(loginManager: LoginManager)
}

final class FBSignIn {
    var delegate: FBSignInDelegate?

    private init() {}

    static var sharedInstance = FBSignIn()

    func signIn() {
        delegate?.signIn(loginManager: LoginManager())
    }
}
