//
//  EventSummaryCell.swift
//  Atlas
//
//  Created by Parvin Sital on 10/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

final class EventSummaryCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(eventSummary: EventSummary) {
        textLabel?.text = eventSummary.title
    }
}
