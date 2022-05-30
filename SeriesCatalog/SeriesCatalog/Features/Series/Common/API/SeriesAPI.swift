//
//  SeriesListAPI.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 27/05/22.
//

import Foundation
import Combine

protocol SeriesAPIProtocol {
  func fetchSeries(page: Int) async throws -> [Series]
  func searchSeries(query: String) async throws -> [SearchResult]
  func fetchSeriesDetail(id: Int) async throws -> SeriesDetail

}

class SeriesAPI: SeriesAPIProtocol {
  
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
  
  func fetchSeriesDetail(id: Int) async throws -> SeriesDetail {
    return try await networkProvider.fetch(provider: SeriesDetailProvider(id: id))
  }
}
