//
//  ReactionButtonsViewProtocol.swift
//  TinderApp
//
//  Created by Timofey on 4/7/22.
//

import UIKit

protocol ReactionButtonsViewProtocol: UIView {
  var delegate: ReactionViewDelegate? { get set }
}
