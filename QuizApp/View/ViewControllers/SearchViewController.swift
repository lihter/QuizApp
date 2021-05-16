//
//  SearchViewController.swift
//  QuizApp
//
//  Created by Mac Use on 13.04.2021..
//

import UIKit

class SearchViewController: UIViewController, TabBarThemeProtocol {
    
    //MARK: - VC vars
    private var coordinator: MainCoordinatorPatternProtocol!
    private var gradientLayer = CAGradientLayer()

    //MARK: - Code
    convenience init(coordinator: MainCoordinatorPatternProtocol) {
        self.init()
        
        self.coordinator = coordinator
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradientLayer.setBackgroundStyle(view)
        
        view.layer.addSublayer(gradientLayer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(themeChanged), name: Notification.Name("NewTheme"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("NewTheme"), object: nil)
    }
    
    //MARK: - Additional functions
    
    @objc func themeChanged() {
        
    }
}
