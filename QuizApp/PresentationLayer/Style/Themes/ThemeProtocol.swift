//
//  ThemeProtocol.swift
//  QuizApp
//
//  Created by Mac Use on 16.05.2021..
//

import UIKit

protocol ThemeProtocol {
    var gradientColor: [CGColor] { get }
    var buttonTextColor: UIColor { get }
    var tabbarSelectedImageColor: UIColor { get }
}
