//
//  ButtonView.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/28/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum ButtonState {
    case home
    case restart
    case closed
}

final class ButtonView: UIView {

    @IBOutlet private var buttonView: UIView!
    @IBOutlet private weak var homeButton: UIButton!
    @IBOutlet private weak var restartButton: UIButton!
    @IBOutlet private weak var closeButton: UIButton!

    private var disposeBag = DisposeBag()

    var viewModel = ButtonViewModel(closable: true) {
        didSet {
            setupUI()
            setupBindings()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initResultsView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initResultsView()
    }

    private func initResultsView() {
        Bundle.main.loadNibNamed("ButtonView", owner: self, options: nil)
        addSubview(buttonView)
        buttonView.frame = self.bounds
        buttonView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    private func setupUI() {
        homeButton.layer.borderWidth = CGFloat(Constants.backButtonBorderWidth)
        homeButton.layer.borderColor = UIColor.blueThemeColor.cgColor

        homeButton.layer.cornerRadius = CGFloat(homeButton.frame.height/2)
        restartButton.layer.cornerRadius = CGFloat(restartButton.frame.height/2)
        closeButton.layer.cornerRadius = CGFloat(closeButton.frame.height/2)

        if viewModel.isClosable {
            homeButton.isHidden = true
            restartButton.isHidden = true
            closeButton.isHidden = false
        } else {
            homeButton.isHidden = false
            restartButton.isHidden = false
            closeButton.isHidden = true
        }
    }

    private func setupBindings() {
        homeButton.rx.tap.asObservable()
            .single()
            .map({ return ButtonState.home })
            .bind(to: viewModel.buttonViewState)
            .disposed(by: disposeBag)

        restartButton.rx.tap.asObservable()
            .single()
            .map({ return ButtonState.restart })
            .bind(to: viewModel.buttonViewState)
            .disposed(by: disposeBag)

        closeButton.rx.tap.asObservable()
            .single()
            .map({ return ButtonState.closed })
            .bind(to: viewModel.buttonViewState)
            .disposed(by: disposeBag)
    }
}
