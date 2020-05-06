//
//  EventDetailPresenter.swift
//  Atlas
//
//  Created by Parvin Sital on 11/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

protocol EventDetailPresentationLogic: class {
    func presentEventTitle(title: String)
    func presentEvent(_ event: Event)
    func setup(viewController: EventDetailDisplayLogic)
}

final class EventDetailPresenter {
    weak var viewController: EventDetailDisplayLogic?
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter
    }()
}

extension EventDetailPresenter: EventDetailPresentationLogic {
    func setup(viewController: EventDetailDisplayLogic) {
        self.viewController = viewController
    }
    func presentEventTitle(title: String) {
        viewController?.displayEventTitle(title)
    }
    
    func presentEvent(_ event: Event) {
        let viewModel = getViewModelForEvent(event)
        viewController?.displayViewModel(viewModel)
        
    }
}

extension EventDetailPresenter {
    func getViewModelForEvent(_ event: Event) -> EventDetail.ViewModel {
        EventDetail.ViewModel(
            id: event.id,
            title: event.title.capitalized,
            startDate: formatDate(event.startDate),
            venue: event.venue,
            description: event.description ?? "",
            artists: event.artists.map { $0.artistName }
        )
    }
    
    func formatDate(_ date: Date) -> String {
        return date.formatted(using: dateFormatter.string(from:))
    }
}
