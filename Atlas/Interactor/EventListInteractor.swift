//
//  EventListInteractor.swift
//  Atlas
//
//  Created by Parvin Sital on 22/02/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

protocol EventListInteraction {
    func fetchEvents()
}

final class EventListInteractor {
    private let presenter: EventListPresentation!
    private let eventService: EventFetching!
    
    init(presenter: EventListPresentation, eventService: EventFetching) {
        self.presenter = presenter
        self.eventService = eventService
    }
}

extension EventListInteractor: EventListInteraction {
    func fetchEvents() {
        // eventservice.getEvents
    }
}
