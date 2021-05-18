//
//  LeaderboardCell.swift
//  QuizApp
//
//  Created by Mac Use on 06.05.2021..
//

import UIKit

class LeaderboardCell: UITableViewCell {
    //MARK: Constants
    private let textFromViewInset: CGFloat = 20
    private let usernameFromPlaceInset: CGFloat = 8
    private let pointsFromViewInset: CGFloat = 32
    private let itemFromBottomInset: CGFloat = 15
    
    //MARK: Code
    private var placeLabel: UILabel!
    private var usernameLabel: UILabel!
    private var pointsLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //MARK: Cell Settings
        backgroundColor = .clear
        selectionStyle = .none
        
        //MARK: Place Label
        placeLabel = UILabel()
        placeLabel.font = UIFont(name: Fonts.mainBold, size: 24)
        placeLabel.textAlignment = .left
        placeLabel.textColor = .white
        
        //MARK: Username Label
        usernameLabel = UILabel()
        usernameLabel.font = UIFont(name: Fonts.mainBold, size: 20)
        usernameLabel.textAlignment = .left
        usernameLabel.textColor = .white
        
        //MARK: Points Label
        pointsLabel = UILabel()
        pointsLabel.font = UIFont(name: Fonts.mainBold, size: 26)
        pointsLabel.textAlignment = .right
        pointsLabel.textColor = .white
        
        addSubview(placeLabel)
        addSubview(usernameLabel)
        addSubview(pointsLabel)
        
        setConstraints()
    }
    
    private func setConstraints() {
        placeLabel.snp.makeConstraints{
            //$0.centerY.equalTo(self)
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(place: Int, username: String, points: Int) {
        placeLabel.text = String(place) + "."
        usernameLabel.text = username
        pointsLabel.text = String(points)
    }
}
