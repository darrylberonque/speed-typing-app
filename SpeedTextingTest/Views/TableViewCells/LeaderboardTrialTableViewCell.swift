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

    var viewModel: TrialCellViewModel? {
        didSet {
            initLeaderboardTrial()
        }
    }

    private func initLeaderboardTrial() {
        guard let viewModel = self.viewModel, let imageURL = viewModel.user.imageURL else { return }

        var imageData: Data
        if userImage.image == nil, let url = URL(string: imageURL) {
            do {
                imageData = try Data(contentsOf: url)
                userImage.image = UIImage(data: imageData)
            } catch {
                print(error)
            }
        }

        metricsRowView.viewModel = viewModel.metricsRowViewModel
        metricsRowView.addShadow(radius: 3.0, color: .black, opacity: 0.25)
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = userImage.frame.width/2
    }
}
