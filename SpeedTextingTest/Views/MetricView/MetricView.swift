//
//  MetricView.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/27/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class MetricView: UIView {

    @IBOutlet private var metricView: UIView!
    @IBOutlet private weak var metricCircleView: MetricCircleView!
    @IBOutlet private weak var metricLayerView: UIView!
    @IBOutlet private weak var metricValueLabel: UILabel!
    @IBOutlet private weak var metricTypeLabel: UILabel!

    private var disposeBag = DisposeBag()

    var viewModel = MetricViewModel(type: .wpm, value: 0.0, displayType: .animate) {
        didSet {
            metricTypeLabel.text = viewModel.title
            metricCircleView.viewModel = MetricCircleViewModel()

            switch viewModel.displayType {
            case .live:
                initGameState()
            case .animate:
                initAnimateState()
            case .display:
                initDisplayState()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initMetricView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initMetricView()
    }

    private func initMetricView() {
        Bundle.main.loadNibNamed("MetricView", owner: self, options: nil)
        addSubview(metricView)
        metricView.frame = self.bounds
        metricView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        metricLayerView.layer.cornerRadius = metricLayerView.frame.width / 2
        metricCircleView.layer.cornerRadius = metricCircleView.frame.width / 2
        metricCircleView.addShadow(radius: 3.0, color: .black, opacity: 0.25)
    }

    private func initGameState() {
        viewModel.value.asDriver().drive(onNext: { [unowned self] value in
            self.metricValueLabel.text = value < Double(self.viewModel.type.maxValue) ? String(value) : String(self.viewModel.type.maxValue)
        }).disposed(by: disposeBag)
    }

    private func initAnimateState() {
        metricCircleView.animateMetricCircle(strokeEnd: viewModel.strokeEnd.value, duration: TimeInterval(Constants.circleAnimationDuration))

        let period = Constants.circleAnimationDuration / viewModel.value.value
        let increment = viewModel.value.value / Constants.circleAnimationDuration
        Observable<Int>.timer(0, period: period, scheduler: MainScheduler.instance).subscribe(onNext: { [unowned self] time in
            let val = (Double(time) * increment) / Double(self.viewModel.value.value)
            self.metricValueLabel.text = val < self.viewModel.value.value ? String(val) : String(self.viewModel.value.value)
        }).disposed(by: disposeBag)
    }

    private func initDisplayState() {
        metricCircleView.displayMetricCircle(strokeEnd: viewModel.strokeEnd.value)
        metricValueLabel.text = String(viewModel.value.value)
    }

    func updateGameState(value: Double) {
        let strokeEnd = value.convertToStrokeEndValue(type: viewModel.type)
        viewModel.value.accept(value)
        viewModel.strokeEnd.accept(strokeEnd)
        metricCircleView.viewModel.strokeEnd.accept(strokeEnd)
    }
}
