//
//  PeopleAPI.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 29/05/22.
//

import Foundation
import Combine

protocol PeopleAPIProtocol {
  func searchPeople(query: String) async throws -> [PeopleResult]
  func fetchPersonDetail(id: Int) async throws -> SeriesDetail
}

class PeopleAPI: PeopleAPIProtocol {
  
  private var networkProvider: NetworkProviderProtocol
  
  init( networkProvider: NetworkProviderProtocol = NetworkProvider()) {
    self.networkProvider = networkProvider
  }
  
  func searchPeople(query: String) async throws -> [PeopleResult] {
    return try await networkProvider.fetch(provider: PeopleSearchProvider(query: query))
  }
  
  func fetchPersonDetail(id: Int) async throws -> SeriesDetail {
    return try await networkProvider.fetch(provider: SeriesDetailProvider(id: id))
  }
}

