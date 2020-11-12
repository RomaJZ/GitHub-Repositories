//
//  GitHubAPI.swift
//  GitHub Repos
//
//  Created by Roma Filipenko on 12.11.2020.
//

import Foundation

class GitHubAPI: APIProtocol {
    
    func request<Model: Codable>(to endpoint: EndpointProtocol,
                           completion: @escaping (Result<Model, NetworkErrors>) -> ()) {
        print(endpoint)
        print(endpoint.request)
        let urlRequest = endpoint.request
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            
            guard error == nil else {
                completion(.failure(.errorResponse))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                completion(.failure(.badResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            guard let gitResponse = try? JSONDecoder().decode(Model.self, from: data) else {
                completion(.failure(.jsonDecoder))
                return
            }
            
            completion(.success(gitResponse))
        }
        dataTask.resume()
    }
}
