//
//  StateViewModelProtocol.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 29/05/22.
//

import Foundation
import Combine

protocol StateViewModelProtocol {
  associatedtype State
  var state: State { get set }
}

protocol RegularStateViewModelProtocol {
  associatedtype Model
  var state: RegularStates<Model> { get set }
}

enum RegularStates<T>: Equatable {
  case idle
  case error(ServiceError, Action)
  case loading
  case success(T)
  
  static func == (lhs: RegularStates<T>, rhs: RegularStates<T>) -> Bool {
    switch (lhs, rhs) {
    case (.idle, .idle): return true
    case (.loading, .loading): return true
    case (.error, .error): return true
    case (.success, .success): return true
    default: return false
    }
  }
}
