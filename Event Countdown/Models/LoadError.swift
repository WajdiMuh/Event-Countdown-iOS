//
//  LoadError.swift
//  Event Countdown
//
//  Created by Wajdi Muhtadi on 22/06/2022.
//

import Foundation

enum LoadError: Error {
    case fetchFailed, decodeFailed,urlFailed,taskCancelled
}
