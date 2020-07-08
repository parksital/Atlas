//
//  PreferencesViewController.swift
//  Atlas
//
//  Created by Parvin Sital on 08/07/2020.
//  Copyright © 2020 Parvin Sital. All rights reserved.
//

import UIKit

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
        setupWipeKeychainButton()
    }
    
    func setupNavigation() {
        navigationItem.title = "Preferences"
    }
    
    func setupTableView() {
        setupTableViewConstraints()
        configureTableViewDatasource()
        setInitialSnapshot()
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
                let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "")
                
                return cell
            }
        }
    }
    
    func setInitialSnapshot() {
        currentSnapshot = Snapshot()
        currentSnapshot?.appendSections(PreferenceSectionType.allCases)
        dataSource?.apply(currentSnapshot!, animatingDifferences: false)
    }
    
    func setupWipeKeychainButton() {
        wipeKeychainButton.setTitle("Wipe Keychain", for: .normal)
        wipeKeychainButton.tintColor = .systemRed
        wipeKeychainButton.addTarget(
            self,
            action: #selector(self.wipeKeychain),
            for: .touchUpInside
        )
        
        stackView.addArrangedSubview(wipeKeychainButton)
    }
    
    @objc func wipeKeychain() {
        DispatchQueue.global(qos: .utility).async {
            _ = KeychainWrapper.standard.removeAllKeys()
        }
    }
}
