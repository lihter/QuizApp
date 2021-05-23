//
//  NetworkService.swift
//  QuizApp
//
//  Created by Mac Use on 12.05.2021..
//

import Foundation

class NetworkService: NetworkServiceProtocol {
    
    func executeUrlRequest<T: Decodable>(_ request: URLRequest, completionHandler: @escaping(Result<T, RequestError>) -> Void) {
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, err in
            guard err == nil else {
                completionHandler(.failure(.clientError))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode) else {
                let httpResponse = response as? HTTPURLResponse
                switch httpResponse?.statusCode {
                case 400:
                    print("Bad request")
                case 401:
                    print("Unauthorized")
                case 403:
                    print("Forbidden")
                case 404:
                    print("Not found")
                default:
                    print("Unkown error")
                }
                completionHandler(.failure(.serverError))
                return
            }
            guard let data = data else {
                completionHandler(.failure(.noDataError))
                return
            }
            guard let value = try? JSONDecoder().decode(T.self, from: data) else {
                completionHandler(.failure(.decodingError))
                return
            }
            completionHandler(.success(value))
        }
        dataTask.resume()
    }
}

