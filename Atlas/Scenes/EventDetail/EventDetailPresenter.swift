//
//  EventDetailPresenter.swift
//  Atlas
//
//  Created by Parvin Sital on 11/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

protocol EventDetailPresentationLogic: class {
    
}

final class EventDetailPresenter {
    weak var viewController: EventDetailDisplayLogic?
}

extension EventDetailPresenter: EventDetailPresentationLogic {
    
}
