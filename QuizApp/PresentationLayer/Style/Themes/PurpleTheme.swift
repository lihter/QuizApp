//
//  PurpleTheme.swift
//  QuizApp
//
//  Created by Mac Use on 16.05.2021..
//

import UIKit

class PurpleTheme: ThemeProtocol {
    var gradientColor: [CGColor] = [
        UIColor(red: 0.453, green: 0.308, blue: 0.637, alpha: 1).cgColor,
        UIColor(red: 0.154, green: 0.185, blue: 0.463, alpha: 1).cgColor]
    var buttonTextColor: UIColor = UIColor(red: 0.387, green: 0.16, blue: 0.871, alpha: 1)
    var tabbarSelectedImageColor: UIColor = UIColor(red: 116/255, green: 79/255, blue: 163/255, alpha: 1)
}
