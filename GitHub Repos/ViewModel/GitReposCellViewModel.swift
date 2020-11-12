//
//  GitReposCellViewModel.swift
//  GitHub Repos
//
//  Created by Roma Filipenko on 12.11.2020.
//

import Foundation

protocol GitRepoCellViewModelProtocol: class {
    
    var name: String { get }
    var starsCount: String { get }
    
    init(gitRepo: GitRepo)
}

class GitReposCellViewModel: GitRepoCellViewModelProtocol {
    
    private let gitRepo: GitRepo
    
    var name: String {
        return gitRepo.name
    }
    
    var starsCount: String {
        return String(gitRepo.starsCount)
    }
    
    required init(gitRepo: GitRepo) {
        self.gitRepo = gitRepo
    }
}
