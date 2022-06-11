//
//  LikedAddViewController.swift
//  AudioNetwork
//
//  Created by OlegPrushlyak on 08.06.2022.
//

import UIKit
import CoreData

class LikedAddViewController: UIViewController, StoryboardInstantiable {
    var tasksArray: [TasksCore] = []
    var refreshContr: UIRefreshControl?
    
    @IBOutlet weak var tableV: UITableView!
    
    // MARK: - Properties
    static var storyboardFileName: UIStoryboard.Storyboard { .liked }
    var coordinator: LikedAddCoordinator?
    
    private var filteredArray = [TasksCore]()
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        let searchBarScopeFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty || searchBarScopeFiltering)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let appDeleg = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDeleg.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<TasksCore> = TasksCore.fetchRequest()
        do {
            tasksArray = try context.fetch(fetchRequest)
        } catch let error as NSError{
            print(error.localizedDescription)
        }
        tableV.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavButton()
        setupTable()
        addRefreshControl()
        createSearchAndScoreBar()
    }
    
    @IBAction private func trashAction(_ sender: Any) {
        guard let appDeleg = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDeleg.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<TasksCore> = TasksCore.fetchRequest()
        if let tasks = try? context.fetch(fetchRequest) {
            for task in tasks {
                context.delete(task)
            }
        }
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
        tableV.reloadData()
    }
}

extension LikedAddViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemForTransfer: TasksCore
        
        if isFiltering {
            itemForTransfer = filteredArray[indexPath.row]
        } else {
            itemForTransfer = tasksArray[indexPath.row]
        }
        coordinator?.pushSite(transfer: itemForTransfer)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredArray.count
        }
        return tasksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  let cell = tableView.cell(type: FindTableViewCell.self, indexPath: indexPath) {
            let item: TasksCore
            
            if isFiltering {
                item = filteredArray[indexPath.row]
            }else {
                item = tasksArray[indexPath.row]
            }
            
            cell.configureFromDataBase(item)
            
            return cell
        }
        return FindTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 139
    }
}

//MARK: - UISearchResultsUpdating
extension LikedAddViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope1 = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearch(searchController.searchBar.text!, scope: scope1)
    }
    
    private func filterContentForSearch(_ searchText: String, scope: String = "All") {
        
        filteredArray = tasksArray.filter({ (tasksArray: TasksCore) -> Bool in
            
            let doesCategoryMatch = (scope == "All") || (tasksArray.kindCore! == scope)
            
            if searchBarIsEmpty {
                return doesCategoryMatch
            }
            
            return doesCategoryMatch && (tasksArray.trackNameCore?.lowercased().contains(searchText.lowercased()) ?? false ||  tasksArray.artistNameCore?.lowercased().contains(searchText.lowercased()) ?? false)
        })
        
        tableV.reloadData()
    }
    
}

//MARK: - UISearchBar Delegate
extension LikedAddViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearch(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension LikedAddViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

private extension LikedAddViewController {
    func setupTable() {
        tableV.delegate = self
        tableV.dataSource = self
        tableV.register(cellType: FindTableViewCell.self)
    }
    
    func createNavButton() {
        guard let addImage = UIImage(systemName: "trash.circle") else { return }
        let addButton = UIBarButtonItem(image: addImage,  style: .plain, target: self, action: #selector(alertRemoveAll(sender:)))
        addButton.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        addButton.tintColor = .black
        navigationItem.rightBarButtonItems = [addButton]
        
        let titleLabel = UILabel()
        titleLabel.text = "Favorite"
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
    
    @objc func alertRemoveAll(sender: UIBarButtonItem) {
        // create the alert
        let alert = UIAlertController(title: "removal", message: "Are you sure you want to delete all saved?", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                DispatchQueue.main.async {
                    self.removeAll()
                }
            }
        alert.addAction(deleteAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Refresh
    func addRefreshControl() {
        refreshContr = UIRefreshControl()
        refreshContr?.tintColor = UIColor.red
        refreshContr?.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        tableV.addSubview(refreshContr!)
    }
    
    @objc func refreshAction() {
        tableV.reloadData()
        refreshContr?.endRefreshing()
    }
    
    func createSearchAndScoreBar() {
        // Setup searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        //Setup the Score Bar
        searchController.searchBar.scopeButtonTitles = ["All", "song", "feature-movie", "podcast"]
        let font = UIFont.systemFont(ofSize: 9)
        searchController.searchBar.setScopeBarButtonTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        searchController.searchBar.delegate = self
        
    }
    
    func removeAll() {
        guard let appDeleg = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDeleg.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<TasksCore> = TasksCore.fetchRequest()
        if let tasks = try? context.fetch(fetchRequest) {
            for task in tasks {
                context.delete(task)
            }
        }
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
        tableV.reloadData()
        coordinator?.popBack()
    }
}
