//
//  HeaderLabel.swift
//  InvioChallenge
//
//  Created by EnsarKoseoglu on 17.02.2023.
//

import UIKit.UILabel

class HeaderLabel: UILabel {
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setAttributes()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.setAttributes()
  }

  func setAttributes() {
    self.textColor = UIColor.softBlack
    self.font = UIFont.roboto(.Bold, size: 16.0)
  }
}
