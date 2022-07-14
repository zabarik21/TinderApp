//
//  PVC + CardContainerObserver functions.swift
//  TinderApp
//
//  Created by Timofey on 2/7/22.
//

import Foundation
import UIKit


extension PeopleViewController  {
  func showNetworkErrorAlert(with message: String) {
      let alertController = UIAlertController(title: "Some error occured",
                                              message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alertController.addAction(okAction)
    DispatchQueue.main.async {
      self.present(alertController, animated: true, completion: nil)
    }
  }
  
  func usersLoaded() {
    cardContainer.fillCards()
  }
}
