//
//  ServiceError.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 27/05/22.
//

import Foundation

enum ServiceError: Error, Equatable {
  case invalidRequest
  case requestFailed(error: String)
  case jsonParsingFailure(error: String)
  case responseUnsuccessful(statusCode: Int)
  case invalidResponse
  
  var localizedDescription: String {
    switch self {
    case .invalidRequest:
      return "Invalid Request"
    case .requestFailed:
      return "Request Failed"
    case .jsonParsingFailure:
      return "JSON Parsing Failure"
    case .responseUnsuccessful:
      return "Response Unsuccessful"
    case .invalidResponse:
      return "Invalid Response"
    }
  }
}
