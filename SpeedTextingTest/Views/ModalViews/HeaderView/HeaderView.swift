//
//  UserDisplayView.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/28/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import UIKit

enum HeaderViewType {
    case user
    case result
}

final class HeaderView: UIView {
    
    @IBOutlet private var headerView: UIView!
    @IBOutlet private weak var imageContainerView: UIView!
    @IBOutlet private weak var userProfileImage: UIImageView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var resultsLabel: UILabel!

    var viewModel = HeaderViewModel(type: .user) {
        didSet {
            toggleUIStateTo(type: viewModel.headerType)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initHeaderView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initHeaderView()
    }

    // TODO: - Generalize UIView initialization w/ inheritance.
    private func initHeaderView() {
        Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)
        addSubview(headerView)
        headerView.frame = self.bounds
        headerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        imageContainerView.layer.cornerRadius = imageContainerView.frame.width/2
        userProfileImage.clipsToBounds = true
        userProfileImage.layer.cornerRadius = userProfileImage.frame.width/2
    }

    private func toggleUIStateTo(type: HeaderViewType) {
        switch type {
        case .user:
            populateUserInfo()
            resultsLabel.isHidden = true
        case .result:
            imageContainerView.isHidden = true
            usernameLabel.isHidden = true
        }
    }

    private func populateUserInfo() {
        guard let username = viewModel.usernameText, let imageURLString = viewModel.imageURLString else { return }
        usernameLabel.text = username

        do {
            guard let imageURL = URL(string: imageURLString) else { return }
            let imageData = try Data(contentsOf: imageURL)
            self.userProfileImage.image = UIImage(data: imageData)
        } catch {
            print(error)
        }

        resultsLabel.isHidden = true
    }



}
