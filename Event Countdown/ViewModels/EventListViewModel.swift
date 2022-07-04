//
//  EventListViewModel.swift
//  Event Countdown
//
//  Created by Wajdi Muhtadi on 14/06/2022.
//

import SwiftUI
import Foundation
class EventListViewModel: ObservableObject{
    @Published var events:[Event] = []
    private let eventsservice:EventsServiceProtocol
    
    init(eventsservice:EventsServiceProtocol = EventsService()){
        self.eventsservice = eventsservice
    }
    
    func getallevents() async throws {
        do{
            let events:[Event] =  try await eventsservice.getallevents()
            DispatchQueue.main.async(){
                self.events = events
            }
        }catch{
            throw error
        }
    }
    
    func editevent(neweditedevent:Event) async throws {
        do{
            let events:[Event] =  try await eventsservice.editevent(neweditedevent: neweditedevent)
            DispatchQueue.main.async(){
                self.events = events
            }
        }catch{
            throw error
        }
    }
    
    func addevent(title:String, date:Date) async throws {
        do{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
            let events:[Event] =  try await eventsservice.addevent(title: title, date: dateFormatter.string(from: date))
            DispatchQueue.main.async(){
                self.events = events
            }
        }catch{
            throw error
        }
    }
    
    func deleteevent(deletedevent:Event) async throws {
        do{
            let events:[Event] =  try await eventsservice.deleteevent(deletedevent: deletedevent)
            DispatchQueue.main.async(){
                self.events = events
            }
        }catch{
            throw error
        }
    }
}
