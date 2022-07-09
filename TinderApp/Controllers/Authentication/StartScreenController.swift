//
//  StartScreenController.swift
//  TinderApp
//
//  Created by Timofey on 9/7/22.
//

import UIKit
import SnapKit

class StartScreenController: UIViewController {
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupGradientBackground()
  }
  
  private func setupGradientBackground() {
    let gradientLayer = LayerFactory.shared.getGradientLayer(with: [.firstGradientColor, .secondGradientColor])
    gradientLayer.frame = self.view.bounds
    view.layer.insertSublayer(gradientLayer, at: 0)
    let backgroundImage = UIImageView()
    backgroundImage.image = UIImage(named: "emojis")!
    self.view.addSubview(backgroundImage)
    backgroundImage.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  
  
}





