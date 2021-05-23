//
//  SettingsViewController.swift
//  QuizApp
//
//  Created by Mac Use on 13.04.2021..
//

import UIKit

class SettingsViewController: UIViewController, TabBarThemeProtocol {
    
    //MARK: - Constants
    private let usernameFontSize: CGFloat = 35
    private let sectionUsernameTitleFromTopOffsetMul: CGFloat = 0.1381
    private let itemInsets: CGFloat = 20
    private let itemDistance: CGFloat = 6
    private let segmentedControlHeight: CGFloat = 25
    private let logoutButtonFromBottomOffsetMul: CGFloat = 0.15
    
    //MARK: - VC elements
    private var gradientLayer = CAGradientLayer()
    private var sectionUsernameLabel: UILabel!
    private var usernameLabel: UILabel!
    private var styleChooserLabel: UILabel!
    private var styleChooserSegmentedControl: UISegmentedControl!
    private var logoutButton: MenuButton!
    private var coordinator: MainCoordinatorPatternProtocol!
    
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
        
        buildViews()
        addConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(themeChanged), name: Notification.Name("NewTheme"), object: nil)
    }
    
    override func updateViewConstraints() {
            super.updateViewConstraints()
            updateConstraints()
    }
    
    private func updateConstraints() {
        sectionUsernameLabel.snp.updateConstraints{
            $0.top.equalTo(view).offset(view.bounds.height * sectionUsernameTitleFromTopOffsetMul)
        }
        
        logoutButton.snp.updateConstraints{
            $0.bottom.equalTo(view).offset(-1 * view.bounds.height * logoutButtonFromBottomOffsetMul)
        }
        
        gradientLayer.reloadBoundsForGradient(view)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            view.setNeedsUpdateConstraints()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("NewTheme"), object: nil)
    }
    
    //MARK: - Building Views and Constraints
    private func buildViews() {
        gradientLayer.setBackgroundStyle(view)

        //MARK: Section Username Title Label
        sectionUsernameLabel = UILabel()
        sectionUsernameLabel.font = UIFont(name: Fonts.mainSemiBold, size: 12)
        sectionUsernameLabel.textAlignment = .left
        sectionUsernameLabel.text = "USERNAME"
        sectionUsernameLabel.textColor = .white
        
        //MARK: Username Label
        usernameLabel = UILabel()
        usernameLabel.font = UIFont(name: Fonts.mainBold, size: usernameFontSize)
        usernameLabel.textAlignment = .left
        usernameLabel.text = coordinator.getUsername()
        usernameLabel.textColor = .white
        
        //MARK: Logout Button
        logoutButton = MenuButton()
        logoutButton.setTitle("Log out", for: .normal)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        logoutButton.setTitleColor(UIColor(red: 252/255, green: 101/255, blue: 101/255, alpha: 1), for: .normal)
        
        //MARK: Section Style Chooser Title Label
        styleChooserLabel = UILabel()
        styleChooserLabel.font = UIFont(name: Fonts.mainSemiBold, size: 12)
        styleChooserLabel.textAlignment = .left
        styleChooserLabel.text = "COLOR"
        styleChooserLabel.textColor = .white
        
        //MARK: Style Chooser Segmented Control
        styleChooserSegmentedControl = UISegmentedControl(items: ["Purple", "Green", "Red"])
        styleChooserSegmentedControl.layer.cornerRadius = 10
        styleChooserSegmentedControl.layer.borderWidth = 1
        styleChooserSegmentedControl.layer.masksToBounds = true
        styleChooserSegmentedControl.layer.borderColor = UIColor.white.cgColor
        styleChooserSegmentedControl.tintColor = UIColor.white
        styleChooserSegmentedControl.selectedSegmentIndex = getSelectedStyleIndex()
        styleChooserSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        styleChooserSegmentedControl.selectedSegmentTintColor = Theme.current.buttonTextColor
        styleChooserSegmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        
        
        view.layer.addSublayer(gradientLayer)
        view.addSubview(sectionUsernameLabel)
        view.addSubview(usernameLabel)
        view.addSubview(styleChooserLabel)
        view.addSubview(styleChooserSegmentedControl)
        view.addSubview(logoutButton)
    }
    
    private func addConstraints() {
        sectionUsernameLabel.snp.makeConstraints{
            $0.top.equalTo(view).offset(view.bounds.height * sectionUsernameTitleFromTopOffsetMul)
            $0.leading.equalTo(view).offset(itemInsets)
        }
        
        usernameLabel.snp.makeConstraints{
            $0.top.equalTo(sectionUsernameLabel.snp.bottom).offset(itemDistance)
            $0.width.equalTo(view).inset(itemInsets)
            $0.centerX.equalTo(view)
        }
        
        styleChooserLabel.snp.makeConstraints{
            $0.top.equalTo(usernameLabel.snp.bottom).offset(itemDistance * 3)
            $0.leading.equalTo(view).offset(itemInsets)
        }
        
        styleChooserSegmentedControl.snp.makeConstraints{
            $0.top.equalTo(styleChooserLabel.snp.bottom).offset(itemDistance)
            $0.width.equalTo(view).inset(itemInsets)
            $0.centerX.equalTo(view)
            $0.height.equalTo(segmentedControlHeight)
        }
        
        logoutButton.snp.makeConstraints{
            $0.bottom.equalTo(view).offset(-1 * view.bounds.height * logoutButtonFromBottomOffsetMul)
            $0.width.equalTo(view).inset(buttonWidthInset)
            $0.height.equalTo(viewElementHeight)
            $0.centerX.equalToSuperview()
        }
    }
    
    
    //MARK: - Additional functions
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            Theme.current = PurpleTheme()
        case 1:
            Theme.current = GreenTheme()
        case 2:
            Theme.current = RedTheme()
        default:
            Theme.current = PurpleTheme()
        }
    }
    
    @objc private func logout() {
        coordinator.logout()
    }
    
    private func getSelectedStyleIndex() -> Int {
        switch Theme.current {
        case is PurpleTheme:
            return 0
        case is GreenTheme:
            return 1
        case is RedTheme:
            return 2
        default:
            return 0
        }
    }
    
    @objc func themeChanged() {
        DispatchQueue.main.async {
            self.gradientLayer.colors = Theme.current.gradientColor
            self.styleChooserSegmentedControl.selectedSegmentTintColor = Theme.current.buttonTextColor
            self.tabBarItem.selectedImage = self.tabBarItem.selectedImage?.withTintColor(Theme.current.tabbarSelectedImageColor, renderingMode: .alwaysOriginal)
        }
    }
}
