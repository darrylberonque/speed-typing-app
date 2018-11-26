//
//  LoginViewController+Extensions.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/26/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation
import FacebookLogin
import FacebookCore
import GoogleSignIn
import RxSwift

extension LoginViewController: FBSignInDelegate {
    func signIn(loginManager: LoginManager) {
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { [weak self] loginResult in
            guard let welf = self else { return }
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success:
                DispatchQueue.main.async {
                    welf.getFBInfo()
                }
                break
            }
        }
    }

    private func getFBInfo() {
        let request = GraphRequest(graphPath: "me", parameters: ["fields":"email,name,picture.type(square)"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: FacebookCore.GraphAPIVersion.defaultVersion)
        request.start { [weak self] (response, result) in
            guard let welf = self else { return }
            switch result {
            case .success(let value):
                guard let userInfo = value.dictionaryValue, let name = userInfo["name"] as? String, let email = userInfo["email"] as? String, let picture = userInfo["picture"] as? [String : Any], let pictureData = picture["data"] as? [String : Any], let imageURL = pictureData["url"] as? String, let appID = AccessToken.current?.appId else { return }

                DispatchQueue.main.async {
                    welf.constructUser(name: name, email: email, imageURL: imageURL, authID: "\(appID)\(email)", type: .facebook)
                }
            case .failed(let error):
                print(error)
            }
        }
    }
}

extension LoginViewController: GIDSignInDelegate, GIDSignInUIDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            DispatchQueue.main.async {
                if let imageURL = user.profile.imageURL(withDimension: 900) {
                    self.constructUser(name: user.profile.name, email: user.profile.email, imageURL: imageURL.absoluteString, authID: user.userID, type: .google)
                } else {
                    self.constructUser(name: user.profile.name, email: user.profile.email, imageURL: Constants.defaultProfileImageURL, authID: user.userID, type: .google)
                }
            }
        }
    }
}
