//
//  EventListInteractor.swift
//  Atlas
//
//  Created by Parvin Sital on 22/02/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

protocol EventListLogic {
    func fetchEvents()
    func didSelectEvent(atIndex: Int)
}

protocol EventListDataStore {
    var events: [EventSummary] { get }
}

final class EventListInteractor: EventListDataStore {
    var presenter: EventListPresentationLogic?
    private (set) var events: [EventSummary] = []
    private let eventService: EventService! = EventService()
}

extension EventListInteractor: EventListLogic {
    func didSelectEvent(atIndex index: Int) {
        guard index < events.count else {
            assertionFailure("index out of bounds")
            return
        }
        
        presenter?.didSelectEvent(events[index])
    }
    
    func fetchEvents() {
        eventService.fetchEventsSummarized { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            case .success(let data):
                self.updateEvents(data)
                self.presentEvents(data)
            }
        }
    }
}

private extension EventListInteractor {
    func updateEvents(_ fetchedEvents: [EventSummary]) {
        events = fetchedEvents
    }
    
    func presentEvents(_ events: [EventSummary]) {
        presenter?.presentEvents(events)
    }
}
