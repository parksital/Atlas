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
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
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
        var dict: [SectionType: [EventSummary]] = .init()
        
        let dates = response.map { $0.startDate }
        var sections: [SectionType] = [.tonight, .tomorrow]
        let customSections: [SectionType] = getUniqueSectionsTypesForDates(dates)
        
        sections.append(contentsOf: customSections)
        
        sections.forEach { dict[$0] = [] }
        dict[.tonight] = response
        
        return EventList.ViewModel(events: dict)
    }
    
    func getUniqueSectionsTypesForDates(_ dates: [Date]) -> [SectionType] {
        let output: [SectionType] = dates
            .map { $0.formatted(using: dateFormatter.string(from:)) }
            .unique()
            .map { SectionType.date($0) }
        
        return output
    }
}
