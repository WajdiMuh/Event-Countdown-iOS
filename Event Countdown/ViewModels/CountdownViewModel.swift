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
    let baseurl:String = "https://eventcountdown.herokuapp.com"
    
    func getlatestevent() async {
        guard let url = URL(string: baseurl + "/getlatestevent") else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode(Event.self, from: data) {
                DispatchQueue.main.async{
                    self.event = decodedResponse
                }
            }else{
                print("decode failed")
            }
        } catch {
            print("Invalid data")
        }
    }
}
