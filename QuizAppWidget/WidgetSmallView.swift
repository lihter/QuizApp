//
//  WidgetSmallView.swift
//  QuizAppWidgetExtension
//
//  Created by Mac Use on 22.05.2021..
//

import SwiftUI
import WidgetKit

struct WidgetMediumView: View {
    private var funFactString: String
    
    init(funFactString: String) {
        self.funFactString = funFactString
    }
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(red: 0.453, green: 0.308, blue: 0.637), Color(red: 0.154, green: 0.185, blue: 0.463)]), startPoint: .leading, endPoint: .trailing)
            .edgesIgnoringSafeArea(.vertical)
            .overlay(
                VStack(alignment: .leading) {
                    HStack {
                        Spacer().frame(width: 10)
                        Text("TODAY'S FUN FACT")
                            .font(Font.custom(Fonts.mainBold, size: 13))
                            .foregroundColor(.white)
                    }
                    
                    HStack{
                        Spacer().frame(width: 10)
                        RoundedRectangle(cornerRadius: 1)
                            .fill(Color.white)
                            .frame(width: 2, height: 37)
                        Text(funFactString)
                            .font(Font.custom(Fonts.main, size: 20))
                            .foregroundColor(.white)
                        Spacer().frame(width: 15)
                    }
                }
        )
    }
}

struct WidgetSmallView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetMediumView(funFactString: "TEST")
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
