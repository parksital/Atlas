//
//  EventListPresenter.swift
//  Atlas
//
//  Created by Parvin Sital on 22/02/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

final class EventListPresenter {
    weak var view: EventListViewOutputProtocol?
}

extension EventListPresenter: EventListPresentationProtocol {
    func presentEvents(_ events: [EventSummary]) {
        view?.displayEvents(events.map { $0.title })
    }
    
    func presentError(_ error: Error) {
        assertionFailure(error.localizedDescription)
    }
}
