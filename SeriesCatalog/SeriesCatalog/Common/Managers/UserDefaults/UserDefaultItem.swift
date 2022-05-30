//
//  UserDefaultItem.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 30/05/22.
//

import Foundation

class UserDefaultsItem<T: Codable> {
  let defaults = UserDefaults.standard
  let key: String

  init(_ key: String) {
    self.key = key
  }

  func get() -> T? {
    guard
      let data = defaults.object(forKey: key) as? Data
    else {
      return nil
    }
    do {
      let value = try JSONDecoder().decode(T.self, from: data)
      return value
    } catch let error {
      print(error)
      return nil
    }
  }

  func set(_ value: T?) {
    do {
      let value = try JSONEncoder().encode(value)
      defaults.set(value, forKey: key)
    } catch let error {
      print(error)
      return
    }
  }
}
