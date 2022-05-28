//
//  SeriesListViewModel.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 27/05/22.
//

import Foundation

enum SeriesListState {
  case none
  case loading
  case loaded([SeriesListCellModel])
  case error
}

protocol SeriesListViewModelProtocol {
  var statePublisher: Published<SeriesListState>.Publisher { get }
  func load()
  func prefetching(row: Int)
}

class SeriesListViewModel: SeriesListViewModelProtocol {
  @Published var state: SeriesListState = .loading
  var statePublisher: Published<SeriesListState>.Publisher { $state }
  let listAPI: SeriesListAPIProtocol
  var page: Int = 0
  var fetching: Bool = false
  let defaultPageSize = 250
  init(listAPI: SeriesListAPIProtocol = SeriesListAPI()) {
    self.listAPI = listAPI
  }
  
  func load() {
    state = .loading
    fetch()
  }
  
  private func fetch() {
    Task {
      do {
        guard let series = try? await listAPI.fetchSeries(page: page) else { return }
        let models = series.map({SeriesListCellModel(series: $0)})
        state = .loaded(models)
        page += 1
        fetching = false
      } catch let error as ServiceError {

      }
    }
  }
  
  func prefetching(row: Int) {
    guard abs(row - defaultPageSize * page) < 50, !fetching else { return }
    fetching = true
    load()
  }
}
