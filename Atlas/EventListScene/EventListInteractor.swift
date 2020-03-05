//
//  EventListInteractor.swift
//  Atlas
//
//  Created by Parvin Sital on 22/02/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

final class EventListInteractor {
    private let presenter: EventListPresentationProtocol!
    private let eventService: EventFetchingProtocol!
    
    init(presenter: EventListPresentationProtocol, eventService: EventFetchingProtocol) {
        self.presenter = presenter
        self.eventService = eventService
    }
}

extension EventListInteractor: EventListInteractionProtocol {
    func fetchEvents() {
        // eventservice.getEvents
    }
}
