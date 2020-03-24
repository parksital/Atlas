//
//  EventDetailViewController.swift
//  Atlas
//
//  Created by Parvin Sital on 11/03/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

protocol EventDetailDisplayLogic: class {
    func displayEventTitle(_ title: String)
    func displayViewModel(_ viewModel: EventDetail.ViewModel)
}

final class EventDetailViewController: UIViewController {
    var interactor: EventDetailLogic?
    var router: (NSObjectProtocol & EventDetailRouting & EventDetailDataPassing)?
    
    private var viewModel: EventDetail.ViewModel? {
        didSet {
            guard let vm = viewModel else { return }
            titleLabel.text = vm.venue
            dateTimeLabel.text = vm.startDate
            descriptionLabel.text = vm.description
            
            populateStackView(artistStackView, with: vm.artists.map {
                let label = UILabel()
                label.applyStyling(.body)
                label.text = $0
                return label
            })
        }
    }
    
    private var scrollViewComponent: ScrollViewComponent = { ScrollViewComponent() }()
    private var stackView: UIStackView! = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 20,
            leading: 20,
            bottom: 20,
            trailing: 20
        )
        return stackView
    }()
    
    private var artistStackView: UIStackView! = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = UIStackView.spacingUseSystem
        return stackView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.applyStyling(.title)
        return label
    }()
    
    private var dateTimeLabel: UILabel = {
        let label = UILabel()
        label.applyStyling(.headline)
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.applyStyling(.body)
        return label
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
    func setup() {
        let viewController = self
        let presenter = EventDetailPresenter()
        let interactor = EventDetailInteractor()
        let router = EventDetailRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    func setupViews() {
        view.backgroundColor = .white
        setPrioritiesForViews([titleLabel, dateTimeLabel, descriptionLabel])
        setupScrollViewComponent()
        populateStackView(stackView, with: [titleLabel, dateTimeLabel, descriptionLabel, artistStackView])
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupScrollViewComponent() {
        scrollViewComponent.setupWithView(stackView)
        setupScrollComponentConstraints()
    }
    
    func setupScrollComponentConstraints() {
        view.addSubview(scrollViewComponent)
        
        scrollViewComponent.translatesAutoresizingMaskIntoConstraints = false
        let leading = scrollViewComponent.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailing = scrollViewComponent.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let top = scrollViewComponent.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let bottom = scrollViewComponent.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }
    
    func populateStackView(_ stackView: UIStackView, with views: [UIView]) {
        views.forEach { stackView.addArrangedSubview($0) }
    }
    
    func setPrioritiesForViews(_ views: [UIView]) {
        views.forEach { $0.setContentHuggingPriority(.defaultHigh, for: .vertical) }
    }
}

extension EventDetailViewController: EventDetailDisplayLogic {
    func displayEventTitle(_ title: String) {
        navigationItem.title = title
    }
    
    func displayViewModel(_ viewModel: EventDetail.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.viewModel = viewModel
        }
    }
}
