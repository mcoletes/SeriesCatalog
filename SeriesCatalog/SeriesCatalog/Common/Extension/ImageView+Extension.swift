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
    sd_imageIndicator = SDWebImageActivityIndicator.gray
    sd_setImage(with: url)
  }
}
