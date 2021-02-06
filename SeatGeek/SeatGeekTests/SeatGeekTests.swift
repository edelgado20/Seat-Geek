//
//  SeatGeekTests.swift
//  SeatGeekTests
//
//  Created by Edgar Delgado on 1/21/21.
//

import XCTest
@testable import SeatGeek

class SeatGeekTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testEventViewModel() {
        let event = Event(name: "Los Angeles Dodgers vs New York Yankees",
                          location: "Los Angeles, CA", date: "2021-02-03T00:00:00",
                          performers: [Performer(image: "https://seatgeek.com/images/performers-landscape/woga-classic-liukin-international-competitions-11829e/792937/huge.jpg")])
        let eventViewModel = EventViewModel(event: event)
        
        XCTAssertEqual(event.title, eventViewModel.name)
        XCTAssertEqual(event.venue.displayLocation, eventViewModel.location)
        XCTAssertEqual(event.datetimeUTC, eventViewModel.date)
        XCTAssertEqual(event.performers[0].image, eventViewModel.imageUrl)
    }
    
    func testDateFormat() {
        let event = Event(name: "Los Angeles Dodgers vs New York Yankees",
                          location: "Los Angeles, CA", date: "2021-02-03T00:00:00",
                          performers: [Performer(image: "https://seatgeek.com/images/performers-landscape/woga-classic-liukin-international-competitions-11829e/792937/huge.jpg")])
        let eventViewModel = EventViewModel(event: event)
        let date = eventViewModel.utcToLocal(convert: event.datetimeUTC, to: "EEEE, dd MMM yyyy hh:mm a")
        
        XCTAssertEqual(date, "Tuesday, 02 Feb 2021 04:00 PM")
    }
}
