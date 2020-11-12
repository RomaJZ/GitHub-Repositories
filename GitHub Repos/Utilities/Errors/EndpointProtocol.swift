//
//  EndpointProtocol.swift
//  GitHub Repos
//
//  Created by Roma Filipenko on 10.11.2020.
//

import Foundation

protocol Endpoint {
    
    var method: String { get }
    var baseUrl: String { get }
    var path: String { get }
    var urlParameters: [URLQueryItem] { get }
    var headers: [String: Any] { get }
}

extension Endpoint {
    
    var request: URLRequest {
        
    }
    
    var urlComponents: URLComponents {
        
        var urlComponents = URLComponents(string: baseUrl)
        urlComponents?.path = path
        urlComponents?.queryItems = urlParameters
        
        return urlComponents!
    }
}
