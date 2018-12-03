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
        guard let viewModel = self.viewModel, let image = viewModel.userImage else { return }
        userImage.image = image
        metricsRowView.viewModel = viewModel.metricsRowViewModel
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = userImage.frame.width/2
    }
}
