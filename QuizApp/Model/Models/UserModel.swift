//
//  UserModel.swift
//  QuizApp
//
//  Created by Mac Use on 13.05.2021..
//

struct UserModel: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case token
        case userId = "user_id"
    }

    let token: String?
    let userId: Int?

}
