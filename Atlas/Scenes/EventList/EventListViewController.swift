//
//  EventListViewController.swift
//  Atlas
//
//  Created by Parvin Sital on 21/02/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

final class EventListViewController: UIViewController, EventListViewOutputProtocol {
    private let interactor: EventListInteractionProtocol!
    private (set) var events: [String] = []
    private let eventsTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    init(interactor: EventListInteractionProtocol) {
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
    
    func displayEvents(_ viewModel: [String]) {
        self.events = viewModel
        DispatchQueue.main.async { [eventsTableView] in
            eventsTableView.reloadData()
        }
    }
    
    func displayError(_ error: Error) {
        
    }
}

private extension EventListViewController {
    func setup() {
        setupViews()
        
        interactor.fetchEvents()
    }
    
    func setupViews() {
        setupNavigationBar()
        setupTableView(eventsTableView)
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Events"
    }
    
    func setupTableView(_ tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        
        setupConstraintsFor(tableView, in: view)
        
        tableView.register(EventSummaryCell.self, forCellReuseIdentifier: "cell")
    }
    
    func setupConstraintsFor(_ tableView: UITableView, in view: UIView) {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let top = tableView.topAnchor.constraint(equalTo: view.topAnchor)
        let leading = tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailing = tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let bottom = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        NSLayoutConstraint.activate([top, leading, trailing, bottom])
    }
}

extension EventListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? EventSummaryCell ?? EventSummaryCell()
        
        cell.setup(title: events[indexPath.row])
        return cell
    }
}
