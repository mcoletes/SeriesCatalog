//
//  SeriesListAPI.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 27/05/22.
//

import Foundation
import Combine

protocol SeriesListAPIProtocol {
  func fetchSeries(page: Int) async throws -> [Series]
  func searchSeries(query: String) async throws -> [Series]
}

class SeriesListAPI: SeriesListAPIProtocol {
  
  private var networkProvider: NetworkProviderProtocol
  
  init( networkProvider: NetworkProviderProtocol = NetworkProvider()) {
    self.networkProvider = networkProvider
  }
    
  func fetchSeries(page: Int) async throws -> [Series] {
    return try await networkProvider.fetch(provider: SeriesGenericProvider(page: page))
  }
  
  func searchSeries(query: String) async throws -> [Series] {
    return try await networkProvider.fetch(provider: SeriesGenericProvider(query: query))
  }
}

struct SeriesGenericProvider: URLRequestProtocol {
  var path: String = "shows"
  var httpMethod: HTTPMethod = .get
  var urlParameters: [URLQueryItem]
  
  init(query: String) {
    urlParameters = [URLQueryItem(name: "q", value: query)]
  }
  init(page: Int) {
    urlParameters = [URLQueryItem(name: "page", value: "\(page)")]
  }
}

