//
//  ImageView+Extension.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 29/05/22.
//

import UIKit
import SDWebImage

extension UIImageView {
  func sdLoad(with url: URL?) {
    let indicator: SDWebImageActivityIndicator = traitCollection.userInterfaceStyle == .dark ? .white : .gray
    sd_imageIndicator = indicator
    sd_setImage(with: url)
  }
}
