//
//  SeriesListViewModel.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 27/05/22.
//

import Foundation

protocol SeriesListViewModelProtocol {
  var statePublisher: Published<RegularStates<[SeriesListCellModel]>>.Publisher { get }
  func load()
  func prefetching(row: Int)
  func getId(for row: Int) -> Int?
}

class SeriesListViewModel: SeriesListViewModelProtocol, RegularStateViewModelProtocol {
  @Published var state: RegularStates<[SeriesListCellModel]> = .idle
  var statePublisher: Published<RegularStates<[SeriesListCellModel]>>.Publisher { $state }
  private let listAPI: SeriesAPI
  private var page: Int = 0
  private var fetching: Bool = false
  private var series: [Series] = []
  
  init(listAPI: SeriesAPI = SeriesAPI()) {
    self.listAPI = listAPI
  }
  
  func load() {
    state = .loading
    fetch()
  }
  
  private func fetch() {
    Task {
      do {
        let series = try await listAPI.fetchSeries(page: page)
        self.series.append(contentsOf: series)
        let models = series.map({SeriesListCellModel(series: $0)})
        state = .success(models)
        page += 1
        fetching = false
      } catch let error as ServiceError {
        state = .error(error, fetch)
        fetching = false
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
