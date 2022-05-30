//
//  RegisterProtocols.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 29/05/22.
//

import UIKit

public protocol ReusableView: AnyObject {
  static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
  public static var defaultReuseIdentifier: String {
    return String(describing: self)
  }
}
public protocol NibLoadableView: AnyObject {
  static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {
  static var nibName: String {
    return String(describing: self)
  }
}
