//
//  EventDetailInteractor.swift
//  Atlas
//
//  Created by Parvin Sital on 11/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation
import Combine

@objc protocol EventDetailLogic: class {
    func viewDidFinishLoading()
    func fetchEvent()
    func buyTicketButtonPressed()
    func mapViewTapped()
}

protocol EventDetailDataStore: class {
    var event: Event? { get }
    var eventID: String? { get set }
    var eventTitle: String? { get set }
}

typealias EventDetailInteraction = EventDetailLogic & EventDetailDataStore
final class EventDetailInteractor: EventDetailDataStore {
    var eventID: String?
    var eventTitle: String?
    private (set) var event: Event?
    
    var presenter: EventDetailPresentationLogic?
    
    private let eventService: EventService!
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(presenter: EventDetailPresentationLogic, eventService: EventService) {
        self.presenter = presenter
        self.eventService = eventService
    }
    
    deinit { cancellables.forEach { $0.cancel() } }
    
}

extension EventDetailInteractor: EventDetailLogic {
    func viewDidFinishLoading() {
        guard let title = eventTitle else {
            assertionFailure("eventTitle not set by router")
            return
        }
        presenter?.presentEventTitle(title: title)
        fetchEvent()
    }
    
    func fetchEvent() {
        guard let id = eventID else {
            assertionFailure("eventID not set by router")
            return
        }
        eventService.event(byID: id)
            .sink(
                receiveCompletion: {
                    switch $0 {
                    case .finished: break
                    case .failure(let error): assertionFailure(error.localizedDescription)
                    }
            },
                receiveValue: { [weak self] response in
                    self?.event = response.event
                    self?.presentEvent(response.event)
                }
        ).store(in: &cancellables)
    }
    
    func buyTicketButtonPressed() {
        presenter?.presentBuyTicket()
    }
    
    func mapViewTapped() {
        guard let venue = event?.venue else { return }
        presenter?.presentOpenMaps(forVenue: venue)
    }
}

private extension EventDetailInteractor {
    func presentEvent(_ event: Event) {
        presenter?.presentEvent(event)
    }
}
