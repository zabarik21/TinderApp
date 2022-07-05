//
//  InterestCell.swift
//  TinderApp
//
//  Created by Timofey on 3/7/22.
//

import UIKit

class InterestCell: UICollectionViewCell {
  
  @IBOutlet var interestCell: UILabel!
  @IBOutlet var interestLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupLayer()
  }
  
  private func setupLayer() {
    self.layer.cornerRadius = self.bounds.height / 2
    self.layer.masksToBounds = true
  }
  
  func configure(with interest: Interest, matching: Bool) {
    self.interestCell.text = interest.rawValue.uppercasingFirstLetter
    self.backgroundColor = matching ? .firstGradientColor.withAlphaComponent(0.2) : .black.withAlphaComponent(0.1)
  }
  
}
