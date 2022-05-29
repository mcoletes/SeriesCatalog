//
//  SearchSeriesViewModel.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 28/05/22.
//

import Foundation


protocol SearchSeriesViewModelProtocol {
  var statePublisher: Published<RegularStates<[SeriesListCellModel]>>.Publisher { get }
  func search(text: String)
  func getId(for row: Int) -> Int?
}

class SearchSeriesViewModel: SearchSeriesViewModelProtocol, RegularStateViewModelProtocol {
  
  @Published var state: RegularStates<[SeriesListCellModel]> = .idle
  var statePublisher: Published<RegularStates<[SeriesListCellModel]>>.Publisher { $state }
  
  let listAPI: SeriesAPI
  private var fetching = false
  var series: [Series] = []
  private var searchedText = ""
  init(listAPI: SeriesAPI = SeriesAPI()) {
    self.listAPI = listAPI
  }
  
  func search(text: String) {
    guard !fetching else { return }
    state = .loading
    searchedText = text
    fetching = true
    Task {
      do {
        let searchResults = try await listAPI.searchSeries(query: text.lowercased())
        series = searchResults.map({ $0.show })
        let models = series.map({SeriesListCellModel(series: $0)})
        state = .success(models)
        fetching = false
      } catch let error as ServiceError {
        state = .error(error, searchRetry)
        fetching = false
      }
    }
  }
  
  private func searchRetry() {
    search(text: searchedText)
  }
  
  func getId(for row: Int) -> Int? {
    guard row < series.count else { return nil }
    return series[row].id
  }
}
