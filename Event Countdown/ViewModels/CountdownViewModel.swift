//
//  CountdownViewModel.swift
//  Event Countdown
//
//  Created by Wajdi Muhtadi on 16/06/2022.
//

import SwiftUI
import Foundation
class CountdownViewModel: ObservableObject{
    @Published var event:Event? = nil
    @Published var receivedevent:Event? = nil
    @Published var difference:DateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour, .minute,.second], from: Date.now, to: Date.now)
    private let eventsservice:EventsServiceProtocol
    
    init(eventsservice:EventsServiceProtocol = EventsService()){
        self.eventsservice = eventsservice
    }
    
    func getlatestevent() async throws {
        do{
            let latestevent:Event? =  try await eventsservice.getlatestevent()
            DispatchQueue.main.async(){
                self.event = latestevent
                self.receivedevent = nil
            }
        }catch{
            throw error
        }
    }
    
    func calculatetimediff(){
        difference = Calendar.current.dateComponents([.year,.month,.day,.hour, .minute,.second], from: Date.now, to: event?.date ?? Date.now)
    }
}
