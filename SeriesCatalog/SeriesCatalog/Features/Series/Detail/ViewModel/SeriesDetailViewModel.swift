//
//  SeriesDetailViewModel.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 28/05/22.
//

import Foundation


protocol SeriesDetailViewModelProtocol {
  var statePublisher: Published<SeriesDetailState>.Publisher { get }
  func load()
}

class SeriesDetailViewModel: SeriesDetailViewModelProtocol {
  @Published var state: SeriesDetailState = .none
  var statePublisher: Published<SeriesDetailState>.Publisher { $state }
  
  let id: Int
  let listAPI: SeriesListAPIProtocol
  
  init(id: Int, listAPI: SeriesListAPIProtocol = SeriesListAPI()) {
    self.id = id
    self.listAPI = listAPI
  }
  
  func load() {
    state = .loading
    Task {
      do {
        let seriesDetail = try await listAPI.fetchSeriesDetail(id: id)
        let model = SeriesDetailModels.Model(seriesDetail: seriesDetail)
        print(model)
        state = .loaded(model)
      } catch let error as ServiceError {
        print(error)
      }
    }
  }
}

