//
//  LeaderboardCell.swift
//  QuizApp
//
//  Created by Mac Use on 06.05.2021..
//

import UIKit

class LeaderboardCell: UITableViewCell {
    //MARK: - Constants
    private let textFromViewInset: CGFloat = 20
    private let usernameFromPlaceInset: CGFloat = 8
    private let pointsFromViewInset: CGFloat = 32
    private let itemFromBottomInset: CGFloat = 15
    
    //MARK: - View vars
    private var placeLabel: UILabel!
    private var usernameLabel: UILabel!
    private var pointsLabel: UILabel!
    
    //MARK: - Code
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //MARK: Cell Settings
        backgroundColor = .clear
        selectionStyle = .none
        
        configurePlaceLabel()
        configureUsernameLabel()
        configurePointsLabel()
        
        addSubview(placeLabel)
        addSubview(usernameLabel)
        addSubview(pointsLabel)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Building Views and Constraints
    private func configurePointsLabel() {
        //MARK: Points Label
        pointsLabel = UILabel()
        pointsLabel.font = UIFont(name: Fonts.mainBold, size: 26)
        pointsLabel.textAlignment = .right
        pointsLabel.textColor = .white
    }
    
    private func configureUsernameLabel() {
        //MARK: Username Label
        usernameLabel = UILabel()
        usernameLabel.font = UIFont(name: Fonts.mainBold, size: 20)
        usernameLabel.textAlignment = .left
        usernameLabel.textColor = .white
    }
    
    private func configurePlaceLabel() {
        //MARK: Place Label
        placeLabel = UILabel()
        placeLabel.font = UIFont(name: Fonts.mainBold, size: 24)
        placeLabel.textAlignment = .left
        placeLabel.textColor = .white
    }
    
    private func setConstraints() {
        placeLabel.snp.makeConstraints{
            $0.leading.equalTo(self.snp.leading).offset(textFromViewInset)
            $0.bottom.equalTo(self.snp.bottom).offset(-1 * itemFromBottomInset)
        }
        
        usernameLabel.snp.makeConstraints{
            $0.leading.equalTo(placeLabel.snp.trailing).offset(usernameFromPlaceInset)
            $0.width.equalTo(self.bounds.width * 0.5)
            $0.bottom.equalTo(self.snp.bottom).offset(-1 * itemFromBottomInset)
        }
        
        pointsLabel.snp.makeConstraints{
            $0.trailing.equalTo(self.snp.trailing).offset(-1 * pointsFromViewInset)
            $0.bottom.equalTo(self.snp.bottom).offset(-1 * itemFromBottomInset)
        }
        
    }
    
    //MARK: - Additional functions
    
    func set(place: Int, username: String, points: String) {
        placeLabel.text = String(place) + "."
        usernameLabel.text = username
        pointsLabel.text = points
    }
}
