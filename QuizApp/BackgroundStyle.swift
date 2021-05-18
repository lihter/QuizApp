//
//  BackgroundStyle.swift
//  QuizApp
//
//  Created by Mac Use on 12.04.2021..
//

import UIKit

public func setBackgroundStyle(_ view: UIView) -> CAGradientLayer{
    let gradientLayer = CAGradientLayer()
    gradientLayer.locations = [0, 1]
    gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
    gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
    gradientLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: -1.95, b: 1.41, c: -1.41, d: -0.41, tx: 2.02, ty: -0.01))
    gradientLayer.bounds = view.bounds.insetBy(dx: -0.5*view.bounds.size.width, dy: -0.5*view.bounds.size.height)
    gradientLayer.position = view.center
    gradientLayer.colors = returnGradientColor()
    
    return gradientLayer
}

public func returnGradientColor() -> [CGColor] {
    let colors: [CGColor]
    switch style {
    case .purple:
        colors = [
          UIColor(red: 0.453, green: 0.308, blue: 0.637, alpha: 1).cgColor,
          UIColor(red: 0.154, green: 0.185, blue: 0.463, alpha: 1).cgColor]

    case .green:
        colors = [
          UIColor(red: 0.281, green: 0.746, blue: 0.062, alpha: 1).cgColor,
          UIColor(red: 0.083, green: 0.64, blue: 0.762, alpha: 1).cgColor]
    
    case .red:
        colors = [
            UIColor(red: 255/255, green: 76/255, blue: 76/255, alpha: 1).cgColor,
            UIColor(red: 207/255, green: 21/255, blue: 21/255, alpha: 1).cgColor]
    }
    return colors
}

public func buttonColorStyle(_ styleOption: StyleOptions) -> UIColor {
    
    switch styleOption {
    case .purple:
        return UIColor(red: 0.387, green: 0.16, blue: 0.871, alpha: 1)
    case .green:
        return UIColor(red: 25/255, green: 143/255, blue: 25/255, alpha: 1)
    case .red:
        return .red
    }
}

public func tabBarSelectedImageColor(_ styleOption: StyleOptions) -> UIColor {
    switch styleOption {
    case .purple:
        return UIColor(red: 116/255, green: 79/255, blue: 163/255, alpha: 1)
    case .green:
        return UIColor(red: 7/255, green: 109/255, blue: 7/255, alpha: 1)
    case .red:
        return .red
    }
}

extension CAGradientLayer {
    func reloadBoundsForGradient(_ view: UIView) {
        bounds = view.bounds.insetBy(dx: -0.5*view.bounds.size.width, dy: -0.5*view.bounds.size.height)
    }
}


