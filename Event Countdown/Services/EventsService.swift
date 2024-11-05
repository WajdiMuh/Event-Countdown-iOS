//
//  EventsService.swift
//  Event Countdown
//
//  Created by Wajdi Muhtadi on 04/07/2022.
//

import Foundation

final class EventsService : EventsServiceProtocol {
    let baseurl:String = "https://eventcountdown.ddnsfree.com"
    
    func getlatestevent() async throws -> Event? {
        guard let url = URL(string: baseurl + "/getlatestevent") else {
            throw LoadError.urlFailed
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode(Event.self, from: data)
            return decodedResponse
        } catch URLError.cancelled {
            throw LoadError.taskCancelled
        } catch is URLError {
            throw LoadError.fetchFailed
        } catch {
            throw LoadError.decodeFailed
        }
    }
    

    func getallevents() async throws -> [Event] {
        guard let url = URL(string: baseurl + "/getallevents") else {
            throw LoadError.urlFailed
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode([Event].self, from: data)
            return decodedResponse
        } catch URLError.cancelled {
            throw LoadError.taskCancelled
        } catch is URLError {
            throw LoadError.fetchFailed
        } catch {
            throw LoadError.decodeFailed
        }
    }

    func editevent(neweditedevent:Event) async throws -> [Event] {
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
            let decodedResponse = try JSONDecoder().decode([Event].self, from: data)
            return decodedResponse
        } catch URLError.cancelled {
            throw LoadError.taskCancelled
        } catch is URLError {
            throw LoadError.fetchFailed
        } catch {
            throw LoadError.decodeFailed
        }
    }

    func addevent(title:String, date:String) async throws -> [Event] {
        let neweventdata: [String: Any] = [
            "title": title,
            "date": date
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
            let decodedResponse = try JSONDecoder().decode([Event].self, from: data)
            return decodedResponse
        } catch URLError.cancelled {
            throw LoadError.taskCancelled
        } catch is URLError {
            throw LoadError.fetchFailed
        } catch {
            throw LoadError.decodeFailed
        }
    }

    func deleteevent(deletedevent:Event) async throws -> [Event] {
        guard let url = URL(string: baseurl + "/deleteevent/" + String(deletedevent.id)) else {
            throw LoadError.urlFailed
        }
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedResponse = try JSONDecoder().decode([Event].self, from: data)
            return decodedResponse
        } catch URLError.cancelled {
            throw LoadError.taskCancelled
        } catch is URLError {
            throw LoadError.fetchFailed
        } catch {
            throw LoadError.decodeFailed
        }
    }
    
}
