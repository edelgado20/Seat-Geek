//
//  ViewController.swift
//  SeatGeek
//
//  Created by Edgar Delgado on 1/21/21.
//

import UIKit

class MasterViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var eventViewModels: [EventViewModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var searchedEventViewModels: [EventViewModel] = [] { // events that are searched from the search bar
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isSearching: Bool { // Tells us if user has typed on the search bar
        return searchController.isActive && !isSearchBarEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        NetworkClient.shared.fetchEvents { [self] (eventViewModels) in
            self.eventViewModels = eventViewModels
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
        
        let id: String
        if isSearching {
            id = String(searchedEventViewModels[indexPath.row].id)
        } else {
            id = String(eventViewModels[indexPath.row].id)
        }
        detailVC.id = id
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
    }
}

extension MasterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchedEventViewModels.count
        }
        return eventViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventTableViewCell else { fatalError("Unable to declare tableView cell")}
        // Choses the event from the appropriate array
        let eventViewModel: EventViewModel
        if isSearching {
            eventViewModel = searchedEventViewModels[indexPath.row]
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
        // Calls the fetchSearchEvents API with the search text. The tableView will get reloaded when the searchedEventViewModels gets set.
        NetworkClient.shared.fetchSearchEvents(searchText: searchText) { [self] (eventViewModels) in
            searchedEventViewModels = eventViewModels
        }
    }
}
