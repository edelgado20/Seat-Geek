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
    let networkClient = NetworkClient()
    var events: [Event] = [] {
        didSet {
            for event in events {
                print("Event type: \(event.type)")
            }
        }
    }
    var filteredEvents: [Event] = []
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationController?.navigationBar.prefersLargeTitles = true
        
        setupSearchController()
        networkClient.fetchEvents{ (eventsSummary) in
            self.events = eventsSummary.events
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
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? DetailViewController,
              let indexPath = tableView.indexPathForSelectedRow else { return }
        
        let event: Event
        if isFiltering {
            event = filteredEvents[indexPath.row]
        } else {
            event = events[indexPath.row]
        }
        detailVC.event = event
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
    
    func utcToLocal(dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.timeZone = .current
            dateFormatter.dateFormat = "E, dd MMM yyyy\nhh:mm a"
            return dateFormatter.string(from: date)
        }
        return nil
    }

}

extension MasterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredEvents.count
        }
        
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventTableViewCell else { fatalError("Unable to declare tableView cell")}
        
        let event: Event
        if isFiltering {
            event = filteredEvents[indexPath.row]
        } else {
            event = events[indexPath.row]
        }
        
        cell.heartImgView.isHidden = true
        cell.nameLabel.text = event.title
        cell.locationLabel.text = event.venue.displayLocation
        // TODO: implement utcToLocal on the ViewModel class and delete the static func
        cell.dateLabel.text = utcToLocal(dateString: event.datetimeUTC)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180.0
    }
}

extension MasterViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        filteredEvents = events.filter({ (event) -> Bool in
            return event.title.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
}
