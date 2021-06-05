//
//  ViewControllerThemeDelegate.swift
//  QuizApp
//
//  Created by Mac Use on 16.05.2021..
//


//Ovaj protocol ce implementirati svi VC u tabbaru
protocol TabBarThemeProtocol: AnyObject {
    //Preporucam zvati s notificationom koji se postavlja kad se promijeni tema. -> Notification.Name("NewTheme")
    func themeChanged()
}
