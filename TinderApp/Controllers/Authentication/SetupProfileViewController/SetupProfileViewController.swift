//
//  DemoSetupProfileViewController.swift
//  TinderApp
//
//  Created by Timofey on 11/7/22.
//

import UIKit
import PhotosUI
import SnapKit
import RxSwift
import FirebaseAuth

class SetupProfileViewController: UIViewController, UINavigationControllerDelegate, UIScrollViewDelegate {
  
  private enum Constants {
    static let topImageViewMultiplier: CGFloat = 0.01
    static let widthImageViewMultiplier: CGFloat = 0.516908212560386
    static let horizontalPaddingMultiplier: CGFloat = 0.055555555555556
  }
  
  private var bag = DisposeBag()
  private var location: Location?
  
  private var profileImageView: ProfileImageView!
  private var nameTextField: SetupProfileTextField!
  private var surnameTextField: SetupProfileTextField!
  private var scrollView: UIScrollView!
  private var genderPicker: TextFieldPickerView!
  private var birthDatePicker: UIDatePicker!
  private var genderLabel: UILabel!
  private var birthDateLabel: UILabel!
  private var interestsLabel: UILabel!
  private var interestCollectionView: InterestsCollectionViewController!
  private var toDemoButton: StartScreenButton!
  private var imagePicker: PHPickerViewController!
  
  private var user: User?
  
  init(user: User? = nil) {
    self.user = user
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupElements()
    setupConstraints()
    LocationService.shared.requestLocation()
  }
  
  private func setupObserver() {
    profileImageView.imageChooseObservable
      .subscribe(on: MainScheduler.instance)
      .subscribe { [weak self] _ in
        self?.chooseImage()
      }
      .disposed(by: bag)
    
    LocationService.shared.locationObservable
      .subscribe(on: MainScheduler.instance)
      .subscribe { [weak self] userLocation in
        self?.location = userLocation
      }
      .disposed(by: bag)
  }
  
  func checkFields() -> Bool {
    let nameEmpty = (nameTextField.text?.count ?? 0) == 0
    let surnameEmpty = (surnameTextField.text?.count ?? 0) == 0
    let genderEmpty = (genderPicker.text?.isEmpty ?? true) ? true : false
    
    if nameEmpty {
      nameTextField.twitch()
    }
    if surnameEmpty {
      surnameTextField.twitch()
    }
    if genderEmpty {
      genderPicker.twitch()
    }
    if !nameEmpty && !surnameEmpty && !genderEmpty {
      return true
    } else {
      return false
    }
  }
  
  @objc func toMainScreen() {
    
    if checkFields() {
      let name = Name(first: self.nameTextField.text!, last: self.surnameTextField.text!)
      let interests = interestCollectionView.interests
        .filter({ $0.match })
        .map({ $0.interest })
        .toSet()
      
      let gender = Gender(rawValue: self.genderPicker.text!.lowercasingFirstLetter)!
      let image = profileImageView.image
      let birthDate = CustomDateFormatter.shared.getFormattedString(birthDatePicker.date)
      let age = CustomDateFormatter.shared.yearsBetweenDate(startDate: birthDatePicker.date)
      
      if DemoModeService.isDemoMode {
        let user = UserCardModel.demoUser
        
        DispatchQueue.global(qos: .background).async {
          StorageService.shared.saveUser(user: user)
        }
        
        DispatchQueue.main.async {
          let mainVC = MainTabBarController(user: user)
          if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.changeRootViewController(mainVC, animated: true)
          }
        }
      } else {
        if let id = self.user?.uid,
           let email = self.user?.email {
          DispatchQueue.main.async { [weak self] in
            FirestoreService.shared.saveProfileWith(
              id: id,
              name: name,
              email: email,
              image: image,
              gender: gender,
              location: self?.location,
              birthDate: BirthDate(
                date: birthDate,
                age: age),
              interests: interests,
              completion: { result in
                switch result {
                case .success(let userModel):
                  let mainVC = MainTabBarController(user: userModel)
                  if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    sceneDelegate.changeRootViewController(mainVC, animated: true)
                  }
                case .failure(let error):
                  self?.showAlert(title: "Error", message: error.localizedDescription)
                }
              })
          }
        } else {
          self.showAlert(title: "Error", message: "Failed to get current user")
        }
      }
    }
  }
  
}

// MARK: - Setup UI & Constraints

extension SetupProfileViewController {
  
  private func setupElements() {
    setupBackground()
    setupScrollView()
    setupImageView()
    setupTextFields()
    setupLabels()
    setupPickers()
    setupButton()
    setupInterestsCollectionView()
    setupImagePicker()
    setupObserver()
  }
  
  private func setupScrollView() {
    scrollView = UIScrollView()
    scrollView.delegate = self
    scrollView.showsVerticalScrollIndicator = false
  }
  
  private func setupPickers() {
    let genders = Gender.allCases.map { $0.rawValue.uppercasingFirstLetter }
    genderPicker = TextFieldPickerView(with: genders)
    genderPicker.backgroundColor = .white.withAlphaComponent(0.5)
    
    birthDatePicker = UIDatePicker()
    birthDatePicker.datePickerMode = .date
    birthDatePicker.backgroundColor = .white.withAlphaComponent(0.5)
    birthDatePicker.layer.cornerRadius = 5
    birthDatePicker.layer.masksToBounds = true
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
    toDemoButton.addTarget(self, action: #selector(toMainScreen), for: .touchUpInside)
  }
  
  private func setupInterestsCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumInteritemSpacing = 10
    layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    
    interestCollectionView = InterestsCollectionViewController(collectionViewLayout: layout)
    interestCollectionView.changeStyleToChoosable()
    let interests = Interest.allCases
      .map { ($0, false) }
    
    interestCollectionView.interestsRelay.accept(interests)
  }
  
  private func setupLabels() {
    genderLabel = UILabel(
      text: "Gender",
      fontSize: 16,
      weight: .semibold,
      textColor: .logoColor)
    
    birthDateLabel = UILabel(
      text: "Birth date",
      fontSize: 16,
      weight: .semibold,
      textColor: .logoColor)
    
    interestsLabel = UILabel(
      text: "Choose Interests",
      fontSize: 18,
      weight: .semibold,
      textColor: .logoColor)
  }
  
  private func setupTextFields() {
    nameTextField = SetupProfileTextField(placeHolder: "Name")
    surnameTextField = SetupProfileTextField(placeHolder: "Surname")
  }
  
  private func setupImageView() {
    profileImageView = ProfileImageView()
  }
  
  private func setupBackground() {
    let gradientLayer = LayerFactory.shared.getGradientLayer()
    gradientLayer.frame = view.bounds
    view.layer.insertSublayer(gradientLayer, at: 0)
  }
  
  private func setupConstraints() {
    
    let width = view.bounds.width
    let height = view.bounds.height
    
    view.addSubview(scrollView)
    
    scrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    scrollView.addSubview(profileImageView)
    
    profileImageView.snp.makeConstraints { make in
      make.top.equalTo(scrollView.snp.top).offset(Constants.topImageViewMultiplier * height)
      make.height.width.equalTo(Constants.widthImageViewMultiplier * width)
      make.centerX.equalToSuperview()
    }
    
    scrollView.addSubview(nameTextField)
    
    nameTextField.snp.makeConstraints { make in
      make.top.equalTo(profileImageView.snp.bottom).offset(25)
      make.centerX.equalToSuperview()
    }
    
    scrollView.addSubview(surnameTextField)
    
    surnameTextField.snp.makeConstraints { make in
      make.top.equalTo(nameTextField.snp.bottom).offset(10)
      make.centerX.equalToSuperview()
    }
    
    scrollView.addSubview(genderLabel)
    
    genderLabel.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(Constants.horizontalPaddingMultiplier * width)
      make.top.equalTo(surnameTextField.snp.bottom).offset(30)
    }
    
    scrollView.addSubview(genderPicker)
    
    genderPicker.snp.makeConstraints { make in
      make.left.equalTo(genderLabel.snp.right).offset(20)
      make.centerY.equalTo(genderLabel.snp.centerY)
    }
    
    scrollView.addSubview(birthDateLabel)
    
    birthDateLabel.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(Constants.horizontalPaddingMultiplier * width)
      make.top.equalTo(genderLabel.snp.bottom).offset(20)
    }
    
    scrollView.addSubview(birthDatePicker)
    
    birthDatePicker.snp.makeConstraints { make in
      make.left.equalTo(birthDateLabel.snp.right).offset(20)
      make.centerY.equalTo(birthDateLabel.snp.centerY)
    }
    
    scrollView.addSubview(interestsLabel)
    
    interestsLabel.snp.makeConstraints { make in
      make.top.equalTo(birthDateLabel.snp.bottom).offset(26)
      make.leading.equalToSuperview().offset(Constants.horizontalPaddingMultiplier * width)
    }
    
    scrollView.addSubview(interestCollectionView.view)
    
    interestCollectionView.view.snp.makeConstraints { make in
      make.top.equalTo(interestsLabel.snp.bottom).offset(12)
      make.width.equalTo(width - Constants.horizontalPaddingMultiplier * 2 * width)
      make.centerX.equalToSuperview()
      make.height.equalTo(200)
      
    }
    
    scrollView.addSubview(toDemoButton)
    
    toDemoButton.snp.makeConstraints { make in
      make.top.equalTo(interestCollectionView.view.snp.bottom).offset(24)
      make.width.equalTo(interestCollectionView.view)
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview().inset(28)
      make.height.equalTo(55)
    }
    
  }
  
}

// MARK: - PHPickerViewControllerDelegate
extension SetupProfileViewController: PHPickerViewControllerDelegate {
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    picker.dismiss(animated: true, completion: nil)
    for result in results {
      result.itemProvider.loadObject(ofClass: UIImage.self) { object, _ in
        if let image = object as? UIImage {
          DispatchQueue.main.async { [weak self] in
            self?.profileImageView.updateImage(with: image)
          }
        }
      }
    }
  }
}


// MARK: - chooseImage observer func
extension SetupProfileViewController {
  
  func chooseImage() {
    present(imagePicker, animated: true, completion: nil)
  }
  
}
