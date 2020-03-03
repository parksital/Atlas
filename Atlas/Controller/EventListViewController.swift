//
//  EventListViewController.swift
//  Atlas
//
//  Created by Parvin Sital on 21/02/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

protocol EventListViewOutput: class {
    
}

final class EventListViewController: UIViewController, EventListViewOutput {
    
    private let interactor: EventListInteraction!
    private (set) var safeArea: UILayoutGuide!
    private let eventsTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    init(interactor: EventListInteraction) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension EventListViewController {
    func setup() {
        setupView()
        setupTableView()
        
        // interactor.fetchEvents
    }
    
    func setupView() {
        safeArea = view.layoutMarginsGuide
        view.backgroundColor = .systemPink

        setupNavigationBar()
        setupContainerView()
    }
    
    func setupContainerView() {
        view.addSubview(eventsTableView)
        
        eventsTableView.translatesAutoresizingMaskIntoConstraints = false
        let top = eventsTableView.topAnchor.constraint(equalTo: view.topAnchor)
        let leading = eventsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailing = eventsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let bottom = eventsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        NSLayoutConstraint.activate([top, leading, trailing, bottom])
    }
    
    func setupTableView() {
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Events"
    }
}

extension EventListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // grab this from the viewmodel later
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a custom cell
        return UITableViewCell()
    }
}

extension EventListViewController {
    final class EventListViewModel {
        
    }
}
