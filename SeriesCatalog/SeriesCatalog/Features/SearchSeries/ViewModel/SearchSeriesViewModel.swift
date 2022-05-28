//
//  SearchSeriesViewModel.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 28/05/22.
//

import Foundation

enum SeriesSearchState {
  case none
  case loading
  case loaded([SeriesListCellModel])
  case empty
  case error
}

protocol SearchSeriesViewModelProtocol {
  var statePublisher: Published<SeriesSearchState>.Publisher { get }
  func search(text: String)
}

class SearchSeriesViewModel: SearchSeriesViewModelProtocol {
  
  @Published var state: SeriesSearchState = .none
  var statePublisher: Published<SeriesSearchState>.Publisher { $state }
  let listAPI: SeriesListAPIProtocol
  var fetching = false
  init(listAPI: SeriesListAPIProtocol = SeriesListAPI()) {
    self.listAPI = listAPI
  }
  
  func search(text: String) {
    guard !fetching else { return }
    fetching = true
    Task {
      do {
        guard let series = try? await listAPI.searchSeries(query: text.lowercased()) else { return }
        let models = series.map({SeriesListCellModel(series: $0.show)})
        state = .loaded(models)
        fetching = false
      } catch let error as ServiceError {
        print(error)
      }
    }
  }
}
