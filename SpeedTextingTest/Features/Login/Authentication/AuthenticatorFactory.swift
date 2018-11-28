//
//  AuthenticatorFactory.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/26/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation

enum AuthenticatorType: String {
    case facebook = "facebook"
    case google = "google"
}

struct AuthenticatorFactory {
    static func constructAuthenticator(type: AuthenticatorType) -> Authenticator {
        switch type {
        case .facebook:
            return FacebookAuthenticator()
        case .google:
            return GoogleAuthenticator()
        }
    }
}
