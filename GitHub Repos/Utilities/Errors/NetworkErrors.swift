//
//  NetworkErrors.swift
//  GitHub Repos
//
//  Created by Roma Filipenko on 12.11.2020.
//

import Foundation

enum NetworkErrors: String, Error {
    case errorResponse = "An error occured: "
    case badResponse = "Bad response. Try again"
    case badData = "Bad data. Try again"
    case jsonDecoder = "Data decoding error"
    case unknown = "Unknown error has occured"
}
