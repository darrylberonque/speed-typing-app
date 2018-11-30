//
//  LeaderboardTrialTableViewCell.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/28/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import UIKit

final class LeaderboardTrialTableViewCell: UITableViewCell {

    @IBOutlet private weak var subContainer: UIView!
    @IBOutlet private weak var metricsRowView: MetricsRowView!
    @IBOutlet private weak var userImage: UIImageView!

    var viewModel: TrialCellViewModel? {
        didSet {
            initLeaderboardTrial()
        }
    }

    private func initLeaderboardTrial() {
        guard let viewModel = self.viewModel, let imageURL = viewModel.user.imageURL else { return }

        var imageData: Data
        if let url = URL(string: imageURL) {
            do {
                imageData = try Data(contentsOf: url)
                userImage.image = UIImage(data: imageData)
            } catch {
                print(error)
            }
        }

        
        metricsRowView.viewModel = viewModel.metricsRowViewModel
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = userImage.frame.width/2
    }
}
