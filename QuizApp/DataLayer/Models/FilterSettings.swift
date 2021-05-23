//
//  FilterSettings.swift
//  QuizApp
//
//  Created by Mac Use on 20.05.2021..
//

struct FilterSettings {

    let searchText: String?

    init(searchText: String? = nil) {
        self.searchText = (searchText?.isEmpty ?? true) ? nil : searchText
    }

}
