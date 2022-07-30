//
//  PeopleViewController.swift
//  TinderApp
//
//  Created by Timofey on 27/5/22.
//

import UIKit
import SnapKit
import RxSwift

enum PeopleVCConstants {
  static var cardContainerHeightMultiplier: CGFloat = 0.553
  static var cardDisappearTime: CGFloat = 0.1
  static var cardContainerHorizontalOffsetMultiplier: CGFloat = 0.0986
  static var buttonsHorizontalOffsetMultiplier: CGFloat = 0.24
  static var buttonsBottomOffsetMultiplier: CGFloat = 0.141
  static var ovalHeightMultiplier: CGFloat = 0.385
  static var ovalWidthMultiplier: CGFloat = 1.289
}

class PeopleViewController: UIViewController {
  
  var cardContainer: CardContainerViewProtocol!
  var reactionsView: ReactionButtonsViewProtocol!
  var titleLabel: UILabel!
  let headerOvalLayerMask = CAShapeLayer()
  var gradientLayer: CAGradientLayer!
  var userView: UserViewProtocol!
  var user: UserCardModel
  
  var bag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupElements()
    setupConstraints()
  }
  
  init(user: UserCardModel) {
    self.user = user
    StorageService.shared.saveUser(user: user)
    super.init(nibName: nil, bundle: nil)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    actualizePath()
  }
  
  private func setupObservers() {
    userView.hideUserViewObservable
      .subscribe { [weak self] _ in
        self?.hideUserView()
      }
      .disposed(by: bag)
    
    userView.reactionsObservable
      .subscribe { [weak self] event in
      guard let reaction = event.element else { return }
      self?.reacted(reaction: reaction)
      }
      .disposed(by: bag)
    
    reactionsView.reactedObservable
      .subscribe { [weak self] event in
      guard let reaction = event.element else { return }
      self?.reacted(reaction: reaction)
      }
      .disposed(by: bag)
    
    cardContainer.cardTouchObservable
      .subscribe { [weak self] viewModel in
        self?.cardTouched(with: viewModel)
      }
      .disposed(by: bag)
    
    cardContainer.viewModel?.userLoadObservable
      .subscribe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] status in
        if status {
          self?.cardContainer.fillCards()
        } else {
          // temporary descision
          self?.showAlert(title: "Some error occured", message: "Failed to load users")
        }
      })
      .disposed(by: bag)
  }
  
  func reacted(reaction: Reaction) {
    let liked = reaction == .like ? true : false
    cardContainer.reacted(liked: liked)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Setup Constraints and Elements
extension PeopleViewController {
  private func setupConstraints() {
    
    let height = self.view.bounds.height
    let width = self.view.bounds.width
    
    let titleVisible = height > 600 ? true : false
    
    if titleVisible {
      view.addSubview(titleLabel)

      titleLabel.snp.makeConstraints { make in
        make.top
          .equalToSuperview()
          .offset(70)
        make.leading
          .equalToSuperview()
          .offset(PeopleVCConstants.cardContainerHorizontalOffsetMultiplier * width)
      }
    }
    
    
    view.addSubview(reactionsView)
    
    let tabBarFrame = self.tabBarController!.tabBar.frame
    reactionsView.snp.makeConstraints { make in
      make.bottom
        .equalTo(tabBarFrame.origin.y)
        .offset(-height * PeopleVCConstants.buttonsBottomOffsetMultiplier)
      make.horizontalEdges
        .equalToSuperview()
        .inset(PeopleVCConstants.buttonsHorizontalOffsetMultiplier * width)
      make.height.equalTo(75)
    }
    
    view.addSubview(cardContainer)
    
    cardContainer.snp.makeConstraints { make in
      make.height
        .equalTo(Int(PeopleVCConstants.cardContainerHeightMultiplier * (titleVisible ? 1 : 1.1) * height))
      make.horizontalEdges.equalToSuperview().inset(CardContainerConstants.horizontalCardOffset * width)
      make.bottom.equalTo(reactionsView.snp.top).offset(-30)
    }
    
    view.addSubview(userView)
    
    userView.snp.makeConstraints { make in
      make.horizontalEdges.equalToSuperview()
      make.height.equalToSuperview()
      make.top.equalTo(view.snp.bottom).offset(0)
    }
  }
  
  private func setupElements() {
    view.backgroundColor = UIColor.peopleViewControllerBackground
    setupHeaderOvalLayer()
    setupReactionsView()
    setupCardContainer()
    setupTitleLabel()
    setupUserView()
    setupObservers()
  }
  
  private func setupUserView() {
    userView = UserView(user: self.user)
    userView.alpha = 0
  }
  
  private func setupTitleLabel() {
    titleLabel = UILabel(text: "People Nearby", fontSize: 30, weight: .bold, textColor: .peopleViewControllerBackground)
  }
  
  private func setupReactionsView() {
    reactionsView = ReactionButtonsView()
  }
  
  private func setupCardContainer() {
    // let cachedUsers = ...
    let viewModel = CardContainerViewViewModel(users: [], user: self.user)
    cardContainer = CardContainerView()
    cardContainer.viewModel = viewModel
  }
}
