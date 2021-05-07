//
//  LeaderboardModel.swift
//  QuizApp
//
//  Created by Mac Use on 06.05.2021..
//

import Foundation

//Kasnije cu implementirati kompleksiniji struct koji ce davati leaderboard s obzirom na quiz
//Vidio sam da ce se to traziti u trecoj zadaci, ali sad sam samo konstruirao ovu jednostavniju verziju problema, takoder napravio sam i svoj .json file i uploadao ga na internet, te podatke fetcham s tog .json filea
struct LeaderboardModel: Decodable {
    let users: [User]
}

struct User: Decodable {
    let username: String
    let points: Int
}
