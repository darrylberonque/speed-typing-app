//
//  MetricCircleView.swift
//  SpeedTextingTest
//
//  Created by darryl.beronque on 11/27/18.
//  Copyright © 2018 darrylberonque. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum MetricLevel {
    case low
    case medium
    case high
    case perfect

    var color: UIColor {
        switch self {
        case .low:
            return .lowScoreColor
        case .medium:
            return .mediumScoreColor
        case .high:
            return .highScoreColor
        case .perfect:
            return .blueThemeColor
        }
    }
}

class MetricCircleView: UIView {

    private let metricCirclelayer: CAShapeLayer = CAShapeLayer()
    private var disposeBag = DisposeBag()

    var viewModel = MetricCircleViewModel() {
        didSet {
            configureCAShapeLayer()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func configureCAShapeLayer() {
        let borderPath = UIBezierPath(arcCenter: CGPoint(x: frame.width / 2.0, y: frame.height / 2.0), radius: (bounds.width-CGFloat(Constants.metricCircleLineWidth))/2, startAngle: Constants.metricCircleStartAngle, endAngle: Constants.metricCircleEndAngle, clockwise: true)

        metricCirclelayer.path = borderPath.cgPath
        metricCirclelayer.fillColor = UIColor.clear.cgColor
        metricCirclelayer.lineWidth = CGFloat(Constants.metricCircleLineWidth)

        viewModel.strokeEnd.asDriver().drive(onNext: { [unowned self] strokeEnd in
            self.metricCirclelayer.strokeEnd = CGFloat(strokeEnd)
        }).disposed(by: disposeBag)

        viewModel.valueLevel.asDriver().drive(onNext: { [unowned self] level in
            self.metricCirclelayer.strokeColor = level.color.cgColor
        }).disposed(by: disposeBag)

        layer.insertSublayer(metricCirclelayer, at: 0)
    }

    func animateMetricCircle(strokeEnd: Double, duration: TimeInterval) {
        let animation = CABasicAnimation(keyPath: Constants.strokeEndKeypath)
        viewModel.strokeEnd.accept(strokeEnd)

        animation.duration = duration
        animation.fromValue = 0.0
        animation.toValue = strokeEnd
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)

        metricCirclelayer.strokeEnd = CGFloat(strokeEnd)
        metricCirclelayer.add(animation, forKey: Constants.metricCircleAnimateKeypath)
    }

    func displayMetricCircle(strokeEnd: Double) {
        viewModel.strokeEnd.accept(strokeEnd)
        metricCirclelayer.strokeEnd = CGFloat(strokeEnd)
    }
}
