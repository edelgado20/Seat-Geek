//
//  EventViewModel.swift
//  SeatGeek
//
//  Created by Edgar Delgado on 2/2/21.
//

import Foundation

struct EventViewModel: Codable {
    
    let id: Int
    let name: String
    let location: String
    let date: String
    let imageUrl: String?
    var isFavorite: Bool
    
    // Dependency Injection (DI)
    init(event: Event) {
        self.id = event.id
        self.name = event.title
        self.location = event.venue.displayLocation
        self.date = event.datetimeUTC
        self.imageUrl = event.performers.first?.image
        self.isFavorite = false
    }
    
    // Converts UTC time to local time 
    func utcToLocal(convert dateString: String, to dateFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.timeZone = .current
            dateFormatter.dateFormat = dateFormat
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
}
