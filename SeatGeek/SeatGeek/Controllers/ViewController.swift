//
//  ViewController.swift
//  SeatGeek
//
//  Created by Edgar Delgado on 1/21/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let networkClient = NetworkClient()
    var events: [Event] = [] {
        didSet {
            for event in events {
                print("Event type: \(event.type)")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
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
            
            print("-> \(dateFormatter.string(from: date))")
            return dateFormatter.string(from: date)
        } else {
            print("else")
        }
   
        return nil
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("->Events Count: \(events.count)")
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventTableViewCell else { fatalError("Unable to declare tableView cell")}
        
        cell.heartImgView.isHidden = true
        cell.nameLabel.text = events[indexPath.row].title
        cell.locationLabel.text = events[indexPath.row].venue.displayLocation
        cell.dateLabel.text = utcToLocal(dateString: events[indexPath.row].datetimeUTC)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180.0
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
    }
}
