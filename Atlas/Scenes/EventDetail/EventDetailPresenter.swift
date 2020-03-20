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
    func presentEventResponse(_ response: EventDetail.Response)
}

final class EventDetailPresenter {
    weak var viewController: EventDetailDisplayLogic?
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter
    }()
}

extension EventDetailPresenter: EventDetailPresentationLogic {
    func presentEventTitle(title: String) {
        viewController?.displayEventTitle(title)
    }
    
    func presentEventResponse(_ response: EventDetail.Response) {
        let viewModel = getViewModelForResponse(response)
        viewController?.displayViewModel(viewModel)
    }
}

extension EventDetailPresenter {
    func getViewModelForResponse(_ response: EventDetail.Response) -> EventDetail.ViewModel {
        EventDetail.ViewModel(
            id: response.id,
            title: response.title.capitalized,
            startDate: formatDate(response.startDate),
            venue: response.venue,
            description: response.description ?? ""
        )
    }
    
    func formatDate(_ date: Date) -> String {
        return date.formatted(using: dateFormatter.string(from:))
    }
}
