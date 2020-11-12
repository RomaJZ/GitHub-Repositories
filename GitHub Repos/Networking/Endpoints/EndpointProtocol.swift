//
//  EndpointProtocol.swift
//  GitHub Repos
//
//  Created by Roma Filipenko on 12.11.2020.
//

import Foundation

protocol EndpointProtocol {
    
    var method: String { get }
    var baseUrl: String { get }
    var path: String { get }
    var urlParameters: [URLQueryItem] { get }
}

extension EndpointProtocol {
    
    var request: URLRequest {
        
        var request = URLRequest(url: urlComponents.url!)
        let apiToken = PlistDataExtractor.extractFrom("APIList", property: "token") ?? ""
        
        request.httpMethod = method
        
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        request.setValue("token \(apiToken)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    private var urlComponents: URLComponents {
        
        var urlComponents = URLComponents(string: baseUrl)
        urlComponents?.path = path
        urlComponents?.queryItems = urlParameters
        
        return urlComponents!
    }
}
