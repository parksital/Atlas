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
        let viewModel = createViewModelForResponse(events)
        viewController?.displayViewModel(viewModel)
    }
    
    func presentError(_ error: Error) {
        assertionFailure(error.localizedDescription)
    }
}

extension EventListPresenter {
    func createViewModelForResponse(_ response: [EventSummary]) -> EventList.ViewModel {
        return EventList.ViewModel(
            events: getEventsDictionary(response),
            sectionHeaders: sectionHeadersForEvents(response)
        )
    }
    
    func getEventsDictionary(_ events: [EventSummary]) -> [String: [EventSummary]] {
        let output = events.reduce(into: [String: [EventSummary]]()) { acc, event in
            let sectionType = sectionForDate(event.startDate).header!
            var events = acc[sectionType] ?? []
            events.append(event)
            acc.updateValue(events, forKey: sectionType)
        }
        
        return output
    }
    
    func sectionHeadersForEvents(_ events: [EventSummary]) -> [String] {
        var sections = events
            .map { $0.startDate }
            .map(sectionForDate(_:))
        
        sections.insert(.tomorrow, at: 0)
        sections.insert(.tonight, at: 0)
        
        return sections
            .compactMap { $0.header }
            .unique()
    }

    
    func sectionForDate(_ date: Date) -> SectionType {
        if Calendar.current.isDateInToday(date) {
            return .tonight
        } else if Calendar.current.isDateInTomorrow(date) {
            return .tomorrow
        } else {
            let date = date.formatted(using: dateFormatter.string(from:))
            return SectionType.date(date)
        }
    }
}
