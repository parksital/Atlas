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
    func setup(interactor: EventDetailInteraction)
    func setup(router: EventDetailRouterProtocol)
}

final class EventDetailViewController: UICollectionViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<EventDetailSectionType, EventDetailItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<EventDetailSectionType, EventDetailItem>
    
    var interactor: EventDetailInteraction?
    var router: EventDetailRouterProtocol?
    private var dataSource: DataSource!
    private var buttonView = UIView()
    private var ticketButton = UIButton(type: .roundedRect)
    
    init() {
        let layout = UICollectionViewCompositionalLayout { section, env in
            let size = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(40.0)
            )
            
            let item = NSCollectionLayoutItem(
                layoutSize: size,
                supplementaryItems: []
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
    }
    
    func setupDataSource() {
        dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, object) in
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
                cell.configure(description: object.event.description)
                return cell
            case .artists:
                let cell: ArtistContainerCell = collectionView.getCell(forIndexPath: indexPath)
                cell.configure(withArtists: object.event.artists)
                return cell
            case .admission:
                break
            case .map:
                break
            }
            let cell: UICollectionViewCell = collectionView.getCell(forIndexPath: indexPath)
            return cell
        }
        
        collectionView.dataSource = dataSource
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
}
