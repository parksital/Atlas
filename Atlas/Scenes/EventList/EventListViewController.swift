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
}

final class EventListViewController: UIViewController {
    var interactor: EventListLogic?
    var router: (NSObjectProtocol & EventListRouting & EventListDataPassing)?
    
    private (set) var viewModel: EventList.ViewModel = .init()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        interactor?.fetchEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
}

extension EventListViewController: EventListDisplayLogic {
    func didSelectEvent() {
        router?.routeToDetail()
    }
    
    func displayViewModel(_ viewModel: EventList.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.viewModel = viewModel
            self.tableView.reloadData()
        }
    }
    
    func displayError(_ error: Error) {
        
    }
}

private extension EventListViewController {
    func setup() {
        let viewController = self
        let presenter = EventListPresenter()
        let interactor = EventListInteractor()
        let router = EventListRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    func setupViews() {
        setupTableView(tableView)
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.darkText]
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.barStyle = .default
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionHeaders.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sectionHeaders[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.eventsForSection(section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? EventSummaryCell ?? EventSummaryCell()
        
        let events = viewModel.eventsForSection(indexPath.section)
        cell.setup(eventSummary: events[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let events = viewModel.eventsForSection(indexPath.section)
        
        interactor?.didSelectEvent(events[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
