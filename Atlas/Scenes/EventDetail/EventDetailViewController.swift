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
    func displayEventDetailItems(_ items: [EventDetailItem])
    func displayBuyTicketScene()
    func displayOpenWithAlert()
    func setup(interactor: EventDetailInteraction)
    func setup(router: EventDetailRouterProtocol)
}

final class EventDetailViewController: UICollectionViewController, HasLocalization {
    var tableName: String { return "EventDetail" }
    var localizationService: LocalizationService!
    
    typealias DataSource = UICollectionViewDiffableDataSource<EventDetailSectionType, EventDetailItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<EventDetailSectionType, EventDetailItem>
    
    var interactor: EventDetailInteraction?
    var router: EventDetailRouterProtocol?
    private var dataSource: DataSource!
    
    init() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, env in
            let size = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(40.0)
            )
            
            let item = NSCollectionLayoutItem(
                layoutSize: size,
                supplementaryItems: []
            )
            
            item.edgeSpacing = NSCollectionLayoutEdgeSpacing(
                leading: nil,
                top: .fixed(10.0),
                trailing: nil,
                bottom: .fixed(10.0)
            )
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(50.0)
                ),
                subitems: [item]
            )
            
            return NSCollectionLayoutSection(group: group)
        }
        
        super.init(collectionViewLayout: layout)
    }
    
    override init(
        nibName nibNameOrNil: String?,
        bundle nibBundleOrNil: Bundle?
    ) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        setupViews()
        interactor?.viewDidFinishLoading()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
}

private extension EventDetailViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        setupCollectionView()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.alwaysBounceVertical = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        registerCells()
        setupDataSource()
    }
    
    func registerCells() {
        collectionView.register(cellType: UICollectionViewCell.self)
        collectionView.register(cellType: EventHeaderCell.self)
        collectionView.register(cellType: EventDescriptionCell.self)
        collectionView.register(cellType: ArtistContainerCell.self)
        collectionView.register(cellType: ButtonViewCell.self)
        collectionView.register(cellType: MapCell.self)
    }
    
    func setupDataSource() {
        dataSource = DataSource(collectionView: collectionView) { [weak self] (collectionView, indexPath, object) in
            guard let self = self else { return nil }
            switch object.section {
            case .header:
                let cell: EventHeaderCell = collectionView.getCell(forIndexPath: indexPath)
                cell.configure(
                    venueName: object.event.venue,
                    dateTime: object.event.startDate
                )
                return cell
            case .description:
                let cell: EventDescriptionCell = collectionView.getCell(forIndexPath: indexPath)
                cell.configure(
                    headerText: self.localize("eventInformation"),
                    description: object.event.description
                )
                return cell
            case .artists:
                let cell: ArtistContainerCell = collectionView.getCell(forIndexPath: indexPath)
                cell.configure(
                    headerText: self.localize("artists"),
                    artists: object.event.artists
                )
                return cell
            case .admission:
                let cell: ButtonViewCell = collectionView.getCell(forIndexPath: indexPath)
                cell.action = self.interactor?.buyTicketButtonPressed
                let title = self.localize("buyTickets")
                cell.configure(buttonTitle: title)
                return cell
            case .map:
                let cell: MapCell = collectionView.getCell(forIndexPath: indexPath)
                cell.openWithAction = self.interactor?.mapViewTapped
                cell.configure(event: object.event)
                return cell
            }
        }
        
        collectionView.dataSource = dataSource
    }
    
    func updateSnapshotWithItems(_ items: [EventDetailItem]) {
        var snapshot = Snapshot()
        items.forEach({ item in
            snapshot.appendSections([item.section])
            snapshot.appendItems([item], toSection: item.section)
        })
        dataSource.apply(snapshot, animatingDifferences: true)
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
    
    func displayEventDetailItems(_ items: [EventDetailItem]) {
        updateSnapshotWithItems(items)
    }
    
    func displayBuyTicketScene() {
        router?.routeToBuyTicket()
    }
    
    func displayOpenWithAlert() {
        let alert = self.createAlert(
            title: localize("openWith"),
            message: localize("pleaseSelectApp"),
            style: .actionSheet,
            actions: []
        )
        router?.presentOpenWithAlert(alert)
    }
}

extension EventDetailViewController {
    func createAlert(
        title: String,
        message: String? = nil,
        style: UIAlertController.Style = .alert,
        actions: [UIAlertAction] = []
    ) -> UIAlertController {
        let output = UIAlertController(
            title: title,
            message: message,
            preferredStyle: style
        )
        
        actions.forEach(output.addAction(_:))
        output.addAction(createCancelAction())
        
        return UIAlertController()
    }
    
    func createCancelAction() -> UIAlertAction {
        return UIAlertAction(
            title: localize("cancel"),
            style: .cancel,
            handler: nil
        )
    }
}
