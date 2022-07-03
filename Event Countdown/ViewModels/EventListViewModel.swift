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
    func getallevents() async throws {
        guard let url = URL(string: baseurl + "/getallevents") else {
            throw LoadError.urlFailed
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode([Event].self, from: data) {
                DispatchQueue.main.async{
                    self.events = decodedResponse
                }
            }else{
                throw LoadError.decodeFailed
            }
        } catch {
            if let error = error as? URLError {
                if error.code == .cancelled{
                    throw LoadError.taskCancelled
                }else{
                    throw LoadError.fetchFailed
                }
            }
        }
    }
    
    func editevent(neweditedevent:Event) async throws {
        guard let url = URL(string: baseurl + "/editevent/" + String(neweditedevent.id)) else {
            throw LoadError.urlFailed
        }
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            let editeventjson:Data? = try? JSONEncoder().encode(neweditedevent)
            request.httpBody = editeventjson
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let (data, _) = try await URLSession.shared.data(for: request)
            if let decodedResponse = try? JSONDecoder().decode([Event].self, from: data) {
                DispatchQueue.main.async{
                    self.events = decodedResponse
                }
            }else{
                throw LoadError.decodeFailed
            }
        } catch {
            if let error = error as? URLError {
                if error.code == .cancelled{
                    throw LoadError.taskCancelled
                }else{
                    throw LoadError.fetchFailed
                }
            }
        }
    }
    
    func addevent(title:String, date:Date) async throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        let neweventdata: [String: Any] = [
            "title": title,
            "date": dateFormatter.string(from: date)
        ]
        guard let url = URL(string: baseurl + "/addevent") else {
            throw LoadError.urlFailed
        }
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let neweventjson:Data? = try? JSONSerialization.data(withJSONObject: neweventdata, options: [])
            request.httpBody = neweventjson
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let (data, _) = try await URLSession.shared.data(for: request)
            if let decodedResponse = try? JSONDecoder().decode([Event].self, from: data) {
                DispatchQueue.main.async{
                    self.events = decodedResponse
                }
            }else{
                throw LoadError.decodeFailed
            }
        } catch {
            if let error = error as? URLError {
                if error.code == .cancelled{
                    throw LoadError.taskCancelled
                }else{
                    throw LoadError.fetchFailed
                }
            }
        }
    }
    
    func deleteevent(deletedevent:Event) async throws {
        guard let url = URL(string: baseurl + "/deleteevent/" + String(deletedevent.id)) else {
            throw LoadError.urlFailed
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
                throw LoadError.decodeFailed
            }
        } catch {
            if let error = error as? URLError {
                if error.code == .cancelled{
                    throw LoadError.taskCancelled
                }else{
                    throw LoadError.fetchFailed
                }
            }
        }
    }
}
