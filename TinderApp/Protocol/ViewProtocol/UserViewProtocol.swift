//
//  UserViewProtocol.swift
//  TinderApp
//
//  Created by Timofey on 1/7/22.
//

import UIKit
import RxRelay
import RxSwift


protocol UserViewProtocol: MovableView {
  var viewModel: BehaviorRelay<UserCardViewViewModelProtocol?> { get }
  var reactionsObservable: Observable<Reaction> { get }
  
  func toIdentity()
}
