//
//  EpisodesDetailViewModel.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 29/05/22.
//

import Foundation

enum EpisodesDetailState {
  case none
  case loaded([EpisodesDetailCellModel])
}

enum EpisodesDetailCellModel: Hashable {
  case logoAndTitle(URL?, String?)
  case detalInfo(String, String?)
}

protocol EpisodesDetailViewModelProtocol {
  var statePublisher: Published<EpisodesDetailState>.Publisher { get }
  func load()
}

class EpisodesDetailViewModel: EpisodesDetailViewModelProtocol, StateViewModelProtocol {
  
  @Published var state: EpisodesDetailState = .none
  var statePublisher: Published<EpisodesDetailState>.Publisher { $state }
  private let episode: Episode
  
  init(episode: Episode) {
    self.episode = episode
  }
  
  func load() {
    var models: [EpisodesDetailCellModel] = []
    
    models.append(.logoAndTitle(episode.image?.original, episode.name))
    models.append(.detalInfo("Season", String(episode.season)))
    models.append(.detalInfo("Number", String(episode.number)))
    models.append(.detalInfo("Summary",episode.summary?.strippedHTMLTags))
    state = .loaded(models)
  }
}
