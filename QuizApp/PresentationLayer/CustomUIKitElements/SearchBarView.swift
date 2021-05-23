//
//  SearchBarView.swift
//  QuizApp
//
//  Created by Mac Use on 22.05.2021..
//

import UIKit

protocol SearchDelegate {
    func handleSearch(forText: String?)
}

typealias SearchPresenterDel = SearchDelegate & UIViewController


class SearchBarView: UIView {
    
    weak var delegate: SearchPresenterDel?
    
    public func setViewDelegate(delegate: SearchPresenterDel) {
        self.delegate = delegate
    }
    
    //MARK: - Constants
    private let buttonFontSize: CGFloat = 16
    private let itemHeight: CGFloat = 44
    private let itemHorizontalOffset: CGFloat = 20
    
    //MARK: - View vars
    private var searchTextField: LoginTextField!
    private var searchButton: UIButton!
    
    //MARK: - Code
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Building Views and Constraints
    private func buildViews() {
        
        //MARK: Search Text Field
        searchTextField = LoginTextField()
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Type here",
                                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.6)])
        searchTextField.keyboardType = .webSearch
        
        //MARK: Search Button
        searchButton = UIButton()
        searchButton.setTitle("Search", for: .normal)
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.titleLabel?.font = UIFont(name: Fonts.mainBold, size: buttonFontSize)
        searchButton.contentHorizontalAlignment = .center
        searchButton.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        
        addSubview(searchTextField)
        addSubview(searchButton)
    }
    
    private func setConstraints() {
        searchButton.snp.makeConstraints{
            $0.trailing.equalTo(self.snp.trailing).inset(itemHorizontalOffset)
            $0.height.equalTo(itemHeight)
            $0.width.equalTo(50)
        }
        
        searchTextField.snp.makeConstraints{
            $0.leading.equalTo(self.snp.leading).offset(itemHorizontalOffset)
            $0.trailing.equalTo(searchButton.snp.leading).offset(-1 * itemHorizontalOffset)
            $0.height.equalTo(itemHeight)
        }
    }
    
    //MARK: - Additional functions
    @objc func handleSearch() {
        self.delegate?.handleSearch(forText: searchTextField.text)
    }
}
