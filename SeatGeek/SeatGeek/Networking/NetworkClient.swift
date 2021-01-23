//
//  NetworkClient.swift
//  SeatGeek
//
//  Created by Edgar Delgado on 1/22/21.
//

import Foundation

struct NetworkClient {
    
    let eventsURL = "https://api.seatgeek.com/2/events?client_id=MjE1MTE5MDl8MTYxMTI4MTg5OC42MDgwMQ"
    
    func fetchEvents(completionHandler: @escaping (Events) -> Void) {
        guard let url = URL(string: eventsURL) else { fatalError("Incorrect URL")}
    
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching the events: \(error)")
            }
            
            if let httpRespose = response as? HTTPURLResponse, (200...299).contains(httpRespose.statusCode) {
                print("Error with the response, unexpected status code: \(httpRespose.statusCode)")
            }
            
            if let data = data, let eventsSummary = try? JSONDecoder().decode(Events.self, from: data) {
                completionHandler(eventsSummary)
            }
        }
        task.resume()
    }
}
