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
    let baseurl:String = "https://eventcountdown.herokuapp.com"
    func getallevents() async {
        guard let url = URL(string: baseurl + "/getallevents") else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode([Event].self, from: data) {
                DispatchQueue.main.async{
                    self.events = decodedResponse
                }
            }else{
                print("decode failed")
            }
        } catch {
            print("Invalid data")
        }
    }
    
    func editevent(neweditedevent:Event){
        if let eventidx = events.firstIndex(where: {$0.id == neweditedevent.id }) {
            events[eventidx] = neweditedevent
        }
    }
    
    func addevent(title:String, date:Date){
        events.append(Event(id: UUID.init().hashValue, title: title, date: date))
    }
    
    func deleteevent(deletedevent:Event){
        if let eventidx = events.firstIndex(where: {$0.id == deletedevent.id }) {
            events.remove(at: eventidx)
        }
    }
}
