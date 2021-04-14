//
//  LoginViewController.swift
//  QuizApp
//
//  Created by Mac Use on 12.04.2021..
//

import UIKit
import SnapKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    var titleLabel: PopQuizLabel!
    var emailTextField: LoginTextField!
    var passwordTextField: LoginTextField!
    var loginButton: MenuButton!
    var loginDataService: DataService!
    var wrongCredentialsLabel: UILabel!
    var showPasswordButton: UIButton!
    let tabBarViewController = UITabBarController()
    
    let dataService = DataService()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildViews()
        addConstraints()
        loginButton.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
        showPasswordButton.addTarget(self, action: #selector(showHidePassword), for: .touchUpInside)
        [emailTextField, passwordTextField].forEach {$0?.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)}
        [emailTextField, passwordTextField].forEach {$0?.addTarget(self, action: #selector(editBegin(_:)), for: .editingDidBegin)}
        [emailTextField, passwordTextField].forEach {$0?.addTarget(self, action: #selector(editEnd(_:)), for: .editingDidEnd)}
    }
    
    @objc func showHidePassword() {
        if passwordTextField.isSecureTextEntry {
            passwordTextField.isSecureTextEntry = false
        } else {
            passwordTextField.isSecureTextEntry = true
        }
    }
    
    @objc func textChanged(_ textField: UITextField) {
        //Maknuti labelu za incorrect credentials usput
        wrongCredentialsLabel.isHidden = true
        
        textField.text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        loginButton.isEnabled = ![emailTextField, passwordTextField].compactMap {
            $0.text?.isEmpty
        }.contains(true)
        
        if loginButton.isEnabled {
            loginButton.alpha = 1
        }
    }
    
    @objc func editBegin(_ textField: UITextField) {
        if textField == passwordTextField {
            showPasswordButton.isHidden = false
        }
        
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.white.cgColor
    }
    
    @objc func editEnd(_ textField: UITextField) {
        if textField == passwordTextField {
            showPasswordButton.isHidden = true
            passwordTextField.isSecureTextEntry = true
        }
        
        textField.layer.borderWidth = 0
        textField.layer.borderColor = UIColor.clear.cgColor
    }

    @objc func loginPressed() {
        print("email: \(emailTextField.text!) password: \(passwordTextField.text!)")
        let loginStatus = dataService.login(email: emailTextField.text!, password: passwordTextField.text!)
        if case loginStatus = LoginStatus.success {
            initializeTabBar()
            tabBarViewController.modalPresentationStyle = .fullScreen
            present(tabBarViewController, animated: true, completion: nil)
        } else {
            wrongCredentialsLabel.isHidden = false
        }
    }
    
    private func initializeTabBar() {
        let quizVC = QuizzesViewController()
        let searchVC = SearchViewController()
        let settingsVC = SettingsViewController()
        
        quizVC.title = "Quiz"
        searchVC.title = "Search"
        settingsVC.title = "Settings"
        
        tabBarViewController.setViewControllers([quizVC, searchVC, settingsVC], animated: false)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)

        let items = tabBarViewController.tabBar.items!
        let images = ["questionmark.square.fill", "magnifyingglass", "gearshape.fill"]
        for i in 0..<items.count {
            items[i].image = UIImage(systemName: images[i])
            items[i].selectedImage = UIImage(systemName: images[i])?.withTintColor(tabBarItemColorSelected, renderingMode: .alwaysOriginal)
        }
    }
    
    private  func buildViews()  {
        setBackgroundStyle(view, style)
        
        //MARK: Login button
        loginButton = MenuButton(style)
        loginButton.setTitle("Login", for: .normal)
        loginButton.alpha = buttonOpacity
        
        //MARK: Email Text Field
        emailTextField = LoginTextField()
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)])
        
        //MARK: Password Text Field
        passwordTextField = LoginTextField()
        passwordTextField.attributedPlaceholder =  NSAttributedString(string: "Password",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)])
        passwordTextField.isSecureTextEntry = true
        
        //MARK: Title Pop Quiz Label
        titleLabel = PopQuizLabel(size: titleLabelSizeLogin)
        
        //MARK: Wrong Credentials Label
        wrongCredentialsLabel = UILabel()
        wrongCredentialsLabel.font = UIFont(name: Fonts.main, size: wrongCredentialsFontSize)
        wrongCredentialsLabel.textAlignment = .center
        wrongCredentialsLabel.textColor = .white
        wrongCredentialsLabel.numberOfLines = 0
        wrongCredentialsLabel.lineBreakMode = .byWordWrapping
        wrongCredentialsLabel.attributedText = NSMutableAttributedString(string: wrongCredentialsMessage,
                                                                    attributes: [NSAttributedString.Key.kern: 0.22])
        wrongCredentialsLabel.isHidden = true
        
        //MARK: Show Password Button
        showPasswordButton = UIButton()
        showPasswordButton.setImage(UIImage(named: showPasswordImage), for: .normal)
        showPasswordButton.isHidden = true
        showPasswordButton.backgroundColor = UIColor.clear
        
        view.addSubview(loginButton)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(titleLabel)
        view.addSubview(wrongCredentialsLabel)
        view.addSubview(showPasswordButton)
    }
    
    private func addConstraints() {
        loginButton.snp.makeConstraints{
            $0.width.equalTo(view).inset(buttonWidthInset)
            $0.height.equalTo(viewElementHeight)
            $0.top.equalTo(passwordTextField.snp.bottom).offset(distance)
            $0.centerX.equalTo(view)
        }
        
        emailTextField.snp.makeConstraints{
            $0.width.equalTo(view).inset(buttonWidthInset)
            $0.height.equalTo(viewElementHeight)
            
            /*Želio sam napraviti offset od superviewa da bude ovisan o visini ekrana, a ne konstantan
            no nisam siguran kako to napraviti*/
            $0.top.equalToSuperview().offset(emailOffsetFromSuperview)
            $0.centerX.equalTo(view)
        }
        
        passwordTextField.snp.makeConstraints{
            $0.width.equalTo(view).inset(buttonWidthInset)
            $0.height.equalTo(viewElementHeight)
            $0.top.equalTo(emailTextField.snp.bottom).offset(distance)
            $0.centerX.equalTo(view)
        }
        
        titleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(titleLabelTopOffset)
            $0.centerX.equalTo(view)
        }
        
        wrongCredentialsLabel.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(distance)
            $0.centerX.equalTo(view)
            $0.width.equalTo(view).inset(buttonWidthInset)
        }
        
        showPasswordButton.snp.makeConstraints {
            $0.centerY.equalTo(passwordTextField.snp.centerY)
            $0.trailing.equalTo(passwordTextField.snp.trailing).inset(15)
        }
        
    }
    
    //MARK: Constants
    
    let distance : CGFloat = 18
    let buttonOpacity : CGFloat = 0.6
    let emailOffsetFromSuperview : CGFloat = 240
    let titleLabelSizeLogin : CGFloat = 32
    let titleLabelTopOffset : CGFloat = 80
    let wrongCredentialsMessage : String = "Whoops! Couldn’t find your PopQuiz Account"
    let wrongCredentialsFontSize : CGFloat = 16
    let showPasswordImage: String = "Hide.svg"
}
