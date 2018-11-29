//
//  NavBarViewModel.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/29/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class NavBarViewModel {

    var title: String?
    var selectedSort = BehaviorRelay(value: MetricType.time)

    init(title: String) {
        self.title = title
    }

}
