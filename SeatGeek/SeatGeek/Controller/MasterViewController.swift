//
//  ViewController.swift
//  SeatGeek
//
//  Created by Edgar Delgado on 1/21/21.
//

import UIKit

class MasterViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let navItem = UINavigationItem()
    let searchController = UISearchController(searchResultsController: nil)
    let networkClient = NetworkClient()
    var eventViewModels: [EventViewModel] = []
    var filteredEventViewModels: [EventViewModel] = []
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        
        networkClient.getEvents { [self] (eventViewModels) in
            self.eventViewModels = eventViewModels
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let index = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: index, animated: true)
        }
        getObjectsFromUserDefaults()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? DetailViewController,
              let indexPath = tableView.indexPathForSelectedRow else { return }
        
        let eventViewModel: EventViewModel
        if isFiltering {
            eventViewModel = filteredEventViewModels[indexPath.row]
        } else {
            eventViewModel = eventViewModels[indexPath.row]
        }
        detailVC.eventViewModel = eventViewModel
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search events"
        searchController.searchBar.tintColor = .white // cancel button text color
        searchController.searchBar.barStyle = .black // text field text color
        searchController.searchBar.searchTextField.leftView?.tintColor = .white // search icon
        navigationItem.searchController = searchController
    }
    
    func getObjectsFromUserDefaults() {
        for (index, element) in self.eventViewModels.enumerated() {
            let idString = String(element.id)
            let userDefaults = UserDefaults.standard
            
            do {
                let eventViewModel = try userDefaults.getObject(forKey: idString, castTo: EventViewModel.self)
                self.eventViewModels[index] = eventViewModel
            } catch {
                if error.localizedDescription == ObjectSavableError.noValue.rawValue {
                    do {
                        try userDefaults.setObject(element, forKey: idString)
                    } catch {
                        print(error.localizedDescription)
                    }
                } else {
                    print(error.localizedDescription)
                }
            }
        }
        tableView.reloadData()
    }
}

extension MasterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredEventViewModels.count
        }
        return eventViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventTableViewCell else { fatalError("Unable to declare tableView cell")}
        
        let eventViewModel: EventViewModel
        if isFiltering {
            eventViewModel = filteredEventViewModels[indexPath.row]
        } else {
            eventViewModel = eventViewModels[indexPath.row]
        }
        cell.eventViewModel = eventViewModel
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180.0
    }
}

extension MasterViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        filteredEventViewModels = eventViewModels.filter({ (event) -> Bool in
            return event.name.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
}
