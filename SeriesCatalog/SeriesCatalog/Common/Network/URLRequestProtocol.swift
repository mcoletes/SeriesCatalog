//
//  URLRequestProtocol.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 27/05/22.
//

import Foundation

enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case patch = "PATCH"
  case delete = "DELETE"
}

// MARK: - Protocol
protocol URLRequestProtocol {
  var baseURL: String { get }
  var path: String { get }
  var httpMethod: HTTPMethod { get }
  var headers: [String: String] { get }
  var urlParameters: [URLQueryItem] { get }
  var bodyParameters: [String: Any] { get }
  var timeOut: TimeInterval { get }
  func asURLRequest() -> URLRequest?
}

extension URLRequestProtocol {
  
  var baseURL: String {
    return "https://api.tvmaze.com/"
  }
  
  var headers: [String: String] {
    return [:]
  }
  var urlParameters: [URLQueryItem] {
    return []
  }
  var bodyParameters: [String: Any] {
    return [:]
  }
  var timeOut: TimeInterval {
    return 30
  }
  
  // MARK: - Instance Methods
  
  func asURLRequest() -> URLRequest? {
    
    guard let url = URL(string: "\(baseURL)\(path)") else { return nil }
    
    var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
    if var queryItems = urlComponents?.queryItems {
      queryItems.append(contentsOf: urlParameters)
      urlComponents?.queryItems = queryItems
    } else {
      urlComponents?.queryItems = urlParameters
    }
    
    var urlRequest = URLRequest(url: urlComponents?.url ?? url)
    
    if !bodyParameters.isEmpty {
      let httpBodyParameters = try? JSONSerialization.data(withJSONObject: bodyParameters, options: [])
      urlRequest.httpBody = httpBodyParameters
    }
    
    headers.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
    urlRequest.httpMethod = httpMethod.rawValue
    urlRequest.timeoutInterval = timeOut
    
    return urlRequest
  }
}

