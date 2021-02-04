//
//  ViewController.swift
//  SeatGeek
//
//  Created by Edgar Delgado on 1/21/21.
//

import UIKit

class MasterViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    
    let searchController = UISearchController(searchResultsController: nil)
    let networkClient = NetworkClient()
    let navItem = UINavigationItem()
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
        addNavigationBar()
        setupSearchController()
        // TODO: The fetching events call should not be in the ViewContrller instead in the NetworkClient struct
        networkClient.fetchEvents{ (eventsSumarry) in
            self.eventViewModels = eventsSumarry.events.map({ return EventViewModel(event: $0)})
            
//            for (index, element) in self.eventViewModels.enumerated() {
//                let idString = String(element.id)
//                if let event = UserDefaults.standard.object(forKey: idString) as? EventViewModel {
//                    print("->Get Event: \(event)")
//                    self.eventViewModels[index] = event
//                } else {
//                    print("->Set ID: \(idString)")
//                    UserDefaults.standard.set(element, forKey: idString)
//                }
//            }
            
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
        
//        for (index, element) in self.eventViewModels.enumerated() {
//            let idString = String(element.id)
//            if let event = UserDefaults.standard.object(forKey: idString) as? EventViewModel {
//                print("->Get Event: \(event)")
//                self.eventViewModels[index] = event
//            } else {
//                print("->Set ID: \(idString)")
//                UserDefaults.standard.set(element, forKey: idString)
//            }
//        }
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
    
    func addNavigationBar() {
        let height: CGFloat = 100
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        tableViewTopConstraint.constant = height

        let navbar = UINavigationBar(frame: CGRect(x: 0, y: statusBarHeight, width: UIScreen.main.bounds.width, height: height))
        navbar.delegate = self as? UINavigationBarDelegate
        navbar.items = [navItem]
        
        view.addSubview(navbar)
        
        self.view.frame = CGRect(x: 0, y: height, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height - height))
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search events"
        searchController.searchBar.tintColor = .white // cancel button text color
        searchController.searchBar.barStyle = .black // text field text color
        searchController.searchBar.searchTextField.leftView?.tintColor = .white // search icon
        navItem.searchController = searchController
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
            return event.name.contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
}
