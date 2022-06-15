//
//  Event.swift
//  Event Countdown
//
//  Created by Wajdi Muhtadi on 12/06/2022.
//

import Foundation

struct Event:Identifiable {
    var id: Int
    var title:String
    var date:Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case date
    }
    
}

extension Event: Decodable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        let datestring:String = try container.decode(String.self, forKey: .date)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let parseddate = dateFormatter.date(from: datestring) {
            date = parseddate
        }else{
            date = Date.now
        }
    }
}
