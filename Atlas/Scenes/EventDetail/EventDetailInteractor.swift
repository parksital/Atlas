//
//  EventDetailInteractor.swift
//  Atlas
//
//  Created by Parvin Sital on 11/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

protocol EventDetailLogic: class {
    
}

protocol EventDetailDataStore: class {
    var eventID: String? { get set } 
}

final class EventDetailInteractor: EventDetailDataStore {
    var eventID: String?
    var presenter: EventDetailPresentationLogic?
}

extension EventDetailInteractor: EventDetailLogic {
    
}
