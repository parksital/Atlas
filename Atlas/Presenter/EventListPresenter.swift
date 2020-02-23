//
//  EventListPresenter.swift
//  Atlas
//
//  Created by Parvin Sital on 22/02/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

protocol EventListPresentation {
    var view: EventListOutput? { get set }
}

final class EventListPresenter: EventListPresentation {
    weak var view: EventListOutput?
}
