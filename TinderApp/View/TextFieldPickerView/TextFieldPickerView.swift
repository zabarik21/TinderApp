//
//  TextFieldPickerView.swift
//  TinderApp
//
//  Created by Timofey on 13/7/22.
//

import UIKit


class TextFieldPickerView: UITextField {
  
  private var pickerView: UIPickerView!
  private let options: [String]
  
  init(with options: [String]) {
    self.options = options
    super.init(frame: .zero)
    setupPickerView()
    self.inputView = pickerView
    self.textAlignment = .center
    self.borderStyle = .roundedRect
    self.textColor = .black
    self.placeholder = "Gender"
  }
  
  private func setupPickerView() {
    pickerView = UIPickerView()
    pickerView.dataSource = self
    pickerView.delegate = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension TextFieldPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return options[row]
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return self.options.count
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    self.text = options[row]
    self.resignFirstResponder()
  }
  
}
