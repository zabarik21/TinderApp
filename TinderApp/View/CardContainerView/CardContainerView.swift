//
//  CardViewContainer.swift
//  TinderApp
//
//  Created by Timofey on 30/5/22.
//

import UIKit
import SnapKit

enum CardContainerConstants {
  static var topAnchorCardOffset: CGFloat = 5
  static var cardAppearTime: CGFloat = 0.25
  static let horizontalCardOffset: CGFloat = 0.032
  static let bottomCardOffset: CGFloat = 11
  static var minimizedCardHeightDelta: CGFloat = 0
  static var maximizedCardHeightDelta: CGFloat = -4
}


class CardContainerView: UIView, CardContainerViewProtocol {
  
  var viewModel: CardContainerViewViewModelProtocol?
  weak var delegate: CardContainerDelagate?
  
  var backCardContainer: UIView!
  var bottomCardView: CardViewProtocol!
  var topCardView: CardViewProtocol!
  
  var topCardTurn: Bool = true
  
  init() {
    super.init(frame: .zero)
    setupElements()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setupConstraints()
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if topCardTurn {
      delegate?.cardTouched(with: topCardView.viewModel)
    }
    else {
      delegate?.cardTouched(with: bottomCardView.viewModel)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}






// MARK: - Setup constraints
extension CardContainerView {
  
  private func setupElements() {
    backgroundColor = .clear
    topCardView = CardView(with: viewModel?.nextCard())
    bottomCardView = CardView(with: viewModel?.nextCard())
    
    topCardView.delegate = self
    bottomCardView.delegate = self
  }
  
  private func setupConstraints() {
      
    addSubview(bottomCardView)
    addSubview(topCardView)
    
    bottomCardView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    topCardView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
//    bottomCardView.snp.makeConstraints { make in
//      make.width.equalToSuperview().offset(-20)
//      make.top.equalToSuperview()
//      make.bottom.equalToSuperview()
//      make.centerX.equalToSuperview()
//    }
//
//    topCardView.snp.makeConstraints { make in
//      make.width.equalToSuperview()
//      make.top.equalToSuperview()
//      make.bottom.equalToSuperview().offset(-5)
//      make.centerX.equalToSuperview()
//    }
  }
}
