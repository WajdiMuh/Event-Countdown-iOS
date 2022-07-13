//
//  EventsServiceMock.swift
//  Event CountdownTests
//
//  Created by Wajdi Muhtadi on 04/07/2022.
//

import Foundation
@testable import Event_Countdown

class EventsServiceMock : EventsServiceProtocol {
    
    private var events:[Event] = []
    private var eventid = 0
    
    func getlatestevent() async throws -> Event? {
        return events.first
    }
    

    func getallevents() async throws -> [Event] {
        return events
    }

    func editevent(neweditedevent:Event) async throws -> [Event] {
        var idx:Int = -1
        for (curidx,event) in events.enumerated(){
            if(event.id == neweditedevent.id){
                idx = curidx
            }
        }
        events[idx] = Event(id: neweditedevent.id, title: neweditedevent.title, date: neweditedevent.date)
        return events
    }

    func addevent(title:String, date:String) async throws -> [Event] {
        let neweventdata: [String: Any] = [
            "id": eventid,
            "title": title,
            "date": date
        ]
        let neweventjson:Data? = try? JSONSerialization.data(withJSONObject: neweventdata, options: [])
        let decoded = try JSONDecoder().decode(Event.self, from: neweventjson!)
        var idx:Int = events.count
        for (curidx,event) in events.enumerated(){
            if(decoded.date.compare(event.date).rawValue > 0){
                idx = curidx
            }
        }
        events.insert(decoded, at: idx)
        eventid += 1
        return events
    }

    func deleteevent(deletedevent:Event) async throws -> [Event] {
        var idx:Int = -1
        for (curidx,event) in events.enumerated(){
            if(event.id == deletedevent.id){
                idx = curidx
            }
        }
        events.remove(at: idx)
        return events
    }
    
}

