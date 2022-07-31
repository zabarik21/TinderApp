//
//  PVC + ObsActions.swift
//  TinderApp
//
//  Created by Timofey on 1/7/22.
//

import UIKit

extension PeopleViewController {
  
  func cardTouched(with viewModel: UserCardViewViewModelProtocol?) {
    userView.viewModel.accept(viewModel)
    showHiddenView(userView)
  }
  
}
