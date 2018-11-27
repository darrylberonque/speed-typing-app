//
//  HomeViewController.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/26/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet private weak var trialsButtonContainer: UIView!
    @IBOutlet private weak var trialsButton: UIButton!
    @IBOutlet private weak var leaderboardButton: UIButton!
    @IBOutlet private weak var leaderboardButtonContainer: UIView!
    @IBOutlet private weak var startTypingButton: UIButton!

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        leaderboardButtonContainer.layer.cornerRadius = trialsButtonContainer.frame.width/2
        leaderboardButtonContainer.addShadow(radius: 3, color: .black, opacity: 0.25)
        trialsButtonContainer.layer.cornerRadius = trialsButtonContainer.frame.width/2
        trialsButtonContainer.addShadow(radius: 3, color: .black, opacity: 0.25)
        startTypingButton.configureRoundedButton(color: .blueThemeColor)
        startTypingButton.addShadow(radius: 3, color: .black, opacity: 0.25)
    }
}
