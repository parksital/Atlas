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
    func fetchEvents() {
        eventService.fetchEventsSummarized { [presenter] result in
            switch result {
            case .failure(let error): assertionFailure(error.localizedDescription)
            case .success(let data): presenter?.presentEvents(data)
            }
        }
    }
}
