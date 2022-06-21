//
//  MainViewViewModel.swift
//  Event Countdown
//
//  Created by Wajdi Muhtadi on 17/06/2022.
//

import SwiftUI
import Foundation
class MainViewViewModel: ObservableObject{
    @Published var menuvisible:Bool = false
    @Published var loading:Bool = true
    @Published var chosenmenu:String = "countdown"
    @Published var showtoast:Bool = false
    @Published var toastmessege:String = ""
    
    func latesteventfetchfailed(){
        toastmessege = "Failed to fetch latest event"
        showtoast.toggle()
    }
    
    func eventsfetchfailed(){
        toastmessege = "Failed to fetch events"
        showtoast.toggle()
    }
}
