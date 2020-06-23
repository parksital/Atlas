//
//  AccountViewController.swift
//  Atlas
//
//  Created by Parvin Sital on 20/06/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

protocol AccountDisplayLogic: class {
    func setup(interactor: AccountInteraction)
    func setup(router: AccountRouterProtocol)
    func showSignUpView()
    func displayAccount(for user: User?)
}

final class AccountViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<AccountSectionType, AccountItem>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<AccountSectionType, AccountItem>
    
    private var interactor: AccountInteraction?
    private var router: AccountRouterProtocol?
    
    private var collectionView: UICollectionView!
    private var dataSource: DataSource!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        interactor?.viewDidFinishLoading()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

private extension AccountViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        setupNavigation()
        setupCollectionView()
    }
    
    func setupNavigation() {
        navigationItem.title = "Account"
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        configureDataSource()
        registerCollectionViewCells()
        setupCollectionViewConstraints()
    }
    
    func registerCollectionViewCells() {
        collectionView.registerCell(cell: NoProfileCollectionViewCell.self)
        collectionView.registerCell(cell: UserProfileCollectionViewCell.self)
        collectionView.registerCell(cell: SettingCollectionViewCell.self)
    }
    
    func setupCollectionViewConstraints() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailing = collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let top = collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let bottom = collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }
}
//MARK: - CollectionViewDataSource Methods
private extension AccountViewController {
    func applySnapshot(user: User?) {
        dataSource.apply(getSnapshotForUser(user))
    }
    
    func getSnapshotForUser(_ user: User?) -> DataSourceSnapshot {
        var snapshot = DataSourceSnapshot()
        snapshot.appendSections([.userProfileSection])
        snapshot.appendItems([AccountItem(user: user)], toSection: .userProfileSection)
        return snapshot
    }
    
    func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView) { [interactor] (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch item {
                
            case .noProfile:
                let cell: NoProfileCollectionViewCell = collectionView.dequeueCell(atIndexPath: indexPath)
                cell.action = interactor?.goToSignUp
                cell.configure()
                return cell
                
            case .profile(let user):
                let cell: UserProfileCollectionViewCell = collectionView.dequeueCell(atIndexPath: indexPath)
                cell.setup(firstName: user.firstName, lastName: user.familyName)
                return cell
                
            case .setting(_):
                return UICollectionViewCell()
            }
        }
    }
    
    func configuredCell(forIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NoProfileCollectionViewCell.id,
            for: indexPath
            ) as? NoProfileCollectionViewCell ?? NoProfileCollectionViewCell()
        cell.action = interactor?.goToSignUp
        cell.configure()
        return cell
    }
}

//MARK: - CollectionViewLayout Methods
private extension AccountViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout.init { [weak self] (section, env) -> NSCollectionLayoutSection? in
            let section = self?.createSectionForType(AccountSectionType(rawValue: section))
            return section
        }
    }
    
    func createSectionForType(_ accountSectionType: AccountSectionType?) -> NSCollectionLayoutSection? {
        guard let type = accountSectionType else { return nil }
        
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(80.0)
            )
        )
        
        switch type {
        case .userProfileSection:
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(0.1)
                ),
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            return section
            
        case .settingsSection:
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                ),
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
}

extension AccountViewController: AccountDisplayLogic {
    func setup(interactor: AccountInteraction) {
        self.interactor = interactor
    }
    
    func setup(router: AccountRouterProtocol) {
        self.router = router
    }
    
    func showSignUpView() {
        router?.routeToSignUp()
    }
    
    func displayAccount(for user: User?) {
        applySnapshot(user: user)
    }
}
