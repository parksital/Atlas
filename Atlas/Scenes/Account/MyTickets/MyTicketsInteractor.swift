//
//  MyTicketsInteractor.swift
//  Atlas
//
//  Created by Parvin Sital on 03/08/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

protocol MyTicketsLogic {
    
}

protocol MyTicketsDataStore {
    
}

typealias MyTicketsInteraction = MyTicketsLogic & MyTicketsDataStore
final class MyTicketsInteractor: MyTicketsInteraction {
    private let presenter: MyTicketsPresentationLogic!
    
    init(presenter: MyTicketsPresentationLogic) {
        self.presenter = presenter
    }
}
