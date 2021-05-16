//
//  CAGradientLayer+setBackgroundStyle.swift
//  QuizApp
//
//  Created by Mac Use on 16.05.2021..
//

import UIKit

extension CAGradientLayer {
    func setBackgroundStyle(_ view: UIView) {
        locations = [0, 1]
        startPoint = CGPoint(x: 0.25, y: 0.5)
        endPoint = CGPoint(x: 0.75, y: 0.5)
        transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: -1.95, b: 1.41, c: -1.41, d: -0.41, tx: 2.02, ty: -0.01))
        bounds = view.bounds.insetBy(dx: -0.5*view.bounds.size.width, dy: -0.5*view.bounds.size.height)
        position = view.center
        colors = Theme.current.gradientColor
    }
}
