//
//  FavoritesViewModel.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 30/05/22.
//

import Foundation

protocol FavoritesViewModelProtocol {
  var statePublisher: Published<FavoriteSeriesStates>.Publisher { get }
  func load()
  func getId(for row: Int) -> Int?
  func sort(index: Int)
}

class FavoritesViewModel: FavoritesViewModelProtocol, StateViewModelProtocol {
  @Published var state: FavoriteSeriesStates = .idle
  var statePublisher: Published<FavoriteSeriesStates>.Publisher { $state }
  private let favoriteSeriesManager: FavoritesSeriesManagerProtocol
  private var series: [Series] = []
  private var sortingOder: FavoriteSortingOrder = .insertion
  
  init(favoriteSeriesManager: FavoritesSeriesManagerProtocol = FavoritesSeriesManager()) {
    self.favoriteSeriesManager = favoriteSeriesManager
  }
  
  func load() {
    sort()
  }
  
  func getId(for row: Int) -> Int? {
    guard row < series.count else { return nil }
    return series[row].id
  }
  
  func sort(index: Int) {
    guard let sorting = FavoriteSortingOrder(rawValue: index) else { return }
    self.sortingOder = sorting
    sort()
  }
  
  private func sort() {
    series = favoriteSeriesManager.getFavorites()
    switch sortingOder {
    case .ascending:
      series.sort(by: {$1.name ?? "" > $0.name ?? "" })
    case .descending:
      series.sort(by: {$0.name ?? "" > $1.name ?? "" })
    case .insertion:
      series = favoriteSeriesManager.getFavorites()
    }
    let models = series.map({SeriesListCellModel(series: $0)})
    self.state = .success(models)
  }
}
