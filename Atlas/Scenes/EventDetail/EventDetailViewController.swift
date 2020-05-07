//
//  EventDetailViewController.swift
//  Atlas
//
//  Created by Parvin Sital on 11/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import AloeStackView

protocol EventDetailDisplayLogic: class {
    func displayEventTitle(_ title: String)
    func displayViewModel(_ viewModel: EventDetail.ViewModel)
    func setup(interactor: EventDetailInteraction)
    func setup(router: EventDetailRouterProtocol)
}

final class EventDetailViewController: UIViewController {
    var interactor: EventDetailInteraction?
    var router: EventDetailRouterProtocol?
    
    private let stackView = AloeStackView()
    private var titleLabel = UILabel(styling: .title)
    private var dateTimeLabel = UILabel(styling: .headline)
    private var descriptionLabel = UILabel(styling: .body)
    private var artistHeaderLabel = UILabel.init(styling: .headline)
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        setupViews()
        interactor?.viewDidFinishLoading()
        interactor?.fetchEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
}

private extension EventDetailViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        setupStackView()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupStackView() {
        stackView.hidesSeparatorsByDefault = true
        stackView.alwaysBounceVertical = true
        stackView.backgroundColor = .systemBackground
        stackView.rowBackgroundColor = .systemBackground
        stackView.separatorColor = .separator
        setupStackViewConstraints()
        
        stackView.addRows([
            titleLabel,
            dateTimeLabel,
            descriptionLabel,
            artistHeaderLabel
        ], animated: true)
    }
    
    func setupStackViewConstraints() {
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let leading = stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailing = stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let top = stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let bottom = stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }
    
    func updateViewsForViewModel(_ viewModel: EventDetail.ViewModel) {
        titleLabel.text = viewModel.venue
        dateTimeLabel.text = viewModel.startDate
        descriptionLabel.text = viewModel.description
        artistHeaderLabel.text = "Artists"
        
        viewModel.artists.forEach { [stackView] in
            let label = UILabel(styling: .body)
            label.text = $0
            stackView.addRow(label, animated: true)
            stackView.showSeparator(forRow: label)
        }
    }
}

extension EventDetailViewController: EventDetailDisplayLogic {
    func setup(interactor: EventDetailInteraction) {
        self.interactor = interactor
    }
    
    func setup(router: EventDetailRouterProtocol) {
        self.router = router
    }
    
    func displayEventTitle(_ title: String) {
        navigationItem.title = title
    }
    
    func displayViewModel(_ viewModel: EventDetail.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.updateViewsForViewModel(viewModel)
        }
    }
}
