//
//  InterestCell.swift
//  TinderApp
//
//  Created by Timofey on 3/7/22.
//

import UIKit

class InterestCell: UICollectionViewCell {
  
  public static let cellIdentifier: String = "interestCell"
  
  @IBOutlet var interestCell: UILabel!
  @IBOutlet var interestLabel: UILabel!
  private var match = false
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupLayer()
  }
  
  private func setupLayer() {
    self.layer.cornerRadius = self.bounds.height / 2
    self.layer.masksToBounds = true
  }
  
  func configure(with interest: Interest, matching: Bool, interactionEnabled: Bool = false) {
    let matchColorOpacity = interactionEnabled ? 0.5 : 0.2
    self.match = matching
    self.interestCell.text = interest.rawValue.uppercasingFirstLetter
    self.backgroundColor = matching
      ? .firstGradientColor.withAlphaComponent(matchColorOpacity)
      : .black.withAlphaComponent(0.1)
  }
  
}
