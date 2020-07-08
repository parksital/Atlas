//
//  PreferencesViewController.swift
//  Atlas
//
//  Created by Parvin Sital on 08/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

final class WipeKeychainCell: UITableViewCell {
    private let button = UIButton(type: .system)
    var action: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension WipeKeychainCell {
    func setupViews() {
        self.selectionStyle = .none
        setupButton()
    }
    
    func setupButton() {
        button.setTitle("Wipe Keychain", for: .normal)
        button.tintColor = .systemRed
        button.addTarget(
            self,
            action: #selector(self.buttonTapped),
            for: .touchUpInside
        )
        
        setupButtonConstraints()
    }
    
    func setupButtonConstraints() {
        contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = button.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor)
        let top = button.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor)
        let bottom = button.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        let height = button.heightAnchor.constraint(equalToConstant: 44.0)
        
        NSLayoutConstraint.activate([leading, top, bottom, height])
    }
    
    @objc func buttonTapped() {
        action?()
    }
}

extension WipeKeychainCell {
    func configure() {
        
    }
}

enum PreferenceSectionType: Int, CaseIterable {
    case preferences
}

enum PreferenceItem: Hashable {
    case wipeKeychain
}

final class PreferencesViewController: UIViewController {
    typealias DataSource = UITableViewDiffableDataSource<PreferenceSectionType, PreferenceItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<PreferenceSectionType, PreferenceItem>
    
    //    private var interactor: PreferencesInteraction?
    //    private var router: PreferencesRouter?
    
    private var dataSource: DataSource?
    private var currentSnapshot: Snapshot?
    
    private let stackView = UIStackView()
    private let wipeKeychainButton = UIButton(type: .roundedRect)
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

private extension PreferencesViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        setupNavigation()
        setupTableView()
    }
    
    func setupNavigation() {
        navigationItem.title = "Preferences"
    }
    
    func setupTableView() {
        registerTableViewViewCells()
        setupTableViewConstraints()
        configureTableViewDatasource()
        setInitialSnapshot()
    }
    
    func registerTableViewViewCells() {
        tableView.register(cellType: WipeKeychainCell.self)
    }
    
    func setupTableViewConstraints() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        let trailing = tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        let top = tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let bottom = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }
    
    func configureTableViewDatasource() {
        dataSource = DataSource(tableView: tableView) { (tableView, indexPath, item) -> UITableViewCell? in
            switch item {
            case .wipeKeychain:
                let cell: WipeKeychainCell = tableView.getCell(forIndexPath: indexPath)
                cell.action = { print("wipe keychain") }
                cell.configure()
                return cell
            }
        }
    }
    
    func setInitialSnapshot() {
        currentSnapshot = Snapshot()
        currentSnapshot?.appendSections(PreferenceSectionType.allCases)
        currentSnapshot?.appendItems([.wipeKeychain], toSection: .preferences)
        dataSource?.apply(currentSnapshot!, animatingDifferences: false)
    }
    
    @objc func wipeKeychain() {
        DispatchQueue.global(qos: .utility).async {
            _ = KeychainWrapper.standard.removeAllKeys()
        }
    }
}
