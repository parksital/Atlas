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
    
    private let aloeStackView = AloeStackView()
    private var titleLabel = UILabel(styling: .title)
    private var dateTimeLabel = UILabel(styling: .headline)
    private var descriptionLabel = UILabel(styling: .body)
    private var artistHeaderLabel = UILabel.init(styling: .headline)
    private var buttonView = UIView()
    private var ticketButton = UIButton(type: .roundedRect)
    
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
        setupTicketButton()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupStackView() {
        aloeStackView.hidesSeparatorsByDefault = true
        aloeStackView.alwaysBounceVertical = true
        aloeStackView.backgroundColor = .systemBackground
        aloeStackView.rowBackgroundColor = .systemBackground
        aloeStackView.separatorColor = .separator
        setupStackViewConstraints()
    }
    
    func setupStackViewConstraints() {
        view.addSubview(aloeStackView)
        
        aloeStackView.translatesAutoresizingMaskIntoConstraints = false
        let leading = aloeStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailing = aloeStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let top = aloeStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let bottom = aloeStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }
    
    func setupTicketButton() {
        ticketButton.setTitle(NSLocalizedString("buyTicket", comment: ""), for: .normal)
        
        buttonView.addSubview(ticketButton)
        ticketButton.translatesAutoresizingMaskIntoConstraints = false
        
        let top = ticketButton.topAnchor.constraint(equalTo: buttonView.safeAreaLayoutGuide.topAnchor)
        let bottom = ticketButton.bottomAnchor.constraint(equalTo: buttonView.safeAreaLayoutGuide.bottomAnchor)
        let center = ticketButton.centerXAnchor.constraint(equalTo: buttonView.safeAreaLayoutGuide.centerXAnchor)
        let height = ticketButton.heightAnchor.constraint(equalToConstant: 44.0)
        
        NSLayoutConstraint.activate([top, bottom, center, height])
    }
    
    func updateViewsForViewModel(_ viewModel: EventDetail.ViewModel) {
        titleLabel.text = viewModel.venue
        dateTimeLabel.text = viewModel.startDate
        descriptionLabel.text = viewModel.description
        artistHeaderLabel.text = NSLocalizedString("artists", comment: "")
        
        aloeStackView.addRows([
            titleLabel,
            dateTimeLabel,
            descriptionLabel,
            artistHeaderLabel
        ], animated: true)
        
        viewModel.artists.forEach { [aloeStackView] in
            let label = UILabel(styling: .body)
            label.text = $0
            aloeStackView.addRow(label, animated: true)
            aloeStackView.showSeparator(forRow: label)
        }
        
        aloeStackView.addRow(buttonView, animated: true)
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
