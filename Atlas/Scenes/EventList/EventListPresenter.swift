//
//  EventListPresenter.swift
//  Atlas
//
//  Created by Parvin Sital on 22/02/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

protocol EventListPresentationLogic {
    func setup(viewController: EventListDisplayLogic)
    func presentEventItems(_ eventItems: [EventItem])
    func didSelectEvent()
    func presentError(_ error: Error)
}

#warning("TODO: - Clean me up")
final class EventListPresenter {
    weak var viewController: EventListDisplayLogic?
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}

extension EventListPresenter: EventListPresentationLogic {
    func setup(viewController: EventListDisplayLogic) {
        self.viewController = viewController
    }
    
    func presentEventItems(_ eventItems: [EventItem]) {
        let viewModel = createViewModelForResponse(eventItems)
        viewController?.displayViewModel(viewModel)
    }
    
    func didSelectEvent() {
        viewController?.didSelectEvent()
    }
    
    func presentError(_ error: Error) {
        assertionFailure(error.localizedDescription)
    }
}

extension EventListPresenter {
    func createViewModelForResponse(_ response: [EventItem]) -> EventList.ViewModel {
        return EventList.ViewModel(
            events: getEventsDictionary(response),
            sectionHeaders: sectionHeadersForEvents(response)
        )
    }
    
    func getEventsDictionary(_ events: [EventItem]) -> [String: [EventSummary]] {
        let output = events.reduce(into: [String: [EventSummary]]()) { acc, event in
            let sectionType = sectionForDate(event.startDate).header!
            var events = acc[sectionType] ?? []
            events.append(EventSummary(
                id: event.id,
                title: event.title,
                startDate: event.startDate,
                venue: event.venue
            ))
            acc.updateValue(events, forKey: sectionType)
        }
        
        return output
    }
    
    func sectionHeadersForEvents(_ events: [EventItem]) -> [String] {
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
