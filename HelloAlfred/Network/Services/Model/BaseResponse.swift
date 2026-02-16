//
//  BaseResponse.swift
//  Adelaide Prod
//
//  Created by Prit  on 04/02/26.
//

import Foundation

struct BaseResponse<T: Codable>: Codable {
    let status: Bool?
    let statuscode : Int?
    let message: String?
    let data: T?
}

struct SimpleResponse: Codable {
    let status: Bool?
    let statuscode : Int?
    let message: String?
}
