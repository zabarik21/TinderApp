//
//  CardViewProtocol.swift
//  TinderApp
//
//  Created by Timofey on 2/7/22.
//

import RxRelay
import RxSwift


protocol CardViewProtocol: UIView {
  var viewModelRelay: BehaviorRelay<UserCardViewViewModelProtocol?> { get }
  var touchCardObservable: Observable<UserCardViewViewModelProtocol?> { get }
  var swipedObservable: Observable<Bool> { get }
  var isSwipeble: Bool { get }
  
  func swipe(liked: Bool, fromButton: Bool)
}
