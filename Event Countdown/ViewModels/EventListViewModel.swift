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
//        guard let url = URL(string: baseurl + "/addevent/") else {
//            print("Invalid URL")
//            return
//        }
//        do {
//            let (data, _) = try await URLSession.shared.data(from: url)
//            if let decodedResponse = try? JSONDecoder().decode([Event].self, from: data) {
//                DispatchQueue.main.async{
//                    self.events = decodedResponse
//                }
//            }else{
//                print("decode failed")
//            }
//        } catch {
//            print("Invalid data")
//        }
    }
    
    func deleteevent(deletedevent:Event) async{
        guard let url = URL(string: baseurl + "/deleteevent/" + String(deletedevent.id)) else {
            print("Invalid URL")
            return
        }
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            let (data, _) = try await URLSession.shared.data(for: request)
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
}
