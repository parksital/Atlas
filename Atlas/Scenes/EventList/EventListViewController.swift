//
//  EventListViewController.swift
//  Atlas
//
//  Created by Parvin Sital on 21/02/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

protocol EventListDisplayLogic: class {
    var viewModel: EventList.ViewModel { get }
    
    func displayViewModel(_ viewModel: EventList.ViewModel)
    func didSelectEvent()
    func displayError(_ error: Error)
    func setup(router: EventListRouterProtocol)
    func setup(interactor: EventListLogic)
}

final class EventListViewController: UIViewController {
    private (set) var interactor: EventListLogic?
    private (set) var router: EventListRouterProtocol?
    
    private (set) var viewModel: EventList.ViewModel = .init()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        interactor?.fetchEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}

extension EventListViewController: EventListDisplayLogic {
    func setup(router: EventListRouterProtocol) {
        self.router = router
    }
    
    func setup(interactor: EventListLogic) {
        self.interactor = interactor
    }
    
    func didSelectEvent() {
        router?.routeToDetail()
    }
    
    func displayViewModel(_ viewModel: EventList.ViewModel) {
        self.viewModel = viewModel
        DispatchQueue.main.async { [tableView] in
            tableView.reloadData()
        }
    }
    
    func displayError(_ error: Error) {
        
    }
}

private extension EventListViewController {
    func setupViews() {
        setupNavigationBar()
        setupTableView(tableView)
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.label]
        navigationController?.navigationBar.barStyle = .default
        navigationItem.title = "Events"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Account",
            style: .plain,
            target: router,
            action: #selector(router!.routeToAccount)
        )
    }
    
    func setupTableView(_ tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionHeaders.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sectionHeaders[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let eventCount = viewModel.eventsForSection(section).count
        return eventCount > 0 ? eventCount : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? EventSummaryCell ?? EventSummaryCell()
        
        let events = viewModel.eventsForSection(indexPath.section)
        
        if events.isEmpty {
            let emptyCell = UITableViewCell(style: .default, reuseIdentifier: "default")
            emptyCell.textLabel?.text = "No events"
            emptyCell.isUserInteractionEnabled = false
            return emptyCell
        } else {
            cell.setup(eventSummary: events[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let events = viewModel.eventsForSection(indexPath.section)
        
        interactor?.didSelectEvent(events[indexPath.row])
    }
}
