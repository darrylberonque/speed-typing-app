//
//  UserTrialTableViewCell.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/28/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import UIKit

final class UserTrialTableViewCell: UITableViewCell {

    @IBOutlet private weak var subContainer: UIView!
    @IBOutlet private weak var metricsRowView: MetricsRowView!

    var viewModel: TrialCellViewModel? {
        didSet {
            initUserTrial()
        }
    }

    private func initUserTrial() {
        guard let viewModel = self.viewModel else { return }
        metricsRowView.viewModel = viewModel.metricsRowViewModel
        subContainer.addShadow(radius: 3.0, color: .black, opacity: 0.25)
        metricsRowView.clipsToBounds = true
        metricsRowView.layer.cornerRadius = 10
    }
}
