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
    let baseurl:String = "https://eventcountdown.herokuapp.com"
    
    func getlatestevent() async throws {
        guard let url = URL(string: baseurl + "/getlatestevent") else {
            throw LoadError.urlFailed
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode(Event.self, from: data) {
                DispatchQueue.main.async{
                    self.event = decodedResponse
                    self.receivedevent = nil
                }
            }else{
                throw LoadError.decodeFailed
            }
        } catch {
            throw LoadError.fetchFailed
        }
    }
    
    func calculatetimediff(){
        difference = Calendar.current.dateComponents([.year,.month,.day,.hour, .minute,.second], from: Date.now, to: event?.date ?? Date.now)
    }
}
