//
//  UserListViewController.swift
//  Outfit7
//
//  Created by Marcel Salej on 14/10/2019.
//  Copyright © 2019 Marcel Salej. All rights reserved.
//
import SnapKit
import UIKit

protocol UserListDisplayLogic: AnyObject {
  func displayUserListSuccess(userList: [User])
  func displayUserListRemovalSuccess(updatedUsersList: [User])
  func displayUserListError()
}

class UserListViewController: UIViewController {
  var interactor: UserListBusinessLogic?
  var router: UserListRoutingLogic?
  private let dataSource = UserListDataSource()
  private lazy var contentView = UserListContentView.setupAutoLayout()
  private var userList = [User]()
  
  init(delegate: UserListRouterDelegate?) {
    super.init(nibName: nil, bundle: nil)
    let interactor = UserListInteractor()
    let presenter = UserListPresenter()
    let router = UserListRouter()
    interactor.presenter = presenter
    presenter.viewController = self
    router.viewController = self
    router.delegate = delegate
    self.interactor = interactor
    self.router = router
    dataSource.delegate = self
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    fetchUserList()
  }
}

// MARK: - Load data
extension UserListViewController {
  func fetchUserList() {
    contentView.toggleLoading(true)
    interactor?.fetchInitialUsersList()
  }
}

// MARK: - Display Logic
extension UserListViewController: UserListDisplayLogic {
  func displayUserListRemovalSuccess(updatedUsersList: [User]) {
    self.userList = updatedUsersList
  }
  
  func displayUserListError() {
  }
  
  func displayUserListSuccess(userList: [User]) {
    self.userList = userList
    dataSource.setData(users: userList)
    contentView.tableView.reloadData()
    contentView.toggleLoading(false)
  }
}

// MARK: - Private Methods
private extension UserListViewController {
  func setupViews() {
    setupContentView()
    setupNavigationHeader()
  }
  
  func setupNavigationHeader() {
    navigationItem.title = "Users"
  }
  
  func setupContentView() {
    view.addSubview(contentView)
    contentView.tableView.dataSource = dataSource
    contentView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}

// MARK: UserListDataSourceDelegate
extension UserListViewController: UserListDataSourceDelegate {
  func willRemoveUser(at indexPath: IndexPath) {
    print("IndexPath  \(indexPath)")
    interactor?.deleteUser(userList: userList, removedUser: userList[indexPath.row])
    contentView.tableView.reloadData()
  }
}
