//
//  QuizRepositoryProtocol.swift
//  QuizApp
//
//  Created by Mac Use on 20.05.2021..
//

protocol QuizRepositoryProtocol {
    func fetchNetworkData(completionHandler: @escaping (Error?) -> Void)
    func fetchLocalData(filter: FilterSettings) -> [Quiz]
    func deleteLocalData(withId id: Int)
}

