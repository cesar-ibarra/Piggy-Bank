//
//  Extension.swift
//  Piggy Bank
//
//  Created by Cesar Ibarra on 2/28/25.
//

import Foundation

extension Double {
    var toWeight: String {
        String(format: "%.1f lbs", self)
    }
}

extension Date {
    var formatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
}

func greetingLogic() -> String {
  let hour = Calendar.current.component(.hour, from: Date())
  
  let NEW_DAY = 0
  let NOON = 12
  let SUNSET = 18
  let MIDNIGHT = 24
  
  var greetingText = "Hello" // Default greeting text
  switch hour {
  case NEW_DAY..<NOON:
      greetingText = "Good Morning"
  case NOON..<SUNSET:
      greetingText = "Good Afternoon"
  case SUNSET..<MIDNIGHT:
      greetingText = "Good Evening"
  default:
      _ = "Hello"
  }
  
  return greetingText
}
