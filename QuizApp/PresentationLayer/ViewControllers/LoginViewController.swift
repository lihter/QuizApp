//
//  LoginViewController.swift
//  QuizApp
//
//  Created by Mac Use on 12.04.2021..
//

import UIKit
import SnapKit

class LoginViewController: UIViewController, UITextFieldDelegate, LoginPresenterDelegate {
    
    //MARK: - Constants
    private let distance : CGFloat = 18
    private let buttonOpacity : CGFloat = 0.6
    private let titleLabelSizeLogin : CGFloat = 32
    private let wrongCredentialsMessage : String = "Whoops! Couldn’t find your PopQuiz Account"
    private let wrongCredentialsFontSize : CGFloat = 16
    private let offsetEmailMultiplier: CGFloat = 0.2843
    private let offsetTitleMultiplier: CGFloat = 0.0948
    private let durationOfSingleAnimation: CGFloat = 1.5
    private let delayBetweenAnimations: CGFloat = 0.25
    
    //MARK: - VC elements
    private var gradientLayer = CAGradientLayer()
    private var titleLabel: PopQuizLabel!
    private var emailTextField: LoginTextField!
    private var passwordTextField: LoginTextField!
    private var loginButton: MenuButton!
    private var wrongCredentialsLabel: UILabel!
    private var showPasswordButton: UIButton!
    private var activeTextField: UITextField!
    private var coordinator: MainCoordinatorPatternProtocol!
    private let presenter = LoginPresenter()
    
    private var animateIn: UIViewPropertyAnimator!
    private var animateOut: UIViewPropertyAnimator!
    private var centerConstraint: CGFloat!
    
    //MARK: - Code
    convenience init(coordinator: MainCoordinator) {
        self.init()
        
        self.coordinator = coordinator
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateAtStart()
    }

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
        
        
        //Implementirao sam pomicanje svega prema gore pri prikazu tipkovnice, ucinak toga vidi se pri otvaranju tipkovnice za unos passworda dok smo u landscape modu!!!
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //Dismissing keyboard by touching anywhere on the screen
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
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
    
    
    //MARK: - Building Views and Constraints
    private  func buildViews() {
        gradientLayer.setBackgroundStyle(view)
        
        //MARK: Login button
        loginButton = MenuButton()
        loginButton.setTitle("Login", for: .normal)
        loginButton.alpha = buttonOpacity
        
        //MARK: Email Text Field
        emailTextField = LoginTextField()
        emailTextField.keyboardType = .emailAddress
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
        
        view.layer.addSublayer(gradientLayer)
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
        
        gradientLayer.reloadBoundsForGradient(view)
    }
    
    private func addConstraints() {
        
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(view).offset(view.bounds.height * offsetTitleMultiplier)
            $0.centerX.equalTo(view)
        }
        
        emailTextField.snp.makeConstraints{
            $0.width.equalTo(view).inset(buttonWidthInset)
            $0.height.equalTo(viewElementHeight)
            
            $0.top.equalTo(view).offset(view.bounds.height * offsetEmailMultiplier)
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
    
    //MARK: - Additional functions
    
    func successfulLogin() {
        DispatchQueue.main.async {
            self.animateSuccessfulLogin()
        }
    }
    
    func unsuccessfulLogin() {
        DispatchQueue.main.async {
            self.wrongCredentialsLabel.isHidden = false
        }
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
        //Micem labelu za incorrect credentials usput
        wrongCredentialsLabel.isHidden = true
        
        textField.text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        loginButton.isEnabled = ![emailTextField, passwordTextField].compactMap {
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
        }
        
        textField.layer.borderWidth = 0
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.resignFirstResponder()
    }

    @objc func loginPressed() {
        print("email: \(emailTextField.text!) password: \(passwordTextField.text!)")
        presenter.setViewDelegate(delegate: self)
        presenter.login(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
    }
    
    private func cofigureInitialAnimationSetup() {
        titleLabel.alpha = 0
        titleLabel.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        emailTextField.alpha = 0
        emailTextField.frame.origin.x = -emailTextField.frame.width
        
        passwordTextField.alpha = 0
        passwordTextField.frame.origin.x = -passwordTextField.frame.width
        
        loginButton.alpha = 0
        loginButton.frame.origin.x = -loginButton.frame.width
    }
    
    private func animateAtStart() {
        animateIn = UIViewPropertyAnimator(
            duration: Double(durationOfSingleAnimation + delayBetweenAnimations * 3),
            curve: .easeInOut)
        
        cofigureInitialAnimationSetup()
        
        animateIn.addAnimations {
            self.titleLabel.alpha = 1
            self.titleLabel.transform  = CGAffineTransform(scaleX: 1, y: 1)
        }
        
        animateIn.addAnimations({
            self.emailTextField.alpha = 1
            self.emailTextField.frame.origin.x = (self.view.frame.width - self.emailTextField.frame.width) / 2
        }, delayFactor: delayBetweenAnimations)
        
        animateIn.addAnimations({
            self.passwordTextField.alpha = 1
            self.passwordTextField.frame.origin.x = (self.view.frame.width - self.passwordTextField.frame.width) / 2
        }, delayFactor: 2 * delayBetweenAnimations)
        
        animateIn.addAnimations({
            self.loginButton.alpha = self.buttonOpacity
            self.loginButton.frame.origin.x = (self.view.frame.width - self.loginButton.frame.width) / 2
        }, delayFactor: 3 * delayBetweenAnimations)
        
        animateIn.startAnimation()
    }
    
    private func animateSuccessfulLogin() {
        animateOut = UIViewPropertyAnimator(
            duration: Double(durationOfSingleAnimation + delayBetweenAnimations * 3),
            curve: .easeInOut)
        
        animateOut.addAnimations {
            self.titleLabel.frame.origin.y = -self.titleLabel.frame.height
        }
        
        animateOut.addAnimations({
            self.emailTextField.frame.origin.y = -self.emailTextField.frame.height
        }, delayFactor: delayBetweenAnimations)
        
        animateOut.addAnimations({
            self.passwordTextField.frame.origin.y = -self.passwordTextField.frame.height
            self.showPasswordButton.frame.origin.y = -self.showPasswordButton.frame.height
        }, delayFactor: 2 * delayBetweenAnimations)
        
        animateOut.addAnimations({
            self.loginButton.frame.origin.y = -self.loginButton.frame.height
        }, delayFactor: 3 * delayBetweenAnimations)
        
        animateOut.addCompletion {_ in
            self.coordinator.successfulLogin()
        }
        
        animateOut.startAnimation()
    }
}
