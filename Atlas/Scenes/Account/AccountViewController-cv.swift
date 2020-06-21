//
//  AccountViewController-cv.swift
//  Atlas
//
//  Created by Parvin Sital on 20/06/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

final class AccountViewControllerCV: UIViewController {
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

private extension AccountViewControllerCV {
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
        collectionView.delegate = self
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
    
    func applySnapshot(user: User?) {
        guard let user = user else { return }
        snapshot = DataSourceSnapshot()
        snapshot.appendSections([.userProfileSection])
        snapshot.appendItems([user], toSection: .userProfileSection)
        dataSource.apply(snapshot)
    }
}
//MARK: - CollectionView Methods
extension AccountViewControllerCV: UICollectionViewDelegate {
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 3
        default: return 0
        }
    }
}

//MARK: - NSCollectionLayoutSection Creation
enum AccountSectionType: Int {
    case userProfileSection
    case settingsSection
}

private extension AccountViewControllerCV {
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

extension AccountViewControllerCV: AccountDisplayLogic {
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

class UserProfileCollectionViewCell: UICollectionViewCell, Identifiable {
    static var id: String = "UserProfileCollectionViewCell"
    
    private let stackView = UIStackView()
    private let firstNamelabel = UILabel()
    private let lastNameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
}

private extension UserProfileCollectionViewCell {
    func setupViews() {
        setupStackView()
        setupFirstNameLabel()
        setupLastNameLabel()
    }
    
    func setupStackView() {
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.backgroundColor = .secondarySystemBackground
        
        setupStackViewConstraints()
    }
    
    func setupStackViewConstraints() {
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let leading = stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let trailing = stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        let top = stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor)
        let bottom = stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }
    
    func setupFirstNameLabel() {
        firstNamelabel.applyStyling(.title)
        firstNamelabel.backgroundColor = .clear
        stackView.addArrangedSubview(firstNamelabel)
    }
    
    func setupLastNameLabel() {
        lastNameLabel.applyStyling(.title)
        lastNameLabel.backgroundColor = .clear
        stackView.addArrangedSubview(lastNameLabel)
    }

}

extension UserProfileCollectionViewCell {
    func setup(firstName: String, lastName: String) {
        self.firstNamelabel.text = firstName
        self.lastNameLabel.text = lastName
    }
}

class SettingCollectionViewCell: UICollectionViewCell, Identifiable {
    static var id: String = "SettingCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
