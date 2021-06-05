//
//  Theme.swift
//  QuizApp
//
//  Created by Mac Use on 16.05.2021..
//

import Foundation

class Theme {
    static var current: ThemeProtocol = PurpleTheme() {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("NewTheme"), object: nil)
            UserDefaults.standard.setValue(Theme.stringFrom(theme: current), forKey: "Theme")
        }
    }
    
    static func themeFrom(string: String) -> ThemeProtocol {
        switch string {
        case "purple":
            return PurpleTheme()
        case "green":
            return GreenTheme()
        case "red":
            return RedTheme()
        default:
            return PurpleTheme()
        }
    }
    
    static func stringFrom(theme: ThemeProtocol) -> String {
        switch theme {
        case is PurpleTheme:
            return "purple"
        case is GreenTheme:
            return "green"
        case is RedTheme:
            return "red"
        default:
            return "purple"
        }
    }
}
