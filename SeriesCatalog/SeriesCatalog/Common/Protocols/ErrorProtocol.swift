//
//  ErrorProtocol.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 28/05/22.
//

import Foundation
import UIKit

typealias Action = (() -> Void?)

protocol ErrorProtocol {
  func showError(title: String, message: String, action: @escaping Action)
}

extension ErrorProtocol where Self: UIViewController {
  func showError(title: String, message: String, action: @escaping Action) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    let retryAction = UIAlertAction(title: "Retry", style: .default, handler: { _ in
      action()
    })
    alertController.addAction(retryAction)
    alertController.addAction(cancelAction)
    present(alertController, animated: true)
  }
}
