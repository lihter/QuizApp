//
//  BackgroundStyle.swift
//  QuizApp
//
//  Created by Mac Use on 12.04.2021..
//

import UIKit

public func setBackgroundStyle(_ view: UIView, _ styleOption: StyleOptions) {
    let layer0 = CAGradientLayer()
    
    switch styleOption {
    case .purple:
        //Ovaj kod je uzet s figme jer nisam sam znao identično postaviti gradient boju
        let layer0 = CAGradientLayer()
        layer0.colors = [
          UIColor(red: 0.453, green: 0.308, blue: 0.637, alpha: 1).cgColor,
          UIColor(red: 0.154, green: 0.185, blue: 0.463, alpha: 1).cgColor
        ]
        layer0.locations = [0, 1]
        layer0.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer0.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: -1.95, b: 1.41, c: -1.41, d: -0.41, tx: 2.02, ty: -0.01))
        layer0.bounds = view.bounds.insetBy(dx: -0.5*view.bounds.size.width, dy: -0.5*view.bounds.size.height)
        layer0.position = view.center
        view.layer.addSublayer(layer0)

    case .green:
        //Ovaj kod je uzet s figme jer nisam sam znao identično postaviti gradient boju
        layer0.colors = [
          UIColor(red: 0.281, green: 0.746, blue: 0.062, alpha: 1).cgColor,
          UIColor(red: 0.083, green: 0.64, blue: 0.762, alpha: 1).cgColor]

        layer0.locations = [0, 1]
        layer0.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer0.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: -0.93, b: 1.23, c: -1.23, d: -0.2, tx: 1.61, ty: -0.05))
        layer0.bounds = view.bounds.insetBy(dx: -0.5*view.bounds.size.width, dy: -0.5*view.bounds.size.height)
        layer0.position = view.center
        view.layer.addSublayer(layer0)
    
    case .red:
        view.layer.backgroundColor = UIColor(red: 0.988, green: 0.395, blue: 0.395, alpha: 1).cgColor

    }
}

public func buttonColorStyle(_ styleOption: StyleOptions) -> UIColor {
    
    switch styleOption {
    case .purple:
        return UIColor(red: 0.387, green: 0.16, blue: 0.871, alpha: 1)
    case .green:
        return .green
    case .red:
        return .red

    }
}


