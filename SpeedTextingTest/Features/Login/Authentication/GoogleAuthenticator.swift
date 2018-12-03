//
//  GoogleAuthenticator.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/26/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation
import GoogleSignIn

struct GoogleAuthenticator: Authenticator {

    var delegate: GIDSignInDelegate?

    init() {
        GIDSignIn.sharedInstance().clientID = "25343531244-pkhbeo60jud64rmmkno3mbdur50qvftu.apps.googleusercontent.com"
    }

    func authenticate() {
        GIDSignIn.sharedInstance().signIn()
    }

}
