//
//  UITableView+Register.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 27/05/22.
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

extension UITableView {
  
  func register<T: UITableViewCell>(_: T.Type) where T: ReusableView {
    register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
  }
  
  func register<T: UITableViewCell>(_: T.Type) where T: ReusableView, T: NibLoadableView {
    let bundle = Bundle(for: T.self)
    let nib = UINib(nibName: T.nibName, bundle: bundle)
    register(nib, forCellReuseIdentifier: T.defaultReuseIdentifier)
  }
  
  func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T? where T: ReusableView {
    guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
      print("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
      return nil
    }
    
    return cell
  }
  
  func registerHeaderAndFooter<T>(_: T.Type) where T: UITableViewHeaderFooterView, T: ReusableView {
    register(T.self, forHeaderFooterViewReuseIdentifier: T.defaultReuseIdentifier)
  }
  
  func registerHeaderAndFooter<T>(_: T.Type) where T: UITableViewHeaderFooterView, T: ReusableView, T: NibLoadableView {
    let bundle = Bundle(for: T.self)
    let nib = UINib(nibName: T.nibName, bundle: bundle)
    register(nib, forHeaderFooterViewReuseIdentifier: T.defaultReuseIdentifier)
  }
  
  func dequeueReusableHeaderFooterView<T>() -> T? where T: ReusableView {
    guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.defaultReuseIdentifier) as? T else {
      print("Could not dequeue header view with identifier: \(T.defaultReuseIdentifier)")
      return nil
    }
    return view
  }
}
