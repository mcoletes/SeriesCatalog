//
//  SeriesDetailModels.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 28/05/22.
//

import Foundation

struct SeriesDetailModels {
  enum Cell: Hashable {
    case logoAndTitle(URL?, String?)
    case detalInfo(String, String?)
    case detalInfoImage(URL?, String, String?)
  }
  
  struct Section: Hashable {
    
    let id = UUID()
    let title: String?
    let rows: [Cell]
    
    static func == (lhs: SeriesDetailModels.Section, rhs: SeriesDetailModels.Section) -> Bool {
      lhs.id == rhs.id
    }
  }
  
  struct Model {
    let mainDetailSection: Section
    let episodeSections: [Section]
    let isFavorite: Bool
    init(seriesDetail: SeriesDetail, isFavorite: Bool) {
      self.isFavorite = isFavorite
      mainDetailSection = Section(title: nil, rows: [.logoAndTitle(seriesDetail.image?.original, seriesDetail.name),
                                                       .detalInfo("Summary", seriesDetail.summary?.strippedHTMLTags),
                                                       .detalInfo("Genres", seriesDetail.genres?.joined(separator: ", ")),
                                                       .detalInfo("Days", seriesDetail.schedule?.days?.joined(separator: ", ")),
                                                       .detalInfo("Time", seriesDetail.schedule?.time)])
      
      let dictOfSections = Dictionary(grouping: seriesDetail.embedded?.episodes ?? [], by: { $0.season }).sorted(by: {$1.key > $0.key})
      var epsTemp: [Section] = []
      for dict in dictOfSections {
        let episodesInThisSections: [Cell] = dict.value.map({ .detalInfoImage($0.image?.medium, "Episode \($0.number)", $0.name) })
        epsTemp.append(Section(title: "Season \(dict.key)", rows: episodesInThisSections))
      }
      episodeSections = epsTemp
    }
  }
}
