//
//  LoginViewController.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/26/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import GoogleSignIn
import RxSwift

final class LoginViewController: UIViewController {

    @IBOutlet private weak var facebookButton: UIButton!
    @IBOutlet private weak var googleButton: UIButton!

    private var viewModel: LoginViewModel = LoginViewModel()
    private var disposeBag: DisposeBag = DisposeBag()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
        configureSignInDelegates()
    }

    private func configureButtons() {
        facebookButton.configureRoundedButton(color: .facebookColor)
        googleButton.configureRoundedButton(color: .googleColor)
    }

    private func configureSignInDelegates() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        FBSignIn.sharedInstance.delegate = self
    }

    func constructUser(name: String, email: String, imageURL: String, authID: String) {
        var user = UserModel()
        user.name = name
        user.email = email
        user.imageURL = imageURL
        user.authID = authID

        RequestManager.postUser(userResult: UserEncodableResult(user: user))
            .subscribe(onNext: { userResult in
                guard let id = userResult.user?.id else { return }
                UserDefaults.standard.set(id, forKey: Constants.cachedID)
                DispatchQueue.main.async {
                    ViewControllerPresenter.presentViewController(presenter: self, type: .home)
                }
            })
            .disposed(by: disposeBag)
    }

    @IBAction func loginWithFacebook(_ sender: UIButton) {
        viewModel.login(type: .facebook)
    }

    @IBAction func loginWithGoogle(_ sender: UIButton) {
        viewModel.login(type: .google)
    }

}
