//
//  DemoSetupProfileViewController.swift
//  TinderApp
//
//  Created by Timofey on 11/7/22.
//

import UIKit



class DemoSetupProfileViewController: UIViewController {
  
  private enum Constants {
    static let topImageViewMultiplier: CGFloat = 0.056919642857143
    static let widthImageViewMultiplier: CGFloat = 0.516908212560386
    static let horizontalPaddingMultiplier: CGFloat = 0.055555555555556
  }
  
  private var profileImagePicker: ProfileImageView!
  private var nameTextField: SetupProfileTextField!
  private var interestsLabel: UILabel!
  private var interestCollectionView: InterestsCollectionViewController!
  private var toDemoButton: StartScreenButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupElements()
    setupConstraints()
  }

  private func setupElements() {
    setupBackground()
    setupImageView()
    setupTextField()
    setupLabel()
    setupButton()
    setupInterestsCollectionView()
  }
  
  private func setupButton() {
    toDemoButton = StartScreenButton(with: .light, title: "Find your friend")
    toDemoButton.addTarget(self, action: #selector(toDemo), for: .touchUpInside)
  }
  
  @objc func toDemo() {
    let mainVC = MainTabBarController()
  }
  
  private func setupInterestsCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumInteritemSpacing = 15
    layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: -20, right: 20)
    layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    
    interestCollectionView = InterestsCollectionViewController(collectionViewLayout: layout)
    interestCollectionView.changeStyleToChoosable()
    interestCollectionView.interests = Interest.allCases.map({ interest in
      (interest, false)
    })
  }
  
  private func setupLabel() {
    interestsLabel = UILabel()
    interestsLabel.text = "Choose Interests"
    interestsLabel.font = .systemFont(ofSize: 18, weight: .semibold)
    interestsLabel.textColor = .logoColor
  }
  
  private func setupTextField() {
    nameTextField = SetupProfileTextField()
  }
  
  private func setupConstraints() {
    
    let width = view.bounds.width
    let height = view.bounds.height
    
    
    view.addSubview(profileImagePicker)
    
    profileImagePicker.snp.makeConstraints { make in
      make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(Constants.topImageViewMultiplier * height)
      make.height.width.equalTo(Constants.widthImageViewMultiplier * width)
      make.centerX.equalToSuperview()
    }
    
    view.addSubview(nameTextField)
    
    nameTextField.snp.makeConstraints { make in
      make.top.equalTo(profileImagePicker.snp.bottom).offset(25)
      make.centerX.equalToSuperview()
    }
    
    view.addSubview(interestsLabel)
    
    interestsLabel.snp.makeConstraints { make in
      make.top.equalTo(nameTextField.snp.bottom).offset(26)
      make.leading.equalToSuperview().offset(Constants.horizontalPaddingMultiplier * width)
    }
    
    view.addSubview(toDemoButton)
    
    toDemoButton.snp.makeConstraints { make in
      make.horizontalEdges.equalToSuperview().inset(Constants.horizontalPaddingMultiplier * width)
      make.bottom.equalToSuperview().offset(-28)
      make.height.equalTo(55)
    }
    
    view.addSubview(interestCollectionView.view)
    
    interestCollectionView.view.snp.makeConstraints { make in
      make.top.equalTo(interestsLabel.snp.bottom).offset(12)
      make.horizontalEdges.equalToSuperview().inset(Constants.horizontalPaddingMultiplier * width)
      make.bottom.equalTo(toDemoButton.snp.top).offset(-24)
      
    }
  }
  
  private func setupImageView() {
    profileImagePicker = ProfileImageView()
    profileImagePicker.delegate = self
  }
  
  private func setupBackground() {
    let gradientLayer = LayerFactory.shared.getGradientLayer()
    gradientLayer.frame = view.bounds
    view.layer.insertSublayer(gradientLayer, at: 0)
  }
  
  
}


extension DemoSetupProfileViewController: ProfileImageViewDelegate {
  
  func chooseImage() -> UIImage? {
    print("choosing image")
    return nil
  }
  
}
