//
//  RequestError.swift
//  QuizApp
//
//  Created by Mac Use on 12.05.2021..
//

enum RequestError: Error {
    case clientError
    case serverError
    case noDataError
    case decodingError
}
