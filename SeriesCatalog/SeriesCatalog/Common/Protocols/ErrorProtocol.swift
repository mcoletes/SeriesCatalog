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
  func showError(serviceError: ServiceError, action: @escaping Action)
}

extension ErrorProtocol where Self: UIViewController {
  func showError(serviceError: ServiceError, action: @escaping Action) {
    let alertController = UIAlertController(title: serviceError.title,
                                            message: "Request Failed. Reason:\n\(serviceError.localizedDescription)",
                                            preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    let retryAction = UIAlertAction(title: "Retry", style: .default, handler: { _ in
      action()
    })
    alertController.addAction(retryAction)
    alertController.addAction(cancelAction)
    present(alertController, animated: true)
  }
}
