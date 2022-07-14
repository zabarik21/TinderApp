//
//  UserViewProtocol.swift
//  TinderApp
//
//  Created by Timofey on 1/7/22.
//

import UIKit
import RxRelay
import RxSwift


protocol HideShowView {
  
}

protocol UserViewProtocol: UIView, HideShowView {
  var viewModel: BehaviorRelay<UserCardViewViewModelProtocol?> { get }
  var hideUserViewObservable: Observable<Void> { get }
  var reactionsObservable: Observable<Reaction> { get }
  
  func toIdentity()
}
