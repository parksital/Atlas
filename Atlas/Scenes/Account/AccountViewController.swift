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
    typealias DataSource = UICollectionViewDiffableDataSource<AccountSectionType, User>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<AccountSectionType, User>
    
    private var interactor: AccountInteraction?
    private var router: AccountRouterProtocol?
    private var collectionView: UICollectionView!
    
    private var dataSource: DataSource!
    private var snapshot = DataSourceSnapshot()
    
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
        collectionView.register(
            UserProfileCollectionViewCell.self,
            forCellWithReuseIdentifier: UserProfileCollectionViewCell.id
        )
        
        collectionView.register(
            SettingCollectionViewCell.self,
            forCellWithReuseIdentifier: SettingCollectionViewCell.id
        )
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
//MARK: - CollectionView Methods
private extension AccountViewController {
    func applySnapshot(user: User?) {
        guard let user = user else { return }
        
        snapshot = DataSourceSnapshot()
        snapshot.appendSections([.userProfileSection])
        snapshot.appendItems([user], toSection: .userProfileSection)
        dataSource.apply(snapshot)
    }
    
    func configureDataSource() {
        dataSource = DataSource.init(collectionView: collectionView, cellProvider: { (collectionView, indexPath, user) -> UICollectionViewCell? in
            switch indexPath.section {
            case 0:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: UserProfileCollectionViewCell.id,
                    for: indexPath
                    ) as? UserProfileCollectionViewCell ?? UserProfileCollectionViewCell()
                
                cell.setup(firstName: "Parvin", lastName: "Sital")
                return cell
            case 1:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SettingCollectionViewCell.id,
                    for: indexPath
                    ) as? SettingCollectionViewCell ?? SettingCollectionViewCell()
                
                return cell
            default:
                return UICollectionViewCell()
            }
        })
    }
}

//MARK: - NSCollectionLayoutSection Creation
enum AccountSectionType: Int {
    case userProfileSection
    case settingsSection
}

private extension AccountViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout.init { [weak self] (section, env) -> NSCollectionLayoutSection? in
            let section = self?.createSectionForType(AccountSectionType(rawValue: section))
            return section
        }
    }
    
    func createSectionForType(_ accountSectionType: AccountSectionType?) -> NSCollectionLayoutSection? {
        guard let type = accountSectionType else { return nil }
    
        switch type {
        case .userProfileSection:
            let item = NSCollectionLayoutItem.init(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(0.1)
                ),
                subitems: [item]
            )
            
            group.contentInsets.leading = 16
            group.contentInsets.trailing = 16
            group.contentInsets.bottom = 16
            
            let section = NSCollectionLayoutSection.init(group: group)
            section.orthogonalScrollingBehavior = .paging
            return section
        case .settingsSection:
            let item = NSCollectionLayoutItem.init(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            
            item.contentInsets.leading = 16
            item.contentInsets.trailing = 16
            item.contentInsets.bottom = 16
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(100.0)),
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection.init(group: group)
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
