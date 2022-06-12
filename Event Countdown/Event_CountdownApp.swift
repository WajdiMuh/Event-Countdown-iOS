//
//  Event_CountdownApp.swift
//  Event Countdown
//
//  Created by Wajdi Muhtadi on 08/06/2022.
//

import SwiftUI


@main
struct Event_CountdownApp: App {
    init() {
       UITableView.appearance().showsVerticalScrollIndicator = false
    }
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
