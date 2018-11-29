//
//  MetricsRowView.swift
//  
//
//  Created by darryl.beronque on 11/28/18.
//

import UIKit

final class MetricsRowView: UIView {
    
    @IBOutlet private var metricsRowView: UIView!
    @IBOutlet private weak var accuracyMetricView: MetricView!
    @IBOutlet private weak var wpmMetricView: MetricView!
    @IBOutlet private weak var cpmMetricView: MetricView!

    var viewModel = MetricsRowViewModel(metrics: MetricsModel()) {
        didSet {
            initMetrics()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initMetricsRowView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initMetricsRowView()
    }

    private func initMetricsRowView() {
        Bundle.main.loadNibNamed("MetricsRowView", owner: self, options: nil)
        addSubview(metricsRowView)
        metricsRowView.frame = self.bounds
        metricsRowView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    private func initMetrics() {
        accuracyMetricView.viewModel = viewModel.configuredMetricViewModel(type: .accuracy)
        wpmMetricView.viewModel = viewModel.configuredMetricViewModel(type: .wpm)
        cpmMetricView.viewModel = viewModel.configuredMetricViewModel(type: .cpm)
    }

}
