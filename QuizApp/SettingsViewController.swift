//
//  SettingsViewController.swift
//  QuizApp
//
//  Created by Mac Use on 13.04.2021..
//

import UIKit

class SettingsViewController: UIViewController {
    //MARK: Constants
    private let usernameFontSize: CGFloat = 35
    private let sectionUsernameTitleFromTopOffsetMul: CGFloat = 0.1381
    private let itemInsets: CGFloat = 20
    private let itemDistance: CGFloat = 6
    private let segmentedControlHeight: CGFloat = 25
    private let logoutButtonFromBottomOffsetMul: CGFloat = 0.15
    
    //MARK: Code
    private var gradientLayer: CAGradientLayer!
    private var sectionUsernameLabel: UILabel!
    private var usernameLabel: UILabel!
    private var styleChooserLabel: UILabel!
    private var styleChooserSegmentedControl: UISegmentedControl!
    private var logoutButton: MenuButton!
    private var coordinator: MainCoordinatorPatternProtocol!
    
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
    
    private func buildViews() {
        gradientLayer = setBackgroundStyle(view)

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
        usernameLabel.text = coordinator.getUsername() //kasnije pretpostavljam da će se maknuti ova hard kodirana verzija
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
        styleChooserSegmentedControl.selectedSegmentTintColor = buttonColorStyle(style)
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
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            style = StyleOptions.purple
        case 1:
            style = StyleOptions.green
        case 2:
            style = StyleOptions.red
        default:
            style = StyleOptions.purple
        }
        reloadThisView()
    }
    
    private func reloadThisView() {
        /*DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.gradientLayer.colors = returnGradientColor()
        }*/
        /*Pretpostavljam da ovo nebi tako trebalo rješiti s pozivom viewDidLoad()
        Mozda napraviti neki protocol koji bude obvezal sve tabbar vc-ove
        da moraju imati metodu kao reloadThisView() i uz pomoc dispatchQ.main-a updateamo*/
        //tabBarController?.viewControllers?.forEach { $0.viewDidLoad() }
        
        //POPRAVLJENO (donekle)!
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.tabBarController?.viewControllers?.forEach{
                $0.view.layer.sublayers?.remove(at: 0)
                $0.view.layer.sublayers?.insert(setBackgroundStyle($0.view), at: 0)
                $0.tabBarItem.selectedImage = $0.tabBarItem.selectedImage?.withTintColor(tabBarSelectedImageColor(style), renderingMode: .alwaysOriginal)
            }
        }
        
        styleChooserSegmentedControl.selectedSegmentTintColor = buttonColorStyle(style)
    }
    
    @objc private func logout() {
        coordinator.logout()
    }
    
    private func getSelectedStyleIndex() -> Int {
        switch style {
        case .purple:
            return 0
        case .green:
            return 1
        case .red:
            return 2
        }
    }
}
