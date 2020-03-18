//
//  EventDetailInteractor.swift
//  Atlas
//
//  Created by Parvin Sital on 11/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

protocol EventDetailLogic: class {
    func viewDidFinishLoading()
    func fetchEvent()
}

protocol EventDetailDataStore: class {
    var event: EventSummary? { get set }
}

final class EventDetailInteractor: EventDetailDataStore {
    var event: EventSummary?
    var presenter: EventDetailPresentationLogic?
    private let eventService: EventService! = EventService()
}

extension EventDetailInteractor: EventDetailLogic {
    func fetchEvent() {
        eventService.fetchEvent(request: .init(id: event!.id)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            case .success(let response):
                self.presentEvent(response)
            }
        }
    }
    
    func viewDidFinishLoading() {
        presenter?.presentEventTitle(title: event!.title)
    }
}

private extension EventDetailInteractor {
    func presentEvent(_ event: EventDetail.Response) {
        presenter?.presentEventResponse(event)
    }
}
