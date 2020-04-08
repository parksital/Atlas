//
//  EventListInteractor.swift
//  Atlas
//
//  Created by Parvin Sital on 22/02/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import Combine

protocol EventListLogic {
    func fetchEvents()
    func didSelectEvent(_ event: EventSummary)
}

protocol EventListDataStore {
    var events: [EventList.Response] { get }
    var selectedEvent: EventSummary? { get }
}

typealias EventListInteraction = EventListLogic & EventListDataStore
final class EventListInteractor: EventListDataStore {
    var presenter: EventListPresentationLogic?
    private (set) var eventService: EventService!
    private (set) var events: [EventList.Response] = []
    private (set) var selectedEvent: EventSummary?
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(presenter: EventListPresentationLogic, eventService: EventService) {
        self.eventService = eventService
    }
}

extension EventListInteractor: EventListLogic {
    func didSelectEvent(_ event: EventSummary) {
        guard events.contains(where: { $0.id == event.id }) else {
            presenter?.presentError(NetworkError.generic)
            return
        }
        
        updateSelectedEvent(event)
        presenter?.didSelectEvent()
    }
    
    func fetchEvents() {
        eventService.fetchEventList()
            .sink(
                receiveCompletion: {
                    switch $0 {
                    case .finished: return
                    case .failure(let error): self.presenter?.presentError(error)
                    }
            },
                receiveValue: {
                    self.updateEvents($0)
                    self.presentEvents($0)
            }
        ).store(in: &cancellables)
    }
}

private extension EventListInteractor {
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
