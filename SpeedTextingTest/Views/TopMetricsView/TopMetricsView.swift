//
//  TopMetricsView.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/29/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

final class TopMetricsView: UIView {

    @IBOutlet private var topMetricsView: UIView!
    @IBOutlet private weak var draggableView: UIView!
    @IBOutlet private weak var metricsRowView: MetricsRowView!

    private var disposeBag = DisposeBag()

    var viewModel: TopMetricsViewModel? {
        didSet {
            populateMetricsRowView()
            setupBindings()
        }
    }

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        initTopMetricsView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initTopMetricsView()
    }

    // MARK: - Setup view

    private func initTopMetricsView() {
        Bundle.main.loadNibNamed("TopMetricsView", owner: self, options: nil)
        addSubview(topMetricsView)
        topMetricsView.frame = self.bounds
        topMetricsView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        topMetricsView.addShadow(radius: 3.0, color: .black, opacity: 0.25)
    }

    private func populateMetricsRowView() {
        guard let viewModel = viewModel else { return }
        metricsRowView.viewModel = viewModel.metricsRowViewModel
    }

    private func setupBindings() {
        // TODO: - Get view to follow gesture back down
        
    }
}
