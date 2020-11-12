//
//  GitRepo.swift
//  GitHub Repos
//
//  Created by Roma Filipenko on 12.11.2020.
//

import Foundation

struct GitResponse: Codable {
    
    let totalReposCount: Int
    let gitRepos: [GitRepo]
    
    private enum CodingKeys: String, CodingKey {
        case totalReposCount = "total_count"
        case gitRepos = "items"
    }
}

struct GitRepo: Codable {
    
    let name: String
    let starsCount: Int
    
    private enum CodingKeys: String, CodingKey {
        case name = "full_name"
        case starsCount = "stargazers_count"
    }
}
