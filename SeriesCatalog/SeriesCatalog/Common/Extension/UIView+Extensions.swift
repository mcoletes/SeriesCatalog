//
//  UIView+Extensions.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 28/05/22.
//

import UIKit

extension UIView {
  func addShadowAndCornerRadius(
    cornerRadius: CGFloat = 16,
    shadowColor: UIColor = UIColor(white: 0.0, alpha: 0.5),
    shadowOffset: CGSize = CGSize(width: 0.0, height: 3.0),
    shadowOpacity: Float = 0.3,
    shadowRadius: CGFloat = 5) {
      
      layer.cornerRadius = cornerRadius
      layer.shadowColor = shadowColor.cgColor
      layer.shadowOffset = shadowOffset
      layer.shadowOpacity = shadowOpacity
      layer.shadowRadius = shadowRadius
    }
  
  func addCornerRadius(_ radius: CGFloat = 4) {
    layer.cornerRadius = radius
    layer.masksToBounds = true
  }
}
