//
//  UIViewController + UIAlertController.swift
//  TinderApp
//
//  Created by Timofey on 27/7/22.
//

import UIKit

extension UIViewController {
  func showAlert(title: String, message: String) {
    let alertController = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alertController.addAction(okAction)
    DispatchQueue.main.async {
      self.present(alertController, animated: true, completion: nil)
    }
  }
}
