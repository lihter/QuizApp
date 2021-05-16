//
//  UIScrollView+scrollTo.swift
//  QuizApp
//
//  Created by Mac Use on 16.05.2021..
//

import UIKit

extension UIScrollView {
    func scrollTo(horizontalPage: Int? = 0) {
        var frame: CGRect = self.frame
        frame.origin.x = frame.size.width * CGFloat(horizontalPage ?? 0)
        frame.origin.y = 0
        self.scrollRectToVisible(frame, animated: true)
    }
}
