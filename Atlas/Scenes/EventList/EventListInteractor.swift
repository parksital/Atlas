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
    private let eventService: EventService!
    
    init(presenter: EventListPresentationProtocol, eventService: EventService) {
        self.presenter = presenter
        self.eventService = eventService
    }
}

extension EventListInteractor: EventListInteractionProtocol {
    func fetchEvents() {
        eventService.fetchEventsSummarized { [presenter] result in
            switch result {
            case .failure(let error): assertionFailure(error.localizedDescription)
            case .success(let data): presenter?.presentEvents(data)
            }
        }
    }
}
