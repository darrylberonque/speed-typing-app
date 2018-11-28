//
//  ModalViewController.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/28/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import UIKit

final class ModalViewController: UIViewController {

    @IBOutlet weak var backgroundBlurView: UIView!
    @IBOutlet weak var modalView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        modalView.addShadow(radius: 3.0, color: .black, opacity: 0.25)
    }
}
