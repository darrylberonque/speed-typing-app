//
//  LoginViewModel.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/26/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation

protocol Authenticator {
    func authenticate()
}

final class LoginViewModel {

    var authenticator: Authenticator = AuthenticatorFactory.constructAuthenticator(type: .facebook)

    func login(type: AuthenticatorType) {
        authenticator = AuthenticatorFactory.constructAuthenticator(type: type)
        authenticator.authenticate()
    }
}
