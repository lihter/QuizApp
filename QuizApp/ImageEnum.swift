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
    case quizTabBarItem
    case quizTabBarItemSelected
    case searchTabBarItem
    case searchTabBarItemSelected
    case settingsTabBarItem
    case settingsTabBarItemSelected
    
    //NavigationButtonItems
    case backwardArrowItem
    case xmarkItem
    
    var image: UIImage {
        switch self {
        case .filledStar: return UIImage(named: "ratingStarFilled.svg")!
        case .emptyStar: return UIImage(named: "ratingStar.svg")!
        case .coloredStar: return (UIImage(named: "ratingStar.svg")?.withTintColor(.blue, renderingMode: .alwaysTemplate))! //umjesto .blue izvuci boju kategorije, ali nevazno trenutno jer .withtintcolor jos uvijek ne radi na cosmosu
        case .errorSign: return UIImage(named: "errorImageFile.svg")!
        case .passwordEye: return UIImage(named: "Hide.svg")!
            
        //case .quizTabBarItem: return UIImage(systemName: "questionmark.square.fill")!
        //case .quizTabBarItemSelected: return (UIImage(systemName: "questionmark.square.fill")?.withTintColor(tabBarSelectedImageColor(style), renderingMode: .alwaysOriginal))!
        case .quizTabBarItem: return (UIImage(named: "quizTabBarIconFigma.svg")?.withTintColor(unselectedTabBarItemColor, renderingMode: .alwaysOriginal))!
        case .quizTabBarItemSelected: return (UIImage(named: "quizTabBarIconFigma.svg")?.withTintColor(tabBarSelectedImageColor(style), renderingMode: .alwaysOriginal))!
        //case .searchTabBarItem: return UIImage(systemName: "magnifyingglass")!
        //case .searchTabBarItemSelected: return (UIImage(systemName: "magnifyingglass")?.withTintColor(tabBarSelectedImageColor(style), renderingMode: .alwaysOriginal))!
        case .searchTabBarItem: return (UIImage(named: "searchTabBarIconFigma.svg")?.withTintColor(unselectedTabBarItemColor, renderingMode: .alwaysOriginal))!
        case .searchTabBarItemSelected: return (UIImage(named: "searchTabBarIconFigma.svg")?.withTintColor(tabBarSelectedImageColor(style), renderingMode: .alwaysOriginal))!
        //case .settingsTabBarItem: return UIImage(systemName: "gearshape.fill")!
        //case .settingsTabBarItemSelected: return (UIImage(systemName: "gearshape.fill")?.withTintColor(tabBarSelectedImageColor(style), renderingMode: .alwaysOriginal))!
        case .settingsTabBarItem: return (UIImage(named: "settingsTabBarIconFigma.svg")?.withTintColor(unselectedTabBarItemColor, renderingMode: .alwaysOriginal))!
        case .settingsTabBarItemSelected: return (UIImage(named: "settingsTabBarIconFigma.svg")?.withTintColor(tabBarSelectedImageColor(style), renderingMode: .alwaysOriginal))!
        
        
        case .backwardArrowItem: return (UIImage(systemName: "chevron.backward")?.withTintColor(.white, renderingMode: .alwaysOriginal))!
        case .xmarkItem: return (UIImage(systemName: "xmark")?.withTintColor(.white, renderingMode: .alwaysOriginal))!
        }
    }

}
