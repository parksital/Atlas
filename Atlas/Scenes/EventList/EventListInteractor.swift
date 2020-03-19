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
    var eventService: EventService?
    
    private (set) var events: [EventSummary] = []
    
    init(eventService: EventService? = EventService()) {
        self.eventService = eventService
    }
}

extension EventListInteractor: EventListLogic {
    func didSelectEvent(atIndex index: Int) {
        guard let event = getEventSummaryAtIndex(index) else {
            presenter?.presentError(NetworkError.generic)
            return
        }
        
        presenter?.didSelectEvent(event)
    }
    
    func fetchEvents() {
        eventService?.fetchEventsSummarized { [weak self] result in
            switch result {
            case .failure(let error):
                self?.presenter?.presentError(error)
            case .success(let data):
                self?.updateEvents(data)
                self?.presentEvents(data)
            }
        }
    }
}

private extension EventListInteractor {
    func getEventSummaryAtIndex(_ index: Int) -> EventSummary? {
        guard index < events.count else { return nil }
        return events[index]
    }
    
    func updateEvents(_ fetchedEvents: [EventSummary]) {
        events = fetchedEvents
    }
    
    func presentEvents(_ events: [EventSummary]) {
        presenter?.presentEvents(events)
    }
}
