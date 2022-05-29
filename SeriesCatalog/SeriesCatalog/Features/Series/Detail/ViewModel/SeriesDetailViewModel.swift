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
  func getEpisode(with row: Int, section: Int) -> Episode?
}

class SeriesDetailViewModel: SeriesDetailViewModelProtocol {
  @Published var state: SeriesDetailState = .none
  var statePublisher: Published<SeriesDetailState>.Publisher { $state }
  private var episodes: [Episode] = []
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
        self.episodes = seriesDetail.embedded?.episodes ?? []
        let model = SeriesDetailModels.Model(seriesDetail: seriesDetail)
        print(model)
        state = .loaded(model)
      } catch let error as ServiceError {
        print(error)
      }
    }
  }
  
  func getEpisode(with row: Int, section: Int) -> Episode? {
    guard let episode = episodes.first(where: { $0.season == (section + 1) && $0.number == (row + 1)}) else { return nil }
    return episode
  }
}

