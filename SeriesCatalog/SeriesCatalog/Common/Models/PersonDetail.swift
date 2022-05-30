//
//  PeopleDetail.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 30/05/22.
//

import Foundation

// MARK: - PersonDetailResult

struct PersonDetailResult: Codable {
  let embedded: EmbeddedShows
  
  enum CodingKeys: String, CodingKey {
    case embedded = "_embedded"
  }
}

// MARK: - EmbeddedShows
struct EmbeddedShows: Codable {
  let show: Series?
}

