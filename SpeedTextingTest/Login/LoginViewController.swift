//
//  LoginViewController.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/26/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet private weak var facebookButton: UIButton!
    @IBOutlet private weak var googleButton: UIButton!

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
    }

    private func configureButtons() {
        facebookButton.configureRoundedButton(color: .facebookColor)
        googleButton.configureRoundedButton(color: .googleColor)
    }
}
