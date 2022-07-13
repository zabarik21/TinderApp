//
//  ReactionButtonsViewProtocol.swift
//  TinderApp
//
//  Created by Timofey on 4/7/22.
//

import UIKit
import RxSwift

protocol ReactionButtonsViewProtocol: UIView {
  var reactedObservable: Observable<Reaction> { get }
}
