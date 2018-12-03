//
//  NavBarView.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/29/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class NavBarView: UIView {
    
    @IBOutlet private var navBarView: UIView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var navBarTitleLabel: UILabel!
    @IBOutlet private weak var sortSegmentedControl: UISegmentedControl!

    private var disposeBag = DisposeBag()

    var viewModel = NavBarViewModel(title: "Your Trials") {
        didSet {
            navBarTitleLabel.text = viewModel.title
            setupBindings()
        }
    }

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        initNavBarView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initNavBarView()
    }

    private func initNavBarView() {
        Bundle.main.loadNibNamed("NavBarView", owner: self, options: nil)
        addSubview(navBarView)
        navBarView.frame = self.bounds
        navBarView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    // MARK: - Bindings
    
    private func setupBindings() {
        backButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let welf = self else { return }
                welf.viewModel.buttonTapped.accept(true)
            })
            .disposed(by: disposeBag)

        sortSegmentedControl.rx.value.asObservable()
            .map { index in
                return Constants.sorts[index]
            }
            .bind(to: viewModel.selectedSort)
            .disposed(by: disposeBag)
    }

}
