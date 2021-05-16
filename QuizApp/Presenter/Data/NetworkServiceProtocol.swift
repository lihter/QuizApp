//
//  NetworkServiceProtocol.swift
//  QuizApp
//
//  Created by Mac Use on 12.05.2021..
//
import Foundation

protocol NetworkServiceProtocol {
    
    func executeUrlRequest<T: Decodable>(_ request: URLRequest, completionHandler: @escaping(Result<T, RequestError>) -> Void)
}
