//
//  QuizNetworkSourceProtocol.swift
//  QuizApp
//
//  Created by Mac Use on 20.05.2021..
//

protocol QuizNetworkSourceProtocol {
    func fetchQuizzesFromNetwork() throws -> [Quiz]
}
