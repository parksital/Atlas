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
    var sections: [String] { get }

    func displayViewModel(_ viewModel: EventList.ViewModel)
    func updateSections(_ sections: [String])
    func didSelectEvent(_ event: String)
    func displayError(_ error: Error)
}

final class EventListViewController: UIViewController {
    var interactor: EventListLogic?
    var router: (NSObjectProtocol & EventListRouting & EventListDataPassing)?
    
    private (set) var viewModel: EventList.ViewModel = .init(events: [])
    private (set) var sections: [String] = ["Tonight"]
    
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
}

extension EventListViewController: EventListDisplayLogic {
    func updateSections(_ sections: [String]) {
        self.sections = sections
    }
    
    func didSelectEvent(_ event: String) {
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
        setupNavigationBar()
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
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = SectionType(rawValue: section) else { return 0 }
        
        //let events =  viewModel.eventsForSectionType(_:)
        // return events.count
        
        switch sectionType {
        case .tonight: return viewModel.events.count
        case .tomorrow: return 0
        case .date: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? EventSummaryCell ?? EventSummaryCell()
        
        let event = viewModel.events[indexPath.row]
        cell.setup(title: event.title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor?.didSelectEvent(atIndex: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
