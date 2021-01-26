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
        view.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        
        networkClient.fetchEvents{ (eventsSummary) in
            self.events = eventsSummary.events
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
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
        
        cell.nameLabel.text = events[indexPath.row].title
        cell.locationLabel.text = events[indexPath.row].venue.displayLocation
        cell.dateLabel.text = utcToLocal(dateString: events[indexPath.row].datetimeUTC)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180.0
    }
}

