//
//  APIProtocol.swift
//  GitHub Repos
//
//  Created by Roma Filipenko on 12.11.2020.
//

import Foundation

protocol APIProtocol: class {
    
    func request<Model: Codable>(to endpoint: EndpointProtocol,
                             completion: @escaping (Result<Model, NetworkErrors>) -> ())
}
