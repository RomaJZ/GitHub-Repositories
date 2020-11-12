//
//  GitReposViewModel.swift
//  GitHub Repos
//
//  Created by Roma Filipenko on 12.11.2020.
//

import Foundation

protocol GitReposViewModelProtocol: class {
    
    var showLoading: (() -> Void)? { get set }
    var reloadData: (() -> Void)? { get set }
    var showError: ((Error) -> Void)? { get set }
    var reposCount: Int { get }
    
    init(loader: APIProtocol, endpoint: EndpointProtocol)
    
    func fetchGitRepos()
    func getNewGitRepos(with name: String)
    func loadMoreGitRepos()
    func getGitRepoCellViewModel(for indexPath: IndexPath) -> GitRepoCellViewModelProtocol?
}

class GitReposViewModel: GitReposViewModelProtocol {
    
//MARK: Public Closures
    
    var reposCount: Int {
        return gitRepos.count
    }
    var showLoading: (() -> Void)?
    var reloadData: (() -> Void)?
    var showError: ((Error) -> Void)?
    
//MARK: Private Variables
    
    private var loader: APIProtocol!
    private var endpoint: EndpointProtocol!
    private var canFetch = true
    private var isFetching = false
    
    private let dispatchGroup = DispatchGroup()
    private let dispatchQueue = DispatchQueue(label: "gitReposQueue", qos: .userInteractive)
    private let numberOfThreads = 2
    
    private var gitRepos: [GitRepo] = []
    private var previousLoadedGitRepos: [GitRepo] = []
    
    private let perPageCount = 15
    private let totalReposAvailableToLoad = 1000
    private let totalPages: Int!
    
    private var currentPage = 1 {
        willSet(page) {
            canFetch = (page <= totalPages)
            endpoint = GitHubReposEndpoint.search(query: currentName, page: page)
        }
    }
    private var currentName = "Swift"
    
//MARK: Init
    
    required init(loader: APIProtocol = GitHubAPI(),
         endpoint: EndpointProtocol = GitHubReposEndpoint.search(query: "Swift", page: 1)) {
        
        self.loader = loader
        self.endpoint = endpoint
        self.totalPages = self.totalReposAvailableToLoad / self.perPageCount
    }
    
//MARK: Public GitRepos Getters
    
    func getNewGitRepos(with name: String) {
        
        eraseAllData()
        
        currentName = name.isEmpty ? "Swift" : name
        endpoint = GitHubReposEndpoint.search(query: currentName, page: 1)
        fetchGitRepos()
    }
    
    func loadMoreGitRepos() {
        guard !isFetching else { return }
        isFetching = true
        
        endpoint = GitHubReposEndpoint.search(query: currentName, page: currentPage)
        fetchGitRepos()
    }
    
//MARK: Cell Constructor
    
    func getGitRepoCellViewModel(for indexPath: IndexPath) -> GitRepoCellViewModelProtocol? {

        if gitRepos.indices.contains(indexPath.row) {
            let gitRepo = gitRepos[indexPath.row]
            let gitRepoCellViewModel = GitReposCellViewModel(gitRepo: gitRepo)
            return gitRepoCellViewModel
        }
        return nil
    }
    
//MARK: Data Eraser
    
    private func eraseAllData() {
        gitRepos = []
        currentPage = 1
        canFetch = true
    }
}

//MARK: GitRepos Fetching

extension GitReposViewModel {
    
    func fetchGitRepos() {
        
        var caughtError: NetworkErrors?
        for _ in 1...numberOfThreads {
            
            guard canFetch else { return }
            
            showLoading?()
            dispatchGroup.enter()
            
            loader.request(to: endpoint) { [weak self] (result: Result<GitResponse, NetworkErrors>) in
                guard let self = self else { return }
                
                switch result {
                
                    case .success(let gitResponse):
                        
                        self.dispatchQueue.sync { [weak self] in
                            guard let self = self else { return }
                            
                            if self.previousLoadedGitRepos.last?.starsCount ?? 0 >=
                                gitResponse.gitRepos.first?.starsCount ?? 0 {
                                
                                self.gitRepos += gitResponse.gitRepos
                                
                            } else {
                                var lastLoadedStartIndex = self.gitRepos.endIndex - self.previousLoadedGitRepos.count
                                lastLoadedStartIndex = (lastLoadedStartIndex >= 0) ? lastLoadedStartIndex : 0
                                
                                self.gitRepos.insert(contentsOf: gitResponse.gitRepos, at: lastLoadedStartIndex)
                            }
                            self.previousLoadedGitRepos = gitResponse.gitRepos
                        }
                        
                    case .failure(let networkError):
                        caughtError = networkError
                }
                self.dispatchGroup.leave()
            }
            currentPage += 1
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            
            guard let self = self else { return }
            self.isFetching = false
            
            self.reloadData?()
            if caughtError != nil {
                self.showError?(caughtError!)
            }
        }
    }
}
