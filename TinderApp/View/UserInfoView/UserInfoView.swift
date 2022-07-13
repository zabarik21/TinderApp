//
//  UserInfoView.swift
//  TinderApp
//
//  Created by Timofey on 30/6/22.
//

import Foundation
import UIKit




class UserInfoView: UIView {
  
  private var compatabilityView: CompatabilityView!
  private var nameAgeLabel: UILabel!
  private var cityLabel: UILabel!
  private var labelsStackView: UIStackView!
  private var unfilled = true
  var viewModel: UsersInfoViewViewModelProtocol? {
    didSet {
      fillUI()
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if (viewModel == nil) && (unfilled != true) {
      unfillUI()
    }
  }
  
  init() {
    super.init(frame: .zero)
    setupElements()
    unfillUI()
  }
  
  private func fillUI() {
    DispatchQueue.main.async {
      if let viewModel = self.viewModel {
        self.compatabilityView.compatability = viewModel.compatabilityScore
        self.nameAgeLabel.text = viewModel.nameAgeText
        self.cityLabel.text = viewModel.cityText
        self.unfilled = false
      } else {
        self.unfillUI()
      }
    }
  }
  
  private func unfillUI() {
    unfilled = true
    self.nameAgeLabel.text = "Your future frend"
    self.cityLabel.text = "Nearby"
    self.compatabilityView.compatability = 10
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: - Setup Constraints & Elements
extension UserInfoView {
  
  private func setupElements() {
    setupCompatabilityView()
    setupLabels()
    setupConstraints()
  }
  
  func changeCompatabilityLabelTextColor(with color: UIColor) {
    compatabilityView.changeLabelColor(with: color)
    nameAgeLabel.textColor = color
    cityLabel.textColor = .black.withAlphaComponent(0.6)
  }
  
  private func setupCompatabilityView() {
    compatabilityView = CompatabilityView()
  }
  
  private func setupLabels() {
    nameAgeLabel = UILabel(text: "", fontSize: 24, weight: .bold, textColor: .cardLabelTextColor)
    cityLabel = UILabel(text: "", fontSize: 12, weight: .bold, textColor: .cardLabelTextColor)
    
    labelsStackView = UIStackView(arrangedSubviews: [nameAgeLabel, cityLabel])
    labelsStackView.axis = .vertical
    labelsStackView.alignment = .leading
    labelsStackView.distribution = .equalSpacing
  }
  
  private func setupConstraints() {
    addSubview(labelsStackView)
    labelsStackView.snp.makeConstraints { make in
      make.verticalEdges.equalToSuperview().inset(6)
      make.leading.equalToSuperview()
    }
    
    addSubview(compatabilityView)
    compatabilityView.snp.makeConstraints { make in
      make.height.equalToSuperview()
      make.width.equalTo(self.snp.height)
      make.trailing.equalToSuperview()
      make.top.equalToSuperview()
    }
  }
}
