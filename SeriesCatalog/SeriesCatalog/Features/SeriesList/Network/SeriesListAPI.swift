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
  func searchSeries(query: String) async throws -> [SearchResult]
}

class SeriesListAPI: SeriesListAPIProtocol {
  
  private var networkProvider: NetworkProviderProtocol
  
  init( networkProvider: NetworkProviderProtocol = NetworkProvider()) {
    self.networkProvider = networkProvider
  }
    
  func fetchSeries(page: Int) async throws -> [Series] {
    return try await networkProvider.fetch(provider: SeriesListProvider(page: page))
  }
  
  func searchSeries(query: String) async throws -> [SearchResult] {
    return try await networkProvider.fetch(provider: SeriesSearchProvider(query: query))
  }
}

struct SeriesListProvider: URLRequestProtocol {
  var path: String = "shows"
  var httpMethod: HTTPMethod = .get
  var urlParameters: [URLQueryItem]
  
  init(page: Int) {
    urlParameters = [URLQueryItem(name: "page", value: "\(page)")]
  }
}

struct SeriesSearchProvider: URLRequestProtocol {
  var path: String = "search/shows"
  var httpMethod: HTTPMethod = .get
  var urlParameters: [URLQueryItem]
  
  init(query: String) {
    urlParameters = [URLQueryItem(name: "q", value: query)]
  }
}

