//
//  FacebookAuthenticator.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/26/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation

struct FacebookAuthenticator: Authenticator {

    func authenticate() {
        FBSignIn.sharedInstance.signIn()
    }

}
