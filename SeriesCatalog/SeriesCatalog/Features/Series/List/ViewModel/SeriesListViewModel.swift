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
  func getId(for row: Int) -> Int?
}

class SeriesListViewModel: SeriesListViewModelProtocol {
  @Published var state: SeriesListState = .none
  var statePublisher: Published<SeriesListState>.Publisher { $state }
  private let listAPI: SeriesListAPIProtocol
  private var page: Int = 0
  private var fetching: Bool = false
  private var series: [Series] = []
  
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
        self.series.append(contentsOf: series)
        let models = series.map({SeriesListCellModel(series: $0)})
        state = .loaded(models)
        page += 1
        fetching = false
      } catch let error as ServiceError {

      }
    }
  }
  
  func prefetching(row: Int) {
    guard abs(series.count - row) < 50, !fetching else { return }
    fetching = true
    load()
  }
  
  func getId(for row: Int) -> Int? {
    guard row < series.count else { return nil }
    return series[row].id
  }
}
