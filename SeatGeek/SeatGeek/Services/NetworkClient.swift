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
    
    // Makes call to SeatGeek API to fetch the events
    func fetchEvents(completionHandler: @escaping ([EventViewModel]) -> Void) {
        guard let url = URL(string: eventsURL) else { fatalError("Incorrect URL")}
    
        let task = URLSession.shared.dataTask(with: url) { [self] (data, response, error) in
            if let error = error {
                print("Error fetching the events: \(error)")
            }
            
            guard let httpRespose = response as? HTTPURLResponse, (200...299).contains(httpRespose.statusCode) else {
                print("Error with the response, unexpected status code: \(response.debugDescription)")
                return
            }
            
            if let data = data, let eventsSummary = try? JSONDecoder().decode(Events.self, from: data) {
                // Convert events to eventsViewModels and retrieves or saves objects from UserDefaults
                var eventViewModels = eventsSummary.events.map({ return EventViewModel(event: $0) })
                getOrSetObjectsOnUserDefaults(viewModels: &eventViewModels)
                completionHandler(eventViewModels)
            }
        }
        task.resume()
    }
    
    // API call to search for events with custom search text from user
    func fetchSearchEvents(searchText: String, completionHandler: @escaping ([EventViewModel]) -> Void) {
        guard let url = URL(string: eventsQueryURL+searchText+clientID) else { fatalError("Incorrect URL")}
        
        let task = URLSession.shared.dataTask(with: url) { [self] (data, response, error) in
            if let error = error {
                print("Error fetching the query events: \(error)")
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(response.debugDescription)")
                return
            }
            
            if let data = data, let eventsSummary = try? JSONDecoder().decode(Events.self, from: data) {
                // Convert events to eventsViewModels and retrieves or saves objects from UserDefaults
                var eventViewModels = eventsSummary.events.map({ return EventViewModel(event: $0) })
                getOrSetObjectsOnUserDefaults(viewModels: &eventViewModels)
                completionHandler(eventViewModels)
            }
        }
        task.resume()
    }
    
    // API call for a individual event
    func fetchEvent(id: String, completionHandler: @escaping (EventViewModel) -> Void) {
        guard let url = URL(string: eventURL+id+clientID) else { fatalError("Incorrect URL") }
        
        let task = URLSession.shared.dataTask(with: url) { [self] (data, response, error) in
            if let error = error {
                print("Error fetching the event: \(error)")
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(response.debugDescription)")
                return
            }
            
            if let data = data, let eventsSummary = try? JSONDecoder().decode(Events.self, from: data) {
                // Convert to event to eventViewModel and check if object already exist in UserDefaults
                if let event = eventsSummary.events.first {
                    var eventViewModel = EventViewModel(event: event)
                    getOrSetObjectOnUserDefaults(viewModel: &eventViewModel)
                    completionHandler(eventViewModel)
                }
            }
            
        }
        task.resume()
    }
    
    // Retreives or Sets the object on UserDefaults
    func getOrSetObjectOnUserDefaults(viewModel: inout EventViewModel) {
        let idString = String(viewModel.id)
        let userDefaults = UserDefaults.standard
        
        do {
            let eventViewModelFromUserDefaults = try userDefaults.getObject(forKey: idString, castTo: EventViewModel.self)
            viewModel = eventViewModelFromUserDefaults
        } catch {
            if error.localizedDescription == ObjectSavableError.noValue.rawValue {
                do {
                    try userDefaults.setObject(viewModel, forKey: idString)
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print(error.localizedDescription)
            }
        }
    }
    
    // Retrieves or Saves the objects on UserDefaults
    func getOrSetObjectsOnUserDefaults(viewModels: inout [EventViewModel]) {
        for (index, element) in viewModels.enumerated() {
            let idString = String(element.id)
            let userDefaults = UserDefaults.standard
            
            do {
                let viewModel = try userDefaults.getObject(forKey: idString, castTo: EventViewModel.self)
                viewModels[index] = viewModel
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
