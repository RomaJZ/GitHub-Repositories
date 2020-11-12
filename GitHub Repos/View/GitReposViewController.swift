//
//  ViewController.swift
//  GitHub Repos
//
//  Created by Roma Filipenko on 12.11.2020.
//

import UIKit

class GitReposViewController: UIViewController {
    
//MARK: IBOutlets
    
    @IBOutlet weak var loadingBlurView: UIVisualEffectView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var reposTableView: UITableView!
    
//MARK: Variables
    
    private let gitRepoCellId = String(describing: GitRepoCell.self)
    private var gitReposViewModel: GitReposViewModelProtocol!
    
    private var errorMessage: String?
    
//MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        loadingBlurView.isHidden = false
        reposTableView.register(UINib(nibName: gitRepoCellId, bundle: .main), forCellReuseIdentifier: gitRepoCellId)
        gitReposViewModel = GitReposViewModel()
        setupViewModel()
        gitReposViewModel?.getNewGitRepos(with: "")
    }
    
//MARK: ViewModel Setup
    
    private func setupViewModel() {
        
        gitReposViewModel?.showLoading = { [ weak self] in
            
            if self?.reposTableView.tableFooterView == nil {
                self?.reposTableView.tableFooterView = self?.footerLoaderView
            }
        }
        
        gitReposViewModel?.reloadData = { [ weak self] in
            self?.loadingBlurView.isHidden = true
            self?.reposTableView.tableFooterView = nil
            self?.reposTableView.reloadData()
        }
        
        gitReposViewModel?.showError = { [weak self] error in
            self?.errorMessage = (error as? NetworkErrors).map { $0.rawValue }
            self?.presentAlert()
        }
    }
}

//MARK: TableView DataSource

extension GitReposViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gitReposViewModel?.reposCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let gitRepoCell = tableView.dequeueReusableCell(withIdentifier: gitRepoCellId) as? GitRepoCell else { return UITableViewCell() }
        
        gitRepoCell.gitRepoCellViewModel = gitReposViewModel?.getGitRepoCellViewModel(for: indexPath)
        
        return gitRepoCell
    }
}

//MARK: SearchBar Delegate

extension GitReposViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        gitReposViewModel.getNewGitRepos(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

//MARK: Paging Delegate

extension GitReposViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if contentOffsetY > (contentHeight - scrollView.frame.height * 2) {
            gitReposViewModel.loadMoreGitRepos()
        }
    }
}

//MARK: Footer Loader View

extension GitReposViewController {
    
    var footerLoaderView: UIView {
        let footerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: reposTableView.bounds.width,
                                              height: reposTableView.sectionFooterHeight))
        
        let loaderView = UIActivityIndicatorView()
        loaderView.startAnimating()
        
        footerView.addSubview(loaderView)
        loaderView.center = footerView.center
        
        return footerView
    }
}

//MARK: Alert

extension GitReposViewController: AlertConstructor {
    
    var alertComponents: AlertComponents {
        
        let alertAction = AlertActionComponent(title: "OK")
        let alertComponents = AlertComponents(title: errorMessage, actions: [alertAction])
        
        return alertComponents
    }
}
