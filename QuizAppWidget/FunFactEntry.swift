//
//  FunFactEntry.swift
//  QuizAppWidgetExtension
//
//  Created by Mac Use on 22.05.2021..
//

import WidgetKit

struct FunFactEntry: TimelineEntry {
    let date: Date
    let funFact: String
    
    static func mockFunFactEntry() -> FunFactEntry {
        return FunFactEntry(date: Date(), funFact: "Babies have around 100 more bones than adults.")
    }
}
