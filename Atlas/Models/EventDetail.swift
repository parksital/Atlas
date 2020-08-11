//
//  EventDetails.swift
//  Atlas
//
//  Created by Parvin Sital on 12/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import MapKit


// MARK: - GetEvent
struct GetEvent: Decodable {
    let event: Event
    enum CodingKeys: String, CodingKey {
        case event = "getEvent"
    }
}

// MARK: - Event
struct Event {
    let id: String
    let title: String
    let startDate: Date
    let endDate: Date
    let venue: Venue
    let description: String?
    let artists: [Artist]
    
    struct Venue {
        let id: String
        let name: String
        let latitude: Double
        let longitude: Double
        let streetName: String
        let city: String
    }
    
    struct Artist {
        let id: String
        let artistName: String
        let firstName: String
        let lastName: String?
    }
}

extension Event: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case startDate = "start_date"
        case endDate = "end_date"
        case venue
        case description
        case artists = "bookings"
        
        enum BookingContainerKeys: String, CodingKey {
            case items
            
            enum ItemKeys: String, CodingKey {
                case artist
            }
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let bookingContainer = try container.nestedContainer(keyedBy: CodingKeys.BookingContainerKeys.self, forKey: .artists)

        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        startDate = try container.decode(Date.self, forKey: .startDate)
        endDate = try container.decode(Date.self, forKey: .endDate)
        venue = try container.decode(Event.Venue.self, forKey: .venue)
        description = try container.decode(String?.self, forKey: .description)
        
        var unkeyedItems = try bookingContainer.nestedUnkeyedContainer(forKey: .items)
        var decodedArtists: [Artist] = []
        while !unkeyedItems.isAtEnd {
            let booking = try unkeyedItems.nestedContainer(keyedBy: CodingKeys.BookingContainerKeys.ItemKeys.self)
            precondition(booking.contains(.artist))
            let artist = try booking.decode(Artist.self, forKey: .artist)
            decodedArtists.append(artist)
        }
        
        artists = decodedArtists
    }
}

extension Event.Artist: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case artistName = "artist_name"
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

extension Event.Venue: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case latitude
        case longitude
        case streetName = "street_name"
        case city
    }
}

enum EventDetail {
    struct Request: Fetchable, Mockable {
        var fileName: String? { return "eventByID" }
        var `extension`: String {return "json" }
        
        private var id: String
        var query: GetEventDetailsQuery { .init(id: id) }
        
        init(id: String) {
            self.id = id
        }
    }
    
    struct ViewModel {
        let id: String
        let title: String
        let startDate: String
        let venue: String
        let address: String
        let longitude: Double
        let latitude: Double
        let description: String?
        let artists: [String]
    }
}

extension EventDetail.ViewModel: Hashable { }
extension EventDetail.ViewModel {
    var location: CLLocation {
        CLLocation(
            latitude: latitude,
            longitude: longitude
        )
    }
}

extension EventDetail.ViewModel {
    static func fixture() -> EventDetail.ViewModel {
        EventDetail.ViewModel(
            id: UUID().uuidString,
            title: "fake event title",
            startDate: "january 25th 2021",
            venue: "souperclub.",
            address: "Singel 460, Amsterdam",
            longitude: 4.88883,
            latitude: 52.36755,
            description: "fake description",
            artists: []
        )
    }
}
