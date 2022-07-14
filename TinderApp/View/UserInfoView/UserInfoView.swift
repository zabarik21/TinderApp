//
//  UserInfoView.swift
//  TinderApp
//
//  Created by Timofey on 30/6/22.
//

import Foundation
import UIKit
import RxSwift
import RxRelay



class UserInfoView: UIView {
  
  private var compatabilityView: CompatabilityView!
  private var nameAgeLabel: UILabel!
  private var cityLabel: UILabel!
  private var labelsStackView: UIStackView!
  private var bag = DisposeBag()
  
  
  var viewModelRelay = BehaviorRelay<UsersInfoViewViewModelProtocol?>(value: nil)
  
  init() {
    super.init(frame: .zero)
    setupElements()
    setupObserver()
  }
  
  private func setupObserver() {
    viewModelRelay
      .subscribe { [weak self] viewModel in
        self?.fillUI(with: viewModel)
      }.disposed(by: bag)
  }
  
  private func fillUI(with viewModel: UsersInfoViewViewModelProtocol?) {
    DispatchQueue.main.async {
      self.compatabilityView.compatability = viewModel?.compatabilityScore ?? 10
      self.nameAgeLabel.text = viewModel?.nameAgeText ?? "Your future frend"
      self.cityLabel.text = viewModel?.cityText ?? "Nearby"
    }
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
