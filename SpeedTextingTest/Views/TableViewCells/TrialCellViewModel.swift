//
//  TrialCellViewModel.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/29/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation
import UIKit

final class TrialCellViewModel {

    var user: UserModel
    var userImage: UIImage?
    var trial: TrialModel
    var metricsRowViewModel: MetricsRowViewModel

    init(user: UserModel, trial: TrialModel) {
        self.user = user
        self.trial = trial
        self.metricsRowViewModel = MetricsRowViewModel(metrics: trial.metrics!)
    }
    
    func setUIImage() {
        guard let imageURL = user.imageURL else { return }

        var imageData: Data
        if let url = URL(string: imageURL) {
            do {
                imageData = try Data(contentsOf: url)
                userImage = UIImage(data: imageData)
            } catch {
                print(error)
            }
        }
    }
}
