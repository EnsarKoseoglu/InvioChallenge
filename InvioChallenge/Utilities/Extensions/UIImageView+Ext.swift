//
//  UIImageView+Ext.swift
//  InvioChallenge
//
//  Created by EnsarKoseoglu on 19.02.2023.
//

import UIKit

extension UIImageView {
  func setImage(from urlString: String?, placeholder: UIImage?) {
    guard let urlString, let imgUrl = URL(string: urlString) else { return }

    self.image = placeholder
    self.activityIndicator.startAnimating()

    let urlRequest = URLRequest(url: imgUrl)
    let task = URLSession.shared.dataTask(with: urlRequest) { imgData, res, err in
      guard err == nil, let imgData else {
        DispatchQueue.main.async {
          self.activityIndicator.stopAnimating()
        }
        return
      }

      DispatchQueue.main.async {
        self.activityIndicator.stopAnimating()
        self.image = UIImage(data: imgData)
      }
    }
    task.resume()
  }

  fileprivate var activityIndicator: UIActivityIndicatorView {
    if let indicator = self.subviews.first(where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView {
      return indicator
    }

    let activityIndicator = UIActivityIndicatorView(style: .large)
    activityIndicator.hidesWhenStopped = true

    self.addSubview(activityIndicator)
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

    return activityIndicator
  }
}
