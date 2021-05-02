//
//  LoginViewController.swift
//  QuizApp
//
//  Created by Mac Use on 12.04.2021..
//

import UIKit
import SnapKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    //MARK: Constants
    
    private let distance : CGFloat = 18
    private let buttonOpacity : CGFloat = 0.6
    private let emailOffsetFromSuperview : CGFloat = 240
    private let titleLabelSizeLogin : CGFloat = 32
    private let titleLabelTopOffset : CGFloat = 80
    private let wrongCredentialsMessage : String = "Whoops! Couldn’t find your PopQuiz Account"
    private let wrongCredentialsFontSize : CGFloat = 16
    private let offsetEmailMultiplier: CGFloat = 0.2843
    private let offsetTitleMultiplier: CGFloat = 0.0948
    
    
    //MARK: Code
    private var titleLabel: PopQuizLabel!
    private var emailTextField: LoginTextField!
    private var passwordTextField: LoginTextField!
    private var loginButton: MenuButton!
    private var loginDataService: DataService!
    private var wrongCredentialsLabel: UILabel!
    private var showPasswordButton: UIButton!
    private var activeTextField: UITextField!
    private let tabBarViewController = UITabBarController()
    
    private let dataService = DataService()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildViews()
        addConstraints()
        loginButton.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
        showPasswordButton.addTarget(self, action: #selector(showHidePassword), for: .touchUpInside)
        
        //Listeners
        [emailTextField, passwordTextField].forEach {$0?.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)}
        [emailTextField, passwordTextField].forEach {$0?.addTarget(self, action: #selector(editBegin(_:)), for: .editingDidBegin)}
        [emailTextField, passwordTextField].forEach {$0?.addTarget(self, action: #selector(editEnd(_:)), for: .editingDidEnd)}
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //Dismissing keyboard by touching anywhere on the screen
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func updateViewConstraints() {
            super.updateViewConstraints()
            updateConstraints()
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            view.setNeedsUpdateConstraints()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardDidShow(notification: Notification) {
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let keyboardY = view.frame.size.height -  keyboardSize.height
        let editingTextFieldY: CGFloat! = activeTextField?.frame.origin.y
        
        if(editingTextFieldY > keyboardY - 60 && view.frame.origin.y >= 0) {
            view.frame = CGRect(x: 0, y: view.frame.origin.y - (editingTextFieldY! - (keyboardY - 60)), width: view.bounds.width, height: view.bounds.height)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
    }
    
    @objc func showHidePassword() {
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    @objc func textChanged(_ textField: UITextField) {
        //Maknuti labelu za incorrect credentials usput
        wrongCredentialsLabel.isHidden = true
        
        textField.text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        loginButton.isEnabled = ![emailTextField, passwordTextField].compactMap { // promijeniti na citljivije
            $0.text?.isEmpty
        }.contains(true)
        
        loginButton.alpha = loginButton.isEnabled ? 1 : 0.6
    }
    
    @objc func editBegin(_ textField: UITextField) {
        if textField == passwordTextField {
            showPasswordButton.isHidden.toggle()
        }
        
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.white.cgColor
        
        activeTextField = textField
    }
    
    @objc func editEnd(_ textField: UITextField) {
        if textField == passwordTextField {
            showPasswordButton.isHidden.toggle()
            passwordTextField.isSecureTextEntry.toggle()
        }
        
        textField.layer.borderWidth = 0
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.resignFirstResponder()
    }

    @objc func loginPressed() {
        print("email: \(emailTextField.text!) password: \(passwordTextField.text!)") //guard stavit
        let loginStatus = dataService.login(email: emailTextField.text!, password: passwordTextField.text!)
        if case loginStatus = LoginStatus.success {
            initializeTabBar()
            tabBarViewController.modalPresentationStyle = .fullScreen
            present(tabBarViewController, animated: true, completion: nil)
        } else {
            wrongCredentialsLabel.isHidden.toggle()
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
        items[0].image = ImageEnum.firstTabBarItem.image
        items[0].selectedImage = ImageEnum.firstTabBarItemSelected.image
        items[1].image = ImageEnum.secondTabBarItem.image
        items[1].selectedImage = ImageEnum.secondTabBarItemSelected.image
        items[2].image = ImageEnum.thirdTabBarItem.image
        items[2].selectedImage = ImageEnum.thirdTabBarItemSelected.image
        /*items[0].image = UIImage(systemName: "questionmark.square.fill")
        items[0].selectedImage = UIImage(systemName: "questionmark.square.fill")?.withTintColor(tabBarItemColorSelected, renderingMode: .alwaysOriginal)
        items[1].image = UIImage(systemName: "magnifyingglass")
        items[1].selectedImage = UIImage(systemName: "magnifyingglass")?.withTintColor(tabBarItemColorSelected, renderingMode: .alwaysOriginal)
        items[2].image = UIImage(systemName: "gearshape.fill")
        items[2].selectedImage = UIImage(systemName: "gearshape.fill")?.withTintColor(tabBarItemColorSelected, renderingMode: .alwaysOriginal)*/
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
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.6)])
        
        //MARK: Password Text Field
        passwordTextField = LoginTextField()
        passwordTextField.attributedPlaceholder =  NSAttributedString(string: "Password",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.6)])
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
        showPasswordButton.setImage(ImageEnum.passwordEye.image, for: .normal)
        showPasswordButton.isHidden = true
        showPasswordButton.backgroundColor = UIColor.clear
        
        view.addSubview(loginButton)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(titleLabel)
        view.addSubview(wrongCredentialsLabel)
        view.addSubview(showPasswordButton)
    }
    
    private func updateConstraints() {
        emailTextField.snp.updateConstraints{
            $0.top.equalTo(view).offset(view.bounds.height * offsetEmailMultiplier)
        }
        
        titleLabel.snp.updateConstraints{
            $0.top.equalTo(view).offset(view.bounds.height * offsetTitleMultiplier)
        }
    }
    
    private func addConstraints() {
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(view).offset(view.bounds.height * offsetTitleMultiplier)
            $0.centerX.equalTo(view)
        }
        
        emailTextField.snp.makeConstraints{
            $0.width.equalTo(view).inset(buttonWidthInset)
            $0.height.equalTo(viewElementHeight)
            
            /*Želio sam napraviti offset od superviewa da bude ovisan o visini ekrana, a ne konstantan
            no nisam siguran kako to napraviti*/
            $0.top.equalTo(view).offset(view.bounds.height * offsetEmailMultiplier)
            //view.bounds.height * 0.2
            //pomaknuti constrainte kad se pojavi tipkovnica
            $0.centerX.equalTo(view)
        }
        
        loginButton.snp.makeConstraints{
            $0.width.equalTo(view).inset(buttonWidthInset)
            $0.height.equalTo(viewElementHeight)
            $0.top.equalTo(passwordTextField.snp.bottom).offset(distance)
            $0.centerX.equalTo(view)
        }
        
        
        passwordTextField.snp.makeConstraints{
            $0.width.equalTo(view).inset(buttonWidthInset)
            $0.height.equalTo(viewElementHeight)
            $0.top.equalTo(emailTextField.snp.bottom).offset(distance)
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
}
