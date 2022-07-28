//
//  DateFormatter.swift
//  TinderApp
//
//  Created by Timofey on 28/7/22.
//

import Foundation

class CustomDateFormatter {
  
  static let shared = CustomDateFormatter()
  
  private var formatter: DateFormatter
  
  private init() {
    formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    formatter.dateFormat = "dd/MM/yyyy"
//    formatter.locale = Locale(identifier: "ja_JP")
  }
  
  func getFormattedString(_ date: Date) -> String {
    return formatter.string(from: date)
  }
  
  func yearsBetweenDate(startDate: Date, endDate: Date = .now) -> Int {
      let calendar = Calendar.current
      let components = calendar.dateComponents([.year], from: startDate, to: endDate)
      return components.year!
  }
  
}
