//
//  EventListPresenter.swift
//  Atlas
//
//  Created by Parvin Sital on 22/02/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

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
        let viewModel = getViewModelForResponse(events)
        viewController?.displayViewModel(viewModel)
    }
    
    func presentError(_ error: Error) {
        assertionFailure(error.localizedDescription)
    }
}

extension EventListPresenter {
    func getViewModelForResponse(_ response: [EventSummary]) -> EventList.ViewModel {
        let events = response
        let sections: [SectionType] = [.tonight, .tomorrow, .date("")]
        
        
        return EventList.ViewModel(events: events, sections: sections)
    }
}
