//
//  UserTrialTableViewCell.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/28/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import UIKit

final class UserTrialTableViewCell: UITableViewCell {

    @IBOutlet private weak var metricsRowView: MetricsRowView!

    func initMetricsRowView(viewModel: MetricsRowViewModel) {
        metricsRowView.viewModel = viewModel
    }
}
