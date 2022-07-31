//
//  MatchView.swift
//  TinderApp
//
//  Created by Timofey on 30/7/22.
//

import UIKit
import RxSwift
import RxRelay
import Kingfisher


class MatchView: UIView, MovableView {
  
  private let bag = DisposeBag()
  
  var hideViewPublishRelay = PublishRelay<Void>()
  
  var hideViewObservable: Observable<Void> {
    return hideViewPublishRelay.asObservable()
  }
  
  private enum Constants {
    static let horizontalMargin: CGFloat = 0.056
    static let centerYMarginMult: CGFloat = 0.0000101477832512
  }
  
  var viewModelRelay = PublishRelay<MatchViewViewModel>()
  
  private var matchLabel: UILabel!
  private var matchInfoLabel: UILabel!
  
  private var compatabilityView: CompatabilityView!
  
  private var firstUserImageView: UIImageView!
  private var secondUserImageView: UIImageView!
  
  private var messageButton: StartScreenButton!
  private var keepSwipingButton: StartScreenButton!
  
  private var gradientLayer: CAGradientLayer!
  
  var viewHieght: CGFloat!
  
  private var firstLaunch = true
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let cornerRadius = firstUserImageView.bounds.height / 2
    firstUserImageView.layer.cornerRadius = cornerRadius
    secondUserImageView.layer.cornerRadius = cornerRadius
    gradientLayer.frame = self.bounds
    viewHieght = self.bounds.height
    if firstLaunch {
      setupConstraints()
      firstLaunch.toggle()
    }
  }
  
  init() {
    super.init(frame: .zero)
    setupElements()
    setupGestures(action: #selector(handlePan))
    setupObserver()
    setupButtonTargets()
  }
  
  private func setupButtonTargets() {
    keepSwipingButton.addTarget(self, action: #selector(keepSwiping), for: .touchUpInside)
  }
  
  @objc func keepSwiping() {
    hideViewPublishRelay.accept(())
  }
  
  private func setupObserver() {
    viewModelRelay
      .subscribe(onNext: { [weak self] viewModel in
        self?.updateUI(with: viewModel)
      })
      .disposed(by: bag)
  }
  
  private func updateUI(with viewModel: MatchViewViewModel) {
    DispatchQueue.main.async {
      let fstUrl = URL(string: viewModel.userImageUrlString)
      let sndUrl = URL(string: viewModel.friendImageUrlString)
      self.firstUserImageView.kf.setImage(with: fstUrl)
      self.secondUserImageView.kf.setImage(with: sndUrl)
      self.matchInfoLabel.text = "You and \(viewModel.friendName) have liked each other."
      self.compatabilityView.compatability = viewModel.compatabilityScore
    }
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension MatchView {
  private func setupElements() {
    setupBG()
    setupLabels()
    setupImageViews()
    setupCompatabilityView()
    setupButtons()
  }
  
  private func setupImageViews() {
    firstUserImageView = UIImageView()
    secondUserImageView = UIImageView()
    for imageView in [firstUserImageView, secondUserImageView] {
      imageView!.layer.borderWidth = 4
      imageView!.layer.borderColor = UIColor.white.cgColor
      imageView!.image = .userPlaceholderImage
      imageView!.layer.masksToBounds = true
      imageView!.contentMode = .scaleAspectFit
      imageView!.backgroundColor = .white
    }
  }
  
  private func setupButtons() {
    messageButton = StartScreenButton(with: .light, title: "Message her")
    keepSwipingButton = StartScreenButton(with: .dark, title: "Keep swiping")
  }
  
  private func setupCompatabilityView() {
    compatabilityView = CompatabilityView()
    compatabilityView.lightenBackground()
    compatabilityView.compatability = 10
    compatabilityView.layer.zPosition = 1
  }
  
  private func setupLabels() {
    matchLabel = UILabel(
      text: "It's a match!",
      fontSize: 36,
      weight: .bold,
      textColor: .peopleViewControllerBackground)
    matchInfoLabel = UILabel(
      text: "You liked each other",
      fontSize: 20,
      weight: .regular,
      textColor: .peopleViewControllerBackground)
    matchInfoLabel.numberOfLines = 0
    matchInfoLabel.textAlignment = .center
  }
  
  private func setupBG() {
    gradientLayer = LayerFactory.shared.getGradientLayer()
    gradientLayer.frame = self.bounds
    layer.insertSublayer(gradientLayer, at: 0)
  }
  
  private func setupConstraints() {
    
    addSubview(matchLabel)
    
    matchLabel.snp.makeConstraints { make in
      make.centerY
        .equalToSuperview()
        .offset(-130)
      make.centerX.equalToSuperview()
    }
    
    addSubview(matchInfoLabel)
    
    matchInfoLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top
        .equalTo(matchLabel.snp.bottom)
        .offset(25)
      make.horizontalEdges
        .equalToSuperview()
        .inset(self.bounds.width * Constants.horizontalMargin)
    }
    
    addSubview(compatabilityView)
    
    compatabilityView.snp.makeConstraints { make in
      make.top
        .equalTo(matchInfoLabel.snp.bottom)
        .offset(60)
      make.height.width.equalTo(70)
      make.centerX.equalToSuperview()
    }
    
    addSubview(firstUserImageView)
    
    firstUserImageView.snp.makeConstraints { make in
      make.height.width.equalTo(92)
      make.trailing
        .equalTo(compatabilityView.snp.leading)
        .offset(22)
      make.centerY.equalTo(compatabilityView)
    }
    
    addSubview(secondUserImageView)
    
    secondUserImageView.snp.makeConstraints { make in
      make.height.width.equalTo(92)
      make.leading
        .equalTo(compatabilityView.snp.trailing)
        .offset(-22)
      make.centerY.equalTo(compatabilityView)
    }
    
    let buttonsStackView = UIStackView(arrangedSubviews: [
      messageButton,
      keepSwipingButton
    ])
    
    buttonsStackView.axis = .vertical
    buttonsStackView.spacing = 11
    buttonsStackView.distribution = .fillEqually
    
    addSubview(buttonsStackView)
    
    buttonsStackView.snp.makeConstraints { make in
      make.horizontalEdges
        .equalToSuperview()
        .inset(self.bounds.width * Constants.horizontalMargin)
      make.bottom.equalToSuperview().inset(35)
    }
    
    messageButton.snp.makeConstraints { make in
      make.height.equalTo(56)
    }
    
    keepSwipingButton.snp.makeConstraints { make in
      make.height.equalTo(56)
    }
  }
}

extension MatchView {
  
  func toIdentity() {
    return
  }
  
  @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
    let velocity = recognizer.velocity(in: self)
    switch recognizer.state {
    case .began, .possible, .cancelled, .failed:
      break
    case .changed:
      onChange(recognizer)
    case .ended:
      gestureEnded(with: velocity.y)
    @unknown default:
      print("oknown")
    }
  }
  
}
