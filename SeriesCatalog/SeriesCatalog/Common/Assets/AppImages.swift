//
//  Image.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 27/05/22.
//

import UIKit

/// All colors added to the colors asset should be added here also, so we can use on ViewCode as well
enum AppSystemImages: String {
  case loading = "photo.on.rectangle.angled"
}

extension UIImage {
  static func image(name: AppSystemImages) -> UIImage? {
    return UIImage(systemName: name.rawValue)?.withTintColor(.label, renderingMode: .alwaysOriginal)
  }
}
