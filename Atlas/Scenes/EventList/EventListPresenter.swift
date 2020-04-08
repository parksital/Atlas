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
    func presentEventResponse(_ response: [EventList.Response])
    func didSelectEvent()
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
    func setup(viewController: EventListDisplayLogic) {
        self.viewController = viewController
    }
    
    func presentEventResponse(_ response: [EventList.Response]) {
        let viewModel = createViewModelForResponse(response)
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
    func createViewModelForResponse(_ response: [EventList.Response]) -> EventList.ViewModel {
        return EventList.ViewModel(
            events: getEventsDictionary(response),
            sectionHeaders: sectionHeadersForEvents(response)
        )
    }
    
    func getEventsDictionary(_ events: [EventList.Response]) -> [String: [EventSummary]] {
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
    
    func sectionHeadersForEvents(_ events: [EventList.Response]) -> [String] {
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
