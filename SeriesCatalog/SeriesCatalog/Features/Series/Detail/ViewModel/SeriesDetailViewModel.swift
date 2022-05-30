//
//  SeriesDetailViewModel.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 28/05/22.
//

import Foundation


protocol SeriesDetailViewModelProtocol {
  var statePublisher: Published<RegularStates<SeriesDetailModels.Model>>.Publisher { get }
  func load()
  func getEpisode(with row: Int, section: Int) -> Episode?
  func toggleFavorite() -> Bool
}

class SeriesDetailViewModel: SeriesDetailViewModelProtocol, RegularStateViewModelProtocol {
  @Published var state: RegularStates<SeriesDetailModels.Model> = .idle
  var statePublisher: Published<RegularStates<SeriesDetailModels.Model>>.Publisher { $state }
  private var seriesDetail: SeriesDetail?
  private var episodes: [Episode] = []
  let id: Int
  let listAPI: SeriesAPIProtocol
  let favoritesManager: FavoritesSeriesManagerProtocol
  
  init(id: Int, listAPI: SeriesAPIProtocol = SeriesAPI(), favoritesManager: FavoritesSeriesManagerProtocol = FavoritesSeriesManager()) {
    self.id = id
    self.listAPI = listAPI
    self.favoritesManager = favoritesManager
  }
  
  func load() {
    state = .loading
    Task {
      do {
        let seriesDetail = try await listAPI.fetchSeriesDetail(id: id)
        self.seriesDetail = seriesDetail
        self.episodes = seriesDetail.embedded?.episodes ?? []
        let model = SeriesDetailModels.Model(seriesDetail: seriesDetail, isFavorite: favoritesManager.isFavorite(id: seriesDetail.id))
        state = .success(model)
      } catch let error as ServiceError {
        state = .error(error, load)
      }
    }
  }
  
  func getEpisode(with row: Int, section: Int) -> Episode? {
    guard let episode = episodes.first(where: { $0.season == (section + 1) && $0.number == (row + 1)}) else { return nil }
    return episode
  }
  
  func toggleFavorite() -> Bool {
    guard let seriesDetail = seriesDetail else {
      return false
    }
    if favoritesManager.isFavorite(id: id) {
      favoritesManager.deleteFavorite(id: id)
      return false
    } else {
      favoritesManager.addFavorite(series: seriesDetail.toSeries())
      return true
    }
  }
}

