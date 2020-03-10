//
//  EventListViewOutputProtocol.swift
//  Atlas
//
//  Created by Parvin Sital on 03/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import Foundation

protocol EventListViewOutputProtocol: class {
    var events: [String] { get }
    func displayEvents(_ viewModel: [String])
    func displayError(_ error: Error)
}
