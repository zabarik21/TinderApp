//
//  UserInfoViewController.swift
//  TinderApp
//
//  Created by Timofey on 25/6/22.
//

import UIKit
import RxRelay
import RxSwift

enum Constants {
  static var imageViewHeightMultiplier: CGFloat = 0.63
  static var infoViewCornerRadius: CGFloat = 30
  static var horizontalPaddingMultiplier: CGFloat = 0.064
  static var horizontalReactiovViewPaddingMultiplier: CGFloat = 0.24
  static var viewDissappearTime: TimeInterval = 0.3
}

class UserView: UIView, UserViewProtocol {
  
  private var userImageView: UIImageView!
  private var infoViewContainer: UIView!
  private var interestLabel: UILabel!
  private var similarInterestLabel: UILabel!
  private var interestsLabelsStackView: UIStackView!
  private var interestsCollectionView: InterestsCollectionViewController!
  private var reactionView: ReactionButtonsView!
  private var userInfoView: UserInfoView!
  private var scrollView: UIScrollView!
  
  private var hideUserViewPublishRelay  =  PublishRelay<Void>()
  private var reactionsPublishRelay = PublishRelay<Reaction>()
  private var bag = DisposeBag()
  
  var hideUserViewObservable: Observable<Void> {
    return hideUserViewPublishRelay.asObservable()
  }
  
  var reactionsObservable: Observable<Reaction> {
    return reactionsPublishRelay
      .delay(.milliseconds(300), scheduler: MainScheduler.instance)
      .asObservable()
  }
  
  var viewModel: UserCardViewViewModelProtocol? {
    didSet {
      fillUI()
    }
  }
  
  var viewHieght: CGFloat!
  
  var flag = true
  var user: UserCardModel
  
  init(user: UserCardModel) {
    self.user = user
    super.init(frame: .zero)
    setupElements()
    setupGestures()
    setupObserver()
  }
  
  private func setupObserver() {
    reactionView.reactedObservable.subscribe { [weak self] event in
      guard let reaction = event.element else { return }
      self?.hideUserViewPublishRelay.accept(())
      self?.reactionsPublishRelay.accept(reaction)
    }.disposed(by: bag)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    viewHieght = self.bounds.height
    if flag {
      setupConstraints()
      flag.toggle()
    }
  }
  
  func fillUI() {
    if let viewModel = viewModel {
      let url = URL(string: viewModel.imageUrlString)
      DispatchQueue.main.async {
        self.userImageView.kf.setImage(with: url,
                                       options: [
                                        .transition(.fade(0.2))
                                       ])
        self.similarInterestLabel.text = "\(viewModel.similarInterestsCount) Similar"
        self.userInfoView.viewModel = viewModel.userInfoViewViewModel
        self.updateInterestsView()
      }
    } else {
      DispatchQueue.main.async {
        self.userImageView.image = .userPlaceholderImage
        self.userInfoView.viewModel = nil
      }
    }
  }
  
  func reacted(reaction: Reaction) {
    
   
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Setup Elements & Constraints
// remove uiscrollview deleagte
extension UserView: UIScrollViewDelegate {
  
  private func setupElements() {
    setupUserImageView()
    setupInfoViewContainer()
    setupScrollView()
    setupLabels()
    setupReactionView()
    setupUserInfoView()
    setupInterestView()
    fillUI()
    self.backgroundColor = .peopleViewControllerBackground
  }
  
  private func setupScrollView() {
    scrollView = UIScrollView()
    scrollView.delegate = self
    scrollView.showsVerticalScrollIndicator = false
  }
  
  private func updateInterestsView() {
    let array = viewModel?.interests.map({ i in
      return (i, user.interests!.contains(i))
    }) ?? []
    interestsCollectionView.interests = array
  }
  
  private func setupUserInfoView() {
    userInfoView = UserInfoView()
    userInfoView.changeCompatabilityLabelTextColor(with: .black)
  }
  
  private func setupInterestView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumInteritemSpacing = 15
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    
    interestsCollectionView = InterestsCollectionViewController(collectionViewLayout: layout)
  }
  
  private func setupReactionView() {
    reactionView = ReactionButtonsView()
  }
  
  private func setupLabels() {
    interestLabel = UILabel(text: "Interests", fontSize: 18, weight: .bold, textColor: .black)
    similarInterestLabel = UILabel(text: "0 Similar", fontSize: 14, weight: .bold, textColor: .firstGradientColor.withAlphaComponent(0.6))
  }
  
  private func setupUserImageView() {
    userImageView = UIImageView()
    userImageView.contentMode = .scaleAspectFill
  }
  
  private func setupInfoViewContainer() {
    infoViewContainer = UIView()
    infoViewContainer.backgroundColor = UIColor.peopleViewControllerBackground
    infoViewContainer.layer.cornerRadius = Constants.infoViewCornerRadius
  }
  
  private func setupConstraints() {
    let imageHeight = Constants.imageViewHeightMultiplier * self.bounds.height
    
    self.addSubview(userImageView)
    userImageView.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
      make.height.equalTo(imageHeight)
    }
    
    addSubview(infoViewContainer)
    infoViewContainer.snp.makeConstraints { make in
      make.top.equalTo(userImageView.snp.bottom).offset(-Constants.infoViewCornerRadius)
      make.bottom.equalToSuperview().offset(Constants.infoViewCornerRadius)
      make.horizontalEdges.equalToSuperview()
    }
    
    infoViewContainer.addSubview(scrollView)
    
    scrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.centerY.equalToSuperview()
      make.centerX.equalToSuperview()
    }
    
    scrollView.addSubview(userInfoView)
    
    userInfoView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(26)
      make.horizontalEdges.equalToSuperview().inset(Constants.horizontalPaddingMultiplier * self.bounds.width)
      make.width.equalToSuperview().offset(-Constants.horizontalPaddingMultiplier * self.bounds.width * 2)
      make.height.equalTo(70)
    }
    
    interestsLabelsStackView = UIStackView(arrangedSubviews: [interestLabel, similarInterestLabel])
    interestsLabelsStackView.axis = .horizontal
    interestsLabelsStackView.alignment = .center
    interestsLabelsStackView.distribution = .fill
    
    scrollView.addSubview(interestsLabelsStackView)
    interestsLabelsStackView.snp.makeConstraints { make in
      make.top.equalTo(userInfoView.snp.bottom).offset(30)
      make.horizontalEdges.equalToSuperview().inset(Constants.horizontalPaddingMultiplier * self.bounds.width)
    }
    
    scrollView.addSubview(interestsCollectionView.view)
    interestsCollectionView.view.snp.makeConstraints { make in
      make.top.equalTo(interestsLabelsStackView.snp.bottom).offset(18)
      make.horizontalEdges.equalToSuperview().inset(Constants.horizontalPaddingMultiplier * self.bounds.width)
      make.height.equalTo(60)
    }
    
    scrollView.addSubview(reactionView)
    reactionView.snp.makeConstraints { make in
      make.top.equalTo(interestsCollectionView.view.snp.bottom).offset(24)
      make.horizontalEdges.equalToSuperview().inset(Constants.horizontalReactiovViewPaddingMultiplier * self.bounds.width)
      make.height.equalTo(75)
      make.bottom.equalTo(-20)
    }
  }
  
  func toIdentity() {
    self.interestsCollectionView.collectionView.setContentOffset(.zero, animated: false)
    scrollView.setContentOffset(.zero, animated: false)
  }
}


// MARK: - UIGestureRecognizerDelegate
extension UserView: UIGestureRecognizerDelegate {
  
  private func setupGestures() {
    let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    gestureRecognizer.delegate = self
    addGestureRecognizer(gestureRecognizer)
  }
  
  @objc private func handlePan(_ recognizer: UIPanGestureRecognizer) {
    let velocity = recognizer.velocity(in: self)
    switch recognizer.state {
    case .began:
      break
    case .changed:
      onChange(recognizer)
    case .ended:
      gestureEnded(with: velocity.y)
      break
    @unknown default:
      print("oknown")
    }
  }
  
  private func onChange(_ recognizer: UIPanGestureRecognizer) {
    let translation = recognizer.translation(in: self)
    if (frame.minY <= 0 && translation.y < 0) { return }
    guard let gestureView = recognizer.view else { return }
    let yDelta = center.y
    gestureView.center = CGPoint(x: center.x,
                                 y: yDelta + translation.y)
    recognizer.setTranslation(.zero, in: self)
  }
  
  private func gestureEnded(with velocity: CGFloat) {
    if velocity > 1000 || frame.minY > (self.viewHieght / 3) {
      self.hideUserViewPublishRelay.accept(())
    } else {
      UIView.animate(withDuration: Constants.viewDissappearTime) {
        self.center.y = self.viewHieght / 2
      }
    }
  }
  
}
