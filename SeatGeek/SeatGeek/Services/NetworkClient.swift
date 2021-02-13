//
//  NetworkClient.swift
//  SeatGeek
//
//  Created by Edgar Delgado on 1/22/21.
//

import Foundation

class NetworkClient {
    static let shared: NetworkClient = NetworkClient()
    
    let clientID = "&client_id=MjE1MTE5MDl8MTYxMTI4MTg5OC42MDgwMQ"
    let eventURL = "https://api.seatgeek.com/2/events?id="
    let eventsURL = "https://api.seatgeek.com/2/events?client_id=MjE1MTE5MDl8MTYxMTI4MTg5OC42MDgwMQ"
    let eventsQueryURL = "https://api.seatgeek.com/2/events?q="
    
    // Calls fetchEvents() and saves or retreives objects from UserDefaults
    func getEvents(completionHandler: @escaping ([EventViewModel]) -> Void) {
        fetchEvents { (eventsSummary) in
            var eventViewModels = eventsSummary.events.map({ return EventViewModel(event: $0)})
            
            for (index, element) in eventViewModels.enumerated() {
                let idString = String(element.id)
                let userDefaults = UserDefaults.standard
                
                do {
                    let eventViewModel = try userDefaults.getObject(forKey: idString, castTo: EventViewModel.self)
                    eventViewModels[index] = eventViewModel
                } catch { // If object doesn't exist, it saves it to UserDefaults
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
            completionHandler(eventViewModels)
        }
    }
    
    // Makes call to SeatGeek API to fetch the events
    func fetchEvents(completionHandler: @escaping (Events) -> Void) {
        guard let url = URL(string: eventsURL) else { fatalError("Incorrect URL")}
    
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching the events: \(error)")
            }
            
            guard let httpRespose = response as? HTTPURLResponse, (200...299).contains(httpRespose.statusCode) else {
                print("Error with the response, unexpected status code: \(response.debugDescription)")
                return
            }
            
            if let data = data, let eventsSummary = try? JSONDecoder().decode(Events.self, from: data) {
                completionHandler(eventsSummary)
            }
        }
        task.resume()
    }
    
    // TODO: Save fetched events to UserDefaults
    func fetchSearchEvents(searchText: String, completionHandler: @escaping (Events) -> Void) {
        guard let url = URL(string: eventsQueryURL+searchText+clientID) else { fatalError("Incorrect URL")}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching the query events: \(error)")
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(response.debugDescription)")
                return
            }
            
            if let data = data, let eventsSummary = try? JSONDecoder().decode(Events.self, from: data) {
                completionHandler(eventsSummary)
            }
        }
        task.resume()
    }
    
    // TODO: Dont forget to add it to user defaults
    func fetchEvent(id: String, completionHandler: @escaping (Events) -> Void) {
        guard let url = URL(string: eventURL+id+clientID) else { fatalError("Incorrect URL") }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching the event: \(error)")
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(response.debugDescription)")
                return
            }
            
            guard let data = data else {
                print("Error")
                return
            }
            
            let event = try! JSONDecoder().decode(Events.self, from: data)
            completionHandler(event)
        }
        task.resume()
    }
}
