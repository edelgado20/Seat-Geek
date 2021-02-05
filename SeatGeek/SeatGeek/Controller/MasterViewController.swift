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
        
        print("viewDidLoad() MasterVC")
        // TODO: The fetching events call should not be in the ViewController instead in the NetworkClient struct
        networkClient.fetchEvents{ (eventsSumarry) in
            self.eventViewModels = eventsSumarry.events.map({ return EventViewModel(event: $0)})
            
            for (index, element) in self.eventViewModels.enumerated() {
                let idString = String(element.id)
                let userDefaults = UserDefaults.standard
                
                do {
                    let eventViewModel = try userDefaults.getObject(forKey: idString, castTo: EventViewModel.self)
                    print("->Retreive event: \(eventViewModel)")
                    self.eventViewModels[index] = eventViewModel
                } catch {
                    print(error.localizedDescription)
                    if error.localizedDescription == ObjectSavableError.noValue.rawValue {
                        print("->Setting event")
                        do {
                            try userDefaults.setObject(element, forKey: idString)
                            print("->Set ID: \(idString)")
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }

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
        
        print("->ViewWillAppear() MasterVC")
        for (index, element) in self.eventViewModels.enumerated() {
            let idString = String(element.id)
            let userDefaults = UserDefaults.standard
            
            do {
                let eventViewModel = try userDefaults.getObject(forKey: idString, castTo: EventViewModel.self)
                print("->Retreive event: \(eventViewModel)")
                self.eventViewModels[index] = eventViewModel
            } catch {
                print(error.localizedDescription)
                if error.localizedDescription == ObjectSavableError.noValue.rawValue {
                    print("->Setting event")
                    do {
                        try userDefaults.setObject(element, forKey: idString)
                        print("->Set ID: \(idString)")
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        
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
