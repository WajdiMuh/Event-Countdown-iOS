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
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        if let parseddate = dateFormatter.date(from: datestring) {
            date = parseddate
        }else{
            date = Date.now
        }
    }
}

extension Event: Encodable {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        try container.encode(dateFormatter.string(from: date), forKey: .date)
    }
    
}
