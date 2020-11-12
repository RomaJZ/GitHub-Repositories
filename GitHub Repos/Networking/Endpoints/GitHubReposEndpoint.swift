//
//  GitHubReposEndpoint.swift
//  GitHub Repos
//
//  Created by Roma Filipenko on 12.11.2020.
//

import Foundation

enum GitHubReposEndpoint: EndpointProtocol {
    
    case search(query: String, page: Int)
    
    var method: String {
        return "GET"
    }
    
    var baseUrl: String {
        if let url = PlistDataExtractor.extractFrom("APIList", property: "baseUrl") {
            return url
        } else {
            return "https://api.github.com"
        }
    }
    
    var path: String {
        return "/search/repositories"
    }
    
    var urlParameters: [URLQueryItem] {
        
        switch self {
        
        case .search(let query, let page):
            
            let finalQuery = query.lowercased().replacingOccurrences(of: " ", with: "+")
            
            return [
                URLQueryItem(name: "q", value: finalQuery),
                URLQueryItem(name: "sort", value: "stars"),
                URLQueryItem(name: "order", value: "desc"),
                URLQueryItem(name: "per_page", value: "15"),
                URLQueryItem(name: "page", value: "\(page)")
            ]
        }
    }
}
