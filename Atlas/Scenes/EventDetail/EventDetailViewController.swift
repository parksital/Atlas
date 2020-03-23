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
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
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
    
    private var scrollViewComponent: ScrollViewComponent?
    
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
//        setupScrollView()
//        setupContentView()
        
        updatePrioritiesForViews([titleLabel, dateTimeLabel, descriptionLabel])
        setupStackView()
        scrollViewComponent = ScrollViewComponent(view: stackView)
        
        if let component = scrollViewComponent {
            view.addSubview(component)
            setupScrollComponentConstraints()
        }
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        setupConstraintsForScrollView()
    }
    
    func setupContentView() {
        scrollView.addSubview(contentView)
        setupConstraintsForContentView()
    }
    
    func setupStackView() {
//        contentView.addSubview(stackView)
//        setupConstraintsForStackView()
        populateStackView(stackView, withSubviews: [titleLabel, dateTimeLabel, descriptionLabel])
    }
    
    func setupScrollComponentConstraints() {
        if let scrollComponent = scrollViewComponent {
            scrollComponent.translatesAutoresizingMaskIntoConstraints = false
            let leading = scrollComponent.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            let trailing = scrollComponent.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            let top = scrollComponent.topAnchor.constraint(equalTo: view.topAnchor)
            let bottom = scrollComponent.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
            NSLayoutConstraint.activate([leading, trailing, top, bottom])
        }
    }
    
    func setupConstraintsForScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let leading = scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailing = scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let top = scrollView.topAnchor.constraint(equalTo: view.topAnchor)
        let bottom = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }
    
    func setupConstraintsForContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let top = contentView.topAnchor.constraint(equalTo: scrollView.topAnchor)
        let leading = contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
        let trailing = contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        let bottom = contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        let width = contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        let height = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        height.priority = .defaultLow
        NSLayoutConstraint.activate([leading, trailing, top, bottom, width, height])
    }
    
    func setupConstraintsForStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let top = stackView.topAnchor.constraint(equalTo: contentView.topAnchor)
        let leading = stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        let trailing = stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        let bottom = stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        NSLayoutConstraint.activate([top, leading, trailing, bottom])
    }
    
    func populateStackView(_ stackView: UIStackView, withSubviews views: [UIView]) {
        views.forEach { stackView.addArrangedSubview($0) }
        stackView.addArrangedSubview(UIView().spacer())
    }
    
    func updatePrioritiesForViews(_ views: [UIView]) {
        views.forEach { $0.setContentHuggingPriority(.defaultHigh, for: .vertical) }
    }
}

extension EventDetailViewController: EventDetailDisplayLogic {
    func displayEventTitle(_ title: String) {
        navigationItem.title = title
    }
    
    func displayViewModel(_ viewModel: EventDetail.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.titleLabel.text = viewModel.venue
            self.dateTimeLabel.text = viewModel.startDate
            self.descriptionLabel.text = viewModel.description
        }
    }
}
