//
//  EventListPresenter.swift
//  Atlas
//
//  Created by Parvin Sital on 22/02/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

enum EventList {
    struct ViewModel {
        let events: [EventSummary]
    }
}

protocol EventListPresentationLogic {
    func presentEvents(_ events: [EventSummary])
    func didSelectEvent(_ event: EventSummary)
    func presentError(_ error: Error)
}

final class EventListPresenter {
    weak var viewController: EventListDisplayLogic?
}

extension EventListPresenter: EventListPresentationLogic {
    func didSelectEvent(_ event: EventSummary) {
        viewController?.didSelectEvent(event.title)
    }
    
    func presentEvents(_ events: [EventSummary]) {
        viewController?.displayViewModel(.init(events: events))
    }
    
    func presentError(_ error: Error) {
        assertionFailure(error.localizedDescription)
    }
}
