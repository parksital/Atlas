//
//  ScrollViewComponent.swift
//  Atlas
//
//  Created by Parvin Sital on 21/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

final class ScrollViewComponent: UIScrollView {
    private var contentView: UIView = { UIView() }()
    private var embeddedView: UIView?
    
    init() {
        super.init(frame: .zero)
        setup()
        setupContentView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

private extension ScrollViewComponent {
    func setup() {
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.alwaysBounceVertical = true
    }
    
    func setupContentView() {
        self.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let leading = contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let top = contentView.topAnchor.constraint(equalTo: self.topAnchor)
        let trailing = contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        let bottom = contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        let width = contentView.widthAnchor.constraint(equalTo: self.widthAnchor)
        let height = contentView.heightAnchor.constraint(equalTo: self.heightAnchor)
        height.priority = .defaultLow
        
        NSLayoutConstraint.activate([leading, top, trailing, bottom, width, height])
    }
}
extension ScrollViewComponent {
    func setupWithView(_ view: UIView) {
        self.embeddedView = view
    
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let top = view.topAnchor.constraint(equalTo: contentView.topAnchor)
        let leading = view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        let trailing = view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        let bottom = view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        
        NSLayoutConstraint.activate([top, leading, trailing, bottom])
    }
}
