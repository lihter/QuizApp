//
//  Provider.swift
//  QuizAppWidgetExtension
//
//  Created by Mac Use on 22.05.2021..
//

import WidgetKit

struct Provider: TimelineProvider {
    let loader: FunFactPresenter = FunFactPresenter()
    typealias Entry = FunFactEntry
    
    func placeholder(in context: Context) -> FunFactEntry {
        FunFactEntry.mockFunFactEntry()
    }

    func getSnapshot(in context: Context, completion: @escaping (FunFactEntry) -> ()) {
        let entry = FunFactEntry.mockFunFactEntry()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        loader.fetchQuizzesFromNetwork{ (response) in
            if(response != nil && response?.widgetFunFact != nil) {
                let currentDate = Date()
                let entry = FunFactEntry(date: currentDate, funFact: (response?.widgetFunFact)!)
                let refreshDate = Calendar.current.date(byAdding: .minute, value: 60, to: currentDate)!
                let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                completion(timeline)
            }
        }
    }
}
