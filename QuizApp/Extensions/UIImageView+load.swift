//
//  UIImageView+load.swift
//  QuizApp
//
//  Created by Mac Use on 15.05.2021..
//

import Foundation
import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
            }
        }
    }
}
