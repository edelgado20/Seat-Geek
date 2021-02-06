//
//  NetworkClient.swift
//  SeatGeek
//
//  Created by Edgar Delgado on 1/22/21.
//

import Foundation

struct NetworkClient {
    
    let eventsURL = "https://api.seatgeek.com/2/events?client_id=MjE1MTE5MDl8MTYxMTI4MTg5OC42MDgwMQ"
    
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
}
