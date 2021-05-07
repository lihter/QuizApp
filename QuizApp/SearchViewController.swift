//
//  SearchViewController.swift
//  QuizApp
//
//  Created by Mac Use on 13.04.2021..
//

import UIKit

class SearchViewController: UIViewController {
    
    //MARK: Code
    private var coordinator: MainCoordinatorPatternProtocol!
    private var gradientLayer: CAGradientLayer!
    
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
        gradientLayer = setBackgroundStyle(view)
        
        view.layer.addSublayer(gradientLayer)
    }
}
