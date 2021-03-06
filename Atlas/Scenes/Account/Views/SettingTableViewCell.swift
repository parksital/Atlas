//
//  SettingTableViewCell.swift
//  Atlas
//
//  Created by Parvin Sital on 22/06/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

final class SettingTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SettingTableViewCell {
    func setupViews() {
        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .none
    }
}

extension SettingTableViewCell {
    func configure(title: String) {
        self.textLabel?.text = title
    }
}
