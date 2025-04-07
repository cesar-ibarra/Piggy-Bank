//
//  Extension.swift
//  Piggy Bank
//
//  Created by Cesar Ibarra on 2/28/25.
//

import Foundation
import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider else { return }

            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        self.parent.selectedImage = image as? UIImage
                    }
                }
            }
        }
    }
}

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
