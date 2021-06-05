//
//  RedTheme.swift
//  QuizApp
//
//  Created by Mac Use on 16.05.2021..
//

import UIKit

class RedTheme: ThemeProtocol {
    var gradientColor: [CGColor] = [
        UIColor(red: 255/255, green: 76/255, blue: 76/255, alpha: 1).cgColor,
        UIColor(red: 207/255, green: 21/255, blue: 21/255, alpha: 1).cgColor]
    var buttonTextColor: UIColor = UIColor.red
    var tabbarSelectedImageColor: UIColor = UIColor.red
}
