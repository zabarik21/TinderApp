//
//  CardViewContainer.swift
//  TinderApp
//
//  Created by Timofey on 30/5/22.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay

enum CardContainerConstants {
  static var topAnchorCardOffset: CGFloat = 5
  static var cardAppearTime: CGFloat = 0.25
  static let horizontalCardOffset: CGFloat = 0.032
  static let bottomCardOffset: CGFloat = 11
  static var minimizedCardHeightDelta: CGFloat = 0
  static var maximizedCardHeightDelta: CGFloat = -4
}


class CardContainerView: UIView, CardContainerViewProtocol {
  
  private var bag = DisposeBag()
  private var cardTouchPublisher = PublishSubject<UserCardViewViewModelProtocol?>()
  
  var topCardUser: UserCardModel? {
    return viewModel.topCardUser()
  }
  
  var cardTouchObservable: Observable<UserCardViewViewModelProtocol?> {
    return cardTouchPublisher.asObservable()
  }
  
  var viewModel: CardContainerViewViewModelProtocol
  
  private var backCardContainer: UIView!
  var bottomCardView: CardViewProtocol!
  var topCardView: CardViewProtocol!
  
  var topCardTurn = true
  
  init(viewModel: CardContainerViewViewModelProtocol) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    setupElements()
    setupObserver()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setupConstraints()
  }
  
  func fillCards() {
    // dont change the order 
    // 1
    if topCardView.viewModelRelay.value == nil {
      let topCardViewModel = viewModel.nextCard()
      topCardView.viewModelRelay.accept(topCardViewModel)
      viewModel.topCardViewModelRelay.accept(topCardViewModel)
    }
    // 2
    if bottomCardView.viewModelRelay.value == nil {
      bottomCardView.viewModelRelay.accept(viewModel.nextCard())
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Setup Observers
extension CardContainerView {
  
  private func setupObserver() {
    
    viewModel.userLoadObservable
      .subscribe(onNext: { [weak self] _  in
        self?.fillCards()
      })
      .disposed(by: bag)
    
    topCardView.swipedObservable
      .subscribe { [weak self] liked in
        self?.swiped(liked: liked)
      }
      .disposed(by: bag)
    
    topCardView.touchCardObservable
      .subscribe(onNext: { [weak self] viewModel in
        self?.cardTouchPublisher.onNext(viewModel)
      })
      .disposed(by: bag)
    
    bottomCardView.touchCardObservable
      .subscribe(onNext: { [weak self] viewModel in
        self?.cardTouchPublisher.onNext(viewModel)
      })
      .disposed(by: bag)
    
    bottomCardView.swipedObservable
      .subscribe { [weak self] liked in
        self?.swiped(liked: liked)
      }
      .disposed(by: bag)
    
    viewModel.userLoadObservable
      .subscribe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] status in
        if status {
          self?.fillCards()
        } else {
          // temporary descision
          AlertService.shared.alertPublisher.accept(
            ("Some error occured",
             "Failed to load users"))
        }
      })
      .disposed(by: bag)
  }
  
}

// MARK: - Setup Elements & UI
extension CardContainerView {
  
  private func setupElements() {
    backgroundColor = .clear
    topCardView = CardView()
    bottomCardView = CardView()
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
  }
}
