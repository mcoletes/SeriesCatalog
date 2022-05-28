//
//  Image.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 27/05/22.
//

import UIKit

/// All colors added to the colors asset should be added here also, so we can use on ViewCode as well
enum AppImages: String {
  case loading = "loading"
}

extension UIImage {
  static func image(name: AppImages) -> UIImage? {
    return UIImage(named: name.rawValue)
  }
}
