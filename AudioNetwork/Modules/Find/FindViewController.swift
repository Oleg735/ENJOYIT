//
//  FindViewController.swift
//  AudioNetwork
//
//  Created by OlegPrushlyak on 27.07.2021.
//

import UIKit

class FindViewController: UIViewController, StoryboardInstantiable {
    // MARK: - @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var label: UILabel!
    
    // MARK: - Properties
    static var storyboardFileName: UIStoryboard.Storyboard { .find }
    var coordinator: FindCoordinator?

    var itemArray = [SearchResponse]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var refreshContr: UIRefreshControl?
    private var timer: Timer?
    private var limitCount = 10
    private var total = 200
    private var search: String = ""
    private var baseURLSearch: String!
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    private let networkManag = NetworkManager()
    private var searchResponse: SearchResponse? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavButton()
        responseFunc(search: "jack+johnson", limit: limitCount)
        
        setupTableView()
        setupSearchBar()
        addRefreshControl()
        configureLabel()
    }
}

// MARK: - Table view data source
extension FindViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResponse?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if limitCount < total && indexPath.row == (searchResponse?.results.count)! - 1 {
            guard let cell = tableView.cell(type: SpinnerTableViewCell.self, indexPath: indexPath) else { return UITableViewCell() }
            return cell
        } else  {
            guard let cell = tableView.cell(type: FindTableViewCell.self, indexPath: indexPath) else { return UITableViewCell() }
            guard let track = searchResponse?.results[indexPath.row] else { return UITableViewCell() }
            cell.configure(track)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isFiltering {
            if self.limitCount < self.total && indexPath.row == (self.searchResponse?.results.count)! - 1 {
                self.limitCount = self.limitCount + 10
                self.responseFunc(search: search, limit: limitCount)
            }
        } else {
            if self.limitCount < self.total && indexPath.row == (self.searchResponse?.results.count)! - 1 {
                self.limitCount = self.limitCount + 10
                responseFunc(search: "jack+johnson", limit: limitCount)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 139
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menu = searchResponse?.results[indexPath.row] else { return }
        coordinator?.pushSite(transfer: menu)
    }
    
}

extension FindViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        limitCount = 10
        let baseURL1 = "https://itunes.apple.com/search?term=\(searchText)&limit=200"
        search = searchText
        
        self.networkManag.getAllPosts(urlString: baseURL1) { [weak self] (result) in
            switch result {
            case .success(let searchResponse):
                self?.total = searchResponse.resultCount
                print((self?.total)!)
                //self?.searchResponse = searchResponse
                self?.tableView.reloadData()
            case .failure(let error):
                print("error:", error)
            }
        }
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.responseFunc(search: self.search, limit: self.limitCount)
            if self.total == 0 {
                self.label.alpha = 1
            } else {
                self.label.alpha = 0
            }
        })
    }
}

private extension FindViewController {
    func createNavButton() {
        guard let addImage = UIImage(systemName: "heart.fill") else { return }
        
        let addButton = UIBarButtonItem(image: addImage,  style: .plain, target: self, action: #selector(likedScreen(sender:)))
        addButton.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        addButton.tintColor = .black
        navigationItem.rightBarButtonItems = [addButton]
        
        let titleLabel = UILabel()
        titleLabel.text = "FINDIT"
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "Marker Felt Thin", size: 17)
        navigationItem.titleView = titleLabel
        
        let button =  UIButton(type: .custom)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(back(sender:)), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 20)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    @objc func back(sender: UIBarButtonItem) {
        coordinator?.popBack()
    }
    
    @objc func likedScreen(sender: UIBarButtonItem) {
        coordinator?.pushSLiked()
    }
    
    func responseFunc( search: String, limit: Int) {
        let baseURL = "https://itunes.apple.com/search?term=\(search)&limit=\(limit)"
        self.networkManag.getAllPosts(urlString: baseURL) { [weak self] (result) in
            switch result {
            case .success(let searchResponse):
                self?.searchResponse = searchResponse
                self?.tableView.reloadData()
            case .failure(let error):
                print("error:", error)
            }
        }
    }
    
    func addRefreshControl() {
        refreshContr = UIRefreshControl()
        refreshContr?.tintColor = UIColor.red
        refreshContr?.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        tableView.addSubview(refreshContr!)
    }
    
    @objc func refreshAction() {
        if isFiltering {
            limitCount = 10
            responseFunc(search: search, limit: limitCount)
            tableView.reloadData()
            refreshContr?.endRefreshing()
            label.alpha = 0
        } else {
            limitCount = 10
            responseFunc(search: "jack+johnson", limit: limitCount)
            tableView.reloadData()
            refreshContr?.endRefreshing()
            label.alpha = 0
        }
    }
    
    func configureLabel() {
        label.alpha = 0
        label.text = "No item match your query"
    }
    
    func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: FindTableViewCell.self)
        tableView.register(cellType: SpinnerTableViewCell.self)
    }
}
