//
//  CAGradientLayer+reloadBoundForGradient.swift
//  QuizApp
//
//  Created by Mac Use on 15.05.2021..
//
import UIKit

extension CAGradientLayer {
    func reloadBoundsForGradient(_ view: UIView) {
        bounds = view.bounds.insetBy(dx: -0.5*view.bounds.size.width, dy: -0.5*view.bounds.size.height)
    }
}
