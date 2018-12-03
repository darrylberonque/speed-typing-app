//
//  ModalViewModel.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/28/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum ModalType {
    case display
    case result
}

final class ModalViewModel {

    var user: UserModel?
    var type: ModalType?
    var trial: TrialModel?

    init(type: ModalType, trial: TrialModel, user: UserModel) {
        self.type = type
        self.trial = trial
        self.user = user
    }

    func configuredHeaderViewModel() -> HeaderViewModel {
        guard let user = self.user, let type = self.type else { return HeaderViewModel(type: .display) }
        return HeaderViewModel(username: user.name, url: user.imageURL, type: type)
    }

    func configuredResultsViewModel() -> ResultsViewModel {
        guard let trial = self.trial else { return ResultsViewModel(displayType: .display) }
        return ResultsViewModel(trial: trial, displayType: .animate)
    }

    func configuredButtonViewModel() -> ButtonViewModel {
        guard let type = self.type else { return ButtonViewModel(closable: true) }

        switch type {
        case .display:
            return ButtonViewModel(closable: true)
        case .result:
            return ButtonViewModel(closable: false)
        }
    }
    
}
