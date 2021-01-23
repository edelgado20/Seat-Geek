//
//  ViewController.swift
//  SeatGeek
//
//  Created by Edgar Delgado on 1/21/21.
//

import UIKit

class ViewController: UIViewController {
    
    let apiURL = "https://api.seatgeek.com/2/events?client_id=MjE1MTE5MDl8MTYxMTI4MTg5OC42MDgwMQ"
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
        
        fetchEvents { (eventsSummary) in
            self.events = eventsSummary.events
        }
    }
    
    func fetchEvents(completionHandler: @escaping (Events) -> Void) {
        let url = URL(string: apiURL)!

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching the events: \(error)")
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
                return
            }

            if let data = data {
                let eventsSummary = try! JSONDecoder().decode(Events.self, from: data) //{
                completionHandler(eventsSummary)
                    //print("->Events: \(eventsSummary)")
//                } else {
//                    print("Wasnt able to decode the events")
//                }
            }
        }
        task.resume()
    }

    

}

