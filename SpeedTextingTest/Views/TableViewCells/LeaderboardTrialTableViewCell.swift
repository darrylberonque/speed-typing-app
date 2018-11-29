//
//  LeaderboardTrialTableViewCell.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/28/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import UIKit

final class LeaderboardTrialTableViewCell: UITableViewCell {

    @IBOutlet weak var metricsRowView: MetricsRowView!
    @IBOutlet weak var userImage: UIImageView!

    func initLeaderboardTrial(viewModel: MetricsRowViewModel, image: UIImage) {
        metricsRowView.viewModel = viewModel
        userImage.image = image
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = userImage.frame.width/2
    }
}
