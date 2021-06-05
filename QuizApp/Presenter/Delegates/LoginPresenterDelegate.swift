//
//  PresenterDelegate.swift
//  QuizApp
//
//  Created by Mac Use on 15.05.2021..
//

import Foundation
import UIKit

protocol LoginPresenterDelegate: AnyObject {
    func successfulLogin()
    func unsuccessfulLogin()
}

typealias LoginPresenterDel = LoginPresenterDelegate & UIViewController

class LoginPresenter {
    
    weak var delegate: LoginPresenterDel?
    
    public func setViewDelegate(delegate: LoginPresenterDel) {
        self.delegate = delegate
    }
    
    public func login(email: String, password: String) {
        guard var url = URL(string: "https://iosquiz.herokuapp.com/api/session") else { return }
        url.appendQueryItem(name: "username", value: email)
        url.appendQueryItem(name: "password", value: password)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let networkService = NetworkService()
        networkService.executeUrlRequest(request) { (result: Result<UserModel, RequestError>) in
            switch result {
            case .failure(let error):
                MainCoordinator.handleRequestError(error: error)
                self.delegate?.unsuccessfulLogin()
            case .success(let value):
                UserDefaults.standard.set(value.token!, forKey: "Token")
                print(value.token!)
                UserDefaults.standard.set(value.userId!, forKey: "UserID")
                UserDefaults.standard.set(email, forKey: "Username")
                self.delegate?.successfulLogin()
            }
        }
    }
}

