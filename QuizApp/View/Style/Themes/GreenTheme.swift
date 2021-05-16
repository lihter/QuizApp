//
//  GreenTheme.swift
//  QuizApp
//
//  Created by Mac Use on 16.05.2021..
//

import UIKit

class GreenTheme: ThemeProtocol {
    var gradientColor: [CGColor] = [
        UIColor(red: 0.281, green: 0.746, blue: 0.062, alpha: 1).cgColor,
        UIColor(red: 0.083, green: 0.64, blue: 0.762, alpha: 1).cgColor]
    var buttonTextColor: UIColor = UIColor(red: 25/255, green: 143/255, blue: 25/255, alpha: 1)
    var tabbarSelectedImageColor: UIColor = UIColor(red: 7/255, green: 109/255, blue: 7/255, alpha: 1)
}
