//
//  Event_CountdownTests.swift
//  Event CountdownTests
//
//  Created by Wajdi Muhtadi on 08/06/2022.
//

import XCTest
@testable import Event_Countdown

class Event_CountdownTests: XCTestCase {
    
    private var countdownviewmodel:CountdownViewModel!
    private var eventslistviewmodel:EventListViewModel!
    private var eventsservice:EventsServiceMock!
    
    override func setUp() {
        eventsservice = EventsServiceMock()
        countdownviewmodel = CountdownViewModel(eventsservice: eventsservice)
        eventslistviewmodel = EventListViewModel(eventsservice: eventsservice)
    }
    
    func testgetlatesteventnoevents() async throws{
        let e = expectation(description: "fetch latest event")
        try await countdownviewmodel.getlatestevent()
        e.fulfill()
        await waitForExpectations(timeout: 5)
        XCTAssertNil(countdownviewmodel.event)
    }
    
    func testaddevent() async throws{
        let e = expectation(description: "add event")
        try await eventslistviewmodel.addevent(title: "firstevent", date: Date(timeIntervalSince1970: 2022))
        try await countdownviewmodel.getlatestevent()
        e.fulfill()
        await waitForExpectations(timeout: 5)
        XCTAssertNotNil(countdownviewmodel.event)
        XCTAssert(countdownviewmodel.event?.title == "firstevent")
    }
    
    func testaddingnewerdate() async throws{
        let e = expectation(description: "add a newer event after and older one")
        try await eventslistviewmodel.addevent(title: "firstevent", date: Date(timeIntervalSince1970: 2022))
        try await eventslistviewmodel.addevent(title: "secondevent", date: Date(timeIntervalSince1970: 2028))
        try await countdownviewmodel.getlatestevent()
        e.fulfill()
        await waitForExpectations(timeout: 5)
        XCTAssertNotNil(countdownviewmodel.event)
        XCTAssert(countdownviewmodel.event?.title == "secondevent")
    }
    
    func testaddingolderdate() async throws{
        let e = expectation(description: "add an older event after adding a newer one")
        try await eventslistviewmodel.addevent(title: "firstevent", date: Date(timeIntervalSince1970: 2022))
        try await eventslistviewmodel.addevent(title: "secondevent", date: Date(timeIntervalSince1970: 2020))
        try await countdownviewmodel.getlatestevent()
        e.fulfill()
        await waitForExpectations(timeout: 5)
        XCTAssertNotNil(countdownviewmodel.event)
        XCTAssert(countdownviewmodel.event?.title == "firstevent")
    }
    
    func testremovingevent() async throws{
        let addexp = expectation(description: "event added")
        try await eventslistviewmodel.addevent(title: "firstevent", date: Date(timeIntervalSince1970: 2022))
        try await countdownviewmodel.getlatestevent()
        addexp.fulfill()
        await waitForExpectations(timeout: 5)
        XCTAssertNotNil(countdownviewmodel.event)
        let removeexp = expectation(description: "event removed")
        try await eventslistviewmodel.deleteevent(deletedevent: Event(id: 0, title: "firstevent", date: Date(timeIntervalSince1970: 2022)))
        try await countdownviewmodel.getlatestevent()
        removeexp.fulfill()
        await waitForExpectations(timeout: 5)
        XCTAssertNil(countdownviewmodel.event)
    }
    
    func testeditevent() async throws{
        let addexp = expectation(description: "event added")
        try await eventslistviewmodel.addevent(title: "firstevent", date: Date(timeIntervalSince1970: 2022))
        try await countdownviewmodel.getlatestevent()
        addexp.fulfill()
        await waitForExpectations(timeout: 5)
        XCTAssertNotNil(countdownviewmodel.event)
        XCTAssert(countdownviewmodel.event?.title == "firstevent")
        let editexp = expectation(description: "event edited")
        try await eventslistviewmodel.editevent(neweditedevent: Event(id: 0, title: "secondevent", date: Date(timeIntervalSince1970: 2022)))
        try await countdownviewmodel.getlatestevent()
        editexp.fulfill()
        await waitForExpectations(timeout: 5)
        XCTAssertNotNil(countdownviewmodel.event)
        XCTAssert(countdownviewmodel.event?.title == "secondevent")
    }
    

}
