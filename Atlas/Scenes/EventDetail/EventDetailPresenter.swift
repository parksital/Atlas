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
    func presentBuyTicket()
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
        let viewModel = EventDetail.ViewModel(
            id: event.id,
            title: event.title.capitalized,
            startDate: formatDate(event.startDate),
            venue: event.venue.name,
            longitude: event.venue.longitude,
            latitude: event.venue.latitude,
            description: event.description ?? "",
            artists: event.artists.map { $0.artistName }
        )
        
        let items = [
            EventDetailItem(section: .header, event: viewModel),
            EventDetailItem(section: .description, event: viewModel),
            EventDetailItem(section: .artists, event: viewModel)
            //            EventDetailItem(section: .admission, item: viewModel),
            //            EventDetailItem(section: .map, item: viewModel)
        ]
        viewController?.displayEventDetailItems(items)
    }
    
    func presentBuyTicket() {
        viewController?.displayBuyTicketScene()
    }
}

extension EventDetailPresenter {
    func formatDate(_ date: Date) -> String {
        return date.formatted(using: dateFormatter.string(from:))
    }
}
