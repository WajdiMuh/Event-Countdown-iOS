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
}
