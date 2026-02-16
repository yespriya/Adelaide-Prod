//
//  APIError.swift
//  Adelaide Prod
//
//  Created by Prit  on 04/02/26.
//


import Foundation

enum APIError: Error {
    case invalidResponse
    case invalidData
    case invalidURL
    case expireToken
}


enum HttpStatusCode: Int, Error {
    case ok = 200
    case created = 201
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case notAllowed = 405
    case networkError = 1
    case invalidData = 109
    case validationFail = 1001
    case expireToken = 1002
    case unknown
}
