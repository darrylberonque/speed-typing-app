//
//  ButtonViewModel.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/28/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class ButtonViewModel {

    var isClosable: Bool
    var buttonViewState = BehaviorRelay(value: ButtonState.home)

    init(closable: Bool) {
        isClosable = closable
    }
}
