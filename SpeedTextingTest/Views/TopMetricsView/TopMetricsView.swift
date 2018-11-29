//
//  TopMetricsView.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/29/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import UIKit

final class TopMetricsView: UIView {

    @IBOutlet private var topMetricsView: UIView!
    @IBOutlet private weak var draggableView: UIView!
    @IBOutlet private weak var metricsRowView: MetricsRowView!

    var viewModel: TopMetricsViewModel? {
        didSet {
            populateMetricsRowView()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initTopMetricsView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initTopMetricsView()
    }

    private func initTopMetricsView() {
        Bundle.main.loadNibNamed("TopMetricsView", owner: self, options: nil)
        addSubview(topMetricsView)
        topMetricsView.frame = self.bounds
        topMetricsView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    private func populateMetricsRowView() {
        guard let viewModel = viewModel else { return }
        metricsRowView.viewModel = viewModel.metricsRowViewModel
    }
}
