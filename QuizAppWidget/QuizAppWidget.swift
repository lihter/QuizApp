//
//  QuizAppWidget.swift
//  QuizAppWidget
//
//  Created by Mac Use on 22.05.2021..
//

import WidgetKit
import SwiftUI

struct QuizAppWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemMedium:
            WidgetMediumView(funFactString: entry.funFact)
        default:
            fatalError()
        }
        
    }
}

@main
struct QuizAppWidget: Widget {
    let kind: String = "QuizAppWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            QuizAppWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Quiz Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium])
    }
}

struct QuizAppWidget_Previews: PreviewProvider {
    static var previews: some View {
        QuizAppWidgetEntryView(entry: FunFactEntry.mockFunFactEntry())
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
