//
//  EventsServiceProtocol.swift
//  Event Countdown
//
//  Created by Wajdi Muhtadi on 04/07/2022.
//

import Foundation

protocol EventsServiceProtocol {
    func getlatestevent() async throws -> Event?
    func getallevents() async throws -> [Event]
    func editevent(neweditedevent:Event) async throws -> [Event]
    func addevent(title:String, date:String) async throws -> [Event]
    func deleteevent(deletedevent:Event) async throws -> [Event]
}
