//
//  DemoSetupProfileViewController.swift
//  TinderApp
//
//  Created by Timofey on 11/7/22.
//

import UIKit
import PhotosUI
import SnapKit


class DemoSetupProfileViewController: UIViewController, UINavigationControllerDelegate {
  
  private enum Constants {
    static let topImageViewMultiplier: CGFloat = 0.056919642857143
    static let widthImageViewMultiplier: CGFloat = 0.516908212560386
    static let horizontalPaddingMultiplier: CGFloat = 0.055555555555556
  }
  
  private var profileImageView: ProfileImageView!
  private var nameTextField: SetupProfileTextField!
  private var interestsLabel: UILabel!
  private var interestCollectionView: InterestsCollectionViewController!
  private var toDemoButton: StartScreenButton!
  private var imagePicker: PHPickerViewController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupElements()
    setupConstraints()
  }
  
  func checkFields() -> Bool {
    if let text = nameTextField.text, text.count > 0 {
        return true
       } else {
         UIView.animate(withDuration: 0.3) {
           self.toggleDraggleAnimation()
         }
         return false
       }
  }
  
  func toggleDraggleAnimation() {
    let start = nameTextField.center
    UIView.animateKeyframes(withDuration: 0.7, delay: 0.1, options: .calculationModeCubic) {
      UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
        self.nameTextField.transform = CGAffineTransform(translationX: 8, y: 0)
      }
      UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25) {
        self.nameTextField.transform = CGAffineTransform(translationX: -8, y: 0)
      }
      UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25) {
        self.nameTextField.transform = .identity
        self.nameTextField.center = start
      }
    }
  }
  
  
  @objc func toDemo() {
    if checkFields() {
      let name = self.nameTextField.text!
      var interests = Set<Interest>()
      for interest in self.interestCollectionView.interests {
        if interest.match {
          interests.insert(interest.interest)
        }
      }
      let user = UserCardModel(name: Name(first: name, last: ""),
                  gender: Gender.male,
                  location: Location(city: "Perm",
                                     coordinates: Coordinates(latitude: "2", longitude: "3")),
                  birthDate: BirthDate(date: "03.03.02", age: 19),
                  picture: WebImage(large: "https://vgmsite.com/soundtracks/spongebob-battle-for-bikini-bottom-gc-xbox-ps2/coverart.jpg",
                                    thumbnail: "https://prodigits.co.uk/thumbs/android-games/thumbs/s/1396790468.jpg"),
                  id: ID.init(value: "id"),
                  interests: interests)
      
      let mainVC = MainTabBarController(user: user)
      if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
        sceneDelegate.changeRootViewController(mainVC, animated: true)
      }
    }
  }
  
}

// MARK: - Setup UI & Constraints

extension DemoSetupProfileViewController {
  
  private func setupElements() {
    setupBackground()
    setupImageView()
    setupTextField()
    setupLabel()
    setupButton()
    setupInterestsCollectionView()
    setupImagePicker()
  }
  
  private func setupImagePicker() {
    var config = PHPickerConfiguration()
    config.selectionLimit = 1
    config.filter = .images
    imagePicker = PHPickerViewController(configuration: config)
    imagePicker.delegate = self
  }
  
  private func setupButton() {
    toDemoButton = StartScreenButton(with: .light, title: "Find your friend")
    toDemoButton.addTarget(self, action: #selector(toDemo), for: .touchUpInside)
  }
  
  private func setupInterestsCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumInteritemSpacing = 10
    layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
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
    
    view.addSubview(profileImageView)
    
    profileImageView.snp.makeConstraints { make in
      make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(Constants.topImageViewMultiplier * height)
      make.height.width.equalTo(Constants.widthImageViewMultiplier * width)
      make.centerX.equalToSuperview()
    }
    
    view.addSubview(nameTextField)
    
    nameTextField.snp.makeConstraints { make in
      make.top.equalTo(profileImageView.snp.bottom).offset(25)
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
    profileImageView = ProfileImageView()
    profileImageView.delegate = self
  }
  
  private func setupBackground() {
    let gradientLayer = LayerFactory.shared.getGradientLayer()
    gradientLayer.frame = view.bounds
    view.layer.insertSublayer(gradientLayer, at: 0)
  }
  
}

// MARK: - PHPickerViewControllerDelegate
extension DemoSetupProfileViewController: PHPickerViewControllerDelegate {
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    picker.dismiss(animated: true, completion: nil)
    for result in results {
      result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
        if let image = object as? UIImage {
          DispatchQueue.main.async {
            self.profileImageView.updateImage(with: image)
          }
        }
      }
    }
  }
}


// MARK: - ProfileImageViewDelegate
extension DemoSetupProfileViewController: ProfileImageViewDelegate {
  
  func chooseImage() {
    present(imagePicker, animated: true, completion: nil)
  }
  
}

