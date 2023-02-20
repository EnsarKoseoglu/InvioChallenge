//
//  UITableView+Ext.swift
//  InvioChallenge
//
//  Created by invio on 12.11.2022.
//

import UIKit

public extension UITableView {
    
    func register<T: UITableViewCell>(cellType: T.Type, bundle: Bundle? = nil) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellReuseIdentifier: className)
    }
    
    func register<T: UITableViewCell>(cellTypes: [T.Type], bundle: Bundle? = nil) {
        cellTypes.forEach { register(cellType: $0, bundle: bundle) }
    }
    
    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: type.className, for: indexPath) as! T
    }

    func showLoading() {
      let spinner = UIActivityIndicatorView(style: .medium)
      spinner.frame = CGRect(x: 0.0, y: 0.0, width: self.bounds.width, height: (self.visibleCells.first?.frame.height ?? 50.0)/2)
      spinner.startAnimating()
      self.tableFooterView = spinner
      self.tableFooterView?.isHidden = false
    }

    func hideLoading() {
      self.tableFooterView?.isHidden = true
      self.tableFooterView = nil
    }

  func showRecordSummary(with message: String) {
      let messageLabel = UILabel()
      messageLabel.frame = CGRect(x: 0.0, y: 0.0, width: self.bounds.width, height: (self.visibleCells.first?.frame.height ?? 70.0)/2)
      messageLabel.text = message
      messageLabel.font = UIFont.roboto(.Medium, size: 16.0)
      messageLabel.textColor = .systemGray3
      messageLabel.textAlignment = .center
      self.tableFooterView = messageLabel
      self.tableFooterView?.isHidden = false
    }
}
