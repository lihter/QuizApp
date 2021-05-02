//
//  ImageEnum.swift
//  QuizApp
//
//  Created by Mac Use on 01.05.2021..
//

import UIKit
public enum ImageEnum {

    case filledStar
    case emptyStar
    case coloredStar
    case errorSign
    case passwordEye
    
    //TabBarItems
    case firstTabBarItem
    case firstTabBarItemSelected
    case secondTabBarItem
    case secondTabBarItemSelected
    case thirdTabBarItem
    case thirdTabBarItemSelected
    
    var image: UIImage {
        switch self {
        case .filledStar: return UIImage(named: "ratingStarFilled.svg")!
        case .emptyStar: return UIImage(named: "ratingStar.svg")!
        case .coloredStar: return (UIImage(named: "ratingStar.svg")?.withTintColor(.blue, renderingMode: .alwaysTemplate))! //umjesto .blue izvuci boju kategorije, ali nevazno trenutno jer .withtintcolor jos uvijek ne radi na cosmosu
        case .errorSign: return UIImage(named: "errorImageFile.svg")!
        case .passwordEye: return UIImage(named: "Hide.svg")!
            
        case .firstTabBarItem: return UIImage(systemName: "questionmark.square.fill")!
        case .firstTabBarItemSelected: return (UIImage(systemName: "questionmark.square.fill")?.withTintColor(tabBarSelectedImageColor(style), renderingMode: .alwaysOriginal))!
        case .secondTabBarItem: return UIImage(systemName: "magnifyingglass")!
        case .secondTabBarItemSelected: return (UIImage(systemName: "magnifyingglass")?.withTintColor(tabBarSelectedImageColor(style), renderingMode: .alwaysOriginal))!
        case .thirdTabBarItem: return UIImage(systemName: "gearshape.fill")!
        case .thirdTabBarItemSelected: return (UIImage(systemName: "gearshape.fill")?.withTintColor(tabBarSelectedImageColor(style), renderingMode: .alwaysOriginal))!
        }
    }

}
