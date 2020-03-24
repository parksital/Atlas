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
    func didSelectEvent(_ event: EventSummary)
}

protocol EventListDataStore {
    var events: [EventList.Response] { get }
    var selectedEvent: EventSummary? { get }
}

final class EventListInteractor: EventListDataStore {
    var presenter: EventListPresentationLogic?
    var eventService: EventService?
    
    private (set) var events: [EventList.Response] = []
    private (set) var selectedEvent: EventSummary?
    
    init(eventService: EventService? = EventService()) {
        self.eventService = eventService
    }
}

extension EventListInteractor: EventListLogic {
    func didSelectEvent(_ event: EventSummary) {
        updateSelectedEvent(event)
        presenter?.didSelectEvent()
    }
    
    func fetchEvents() {
        eventService?.fetchEventList { [weak self] result in
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
    func getEventSummaryAtIndex(_ index: Int) -> EventList.Response? {
        guard index < events.count else { return nil }
        return events[index]
    }
    
    func updateEvents(_ fetchedEvents: [EventList.Response]) {
        events = fetchedEvents
    }
    
    func updateSelectedEvent(_ event: EventSummary) {
        self.selectedEvent = event
    }
    
    func presentEvents(_ events: [EventList.Response]) {
        presenter?.presentEventResponse(events)
    }
}
