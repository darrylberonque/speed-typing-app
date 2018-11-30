//
//  ResultsView.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/28/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import UIKit

final class ResultsView: UIView {

    @IBOutlet private var resultsView: UIView!
    @IBOutlet private weak var paragraphTextView: UITextView!
    @IBOutlet private weak var accuracyMetricView: MetricView!
    @IBOutlet private weak var wpmMetricView: MetricView!
    @IBOutlet private weak var cpmMetricView: MetricView!

    var viewModel = ResultsViewModel(displayType: .display) {
        didSet {
            populateResults()
        }
    }

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        initResultsView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initResultsView()
    }

    // MARK: - Initialize and populate view state

    private func initResultsView() {
        Bundle.main.loadNibNamed("ResultsView", owner: self, options: nil)
        addSubview(resultsView)
        resultsView.frame = self.bounds
        resultsView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    private func populateResults() {
        guard let trialResults = viewModel.trial, let paragraph = trialResults.paragraph, let metrics = trialResults.metrics else { return }
        paragraphTextView.text = paragraph
        accuracyMetricView.viewModel = MetricViewModel(type: .accuracy, value: metrics.accuracy, displayType: viewModel.displayType)
        wpmMetricView.viewModel = MetricViewModel(type: .wpm, value: metrics.wpm, displayType: viewModel.displayType)
        cpmMetricView.viewModel = MetricViewModel(type: .cpm, value: metrics.cpm, displayType: viewModel.displayType)
    }
}
