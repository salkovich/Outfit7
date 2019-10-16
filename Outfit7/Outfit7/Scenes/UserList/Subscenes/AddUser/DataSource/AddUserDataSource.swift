//
//  AddUserDataSource.swift
//  Outfit7
//
//  Created by Marcel Salej on 14/10/2019.
//  Copyright © 2019 Marcel Salej. All rights reserved.
//

import UIKit

class AddUserDataSource: NSObject, DataSourceProtocol {
  var sections: [AddUserSection] = []
}

// MARK: - Public Methods
extension AddUserDataSource {
  func setData(user: User?) {
    sections.removeAll()
    var rows = [AddUserRow]()
    rows.append(.inputText(.init(placeholderLabel: "Name:", insertedString: user?.name ?? "")))
    rows.append(.inputText(.init(placeholderLabel: "Username:", insertedString: user?.username ?? "")))
    rows.append(.inputText(.init(placeholderLabel: "Email:", insertedString: user?.email ?? "")))
    rows.append(.inputDate(.init(placeholderText: "Birth date", insertedDate: user?.birthday)))
    rows.append(.inputText(.init(placeholderLabel: "Salary", insertedString: String(format: "%.2f", user?.salary ?? ""))))
    rows.append(.inputText(.init(placeholderLabel: "Rating", insertedString: String(format: "%.2f", user?.rating ?? ""))))
    
    sections.append(.form(rows: rows))
  }
  
  /*let name: String
   let birthday: Date
   let username: String
   let email: String
   let salary: Double
   let rating: Double*/
}

// MARK: - UITableView DataSource
extension AddUserDataSource: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return numberOfSections()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return numberOfRows(in: section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let row = section(at: indexPath.section)?.row(at: indexPath.row) else {
      Logger.error("No available row in dataSource at given indexPath \(indexPath)!")
      return UITableViewCell()
    }
    
    switch row {
    case .inputText(let viewModel):
      let cell = tableView.dequeueReusableCell(InputTextTableViewCell.self, at: indexPath)
      cell.setData(viewModel)
      return cell
    case .inputDate(let viewModel):
      let cell = tableView.dequeueReusableCell(InputDateTableViewCell.self, at: indexPath)
      cell.setData(viewModel)
      return cell
    }
  }
}
