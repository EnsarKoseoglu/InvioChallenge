//
//  DetailLabel.swift
//  InvioChallenge
//
//  Created by EnsarKoseoglu on 17.02.2023.
//

import UIKit.UILabel

class DetailLabel: UILabel {
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setAttributes()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.setAttributes()
  }

  func setAttributes() {
    self.font = UIFont.roboto(.Regular, size: 12.0)
  }
}
