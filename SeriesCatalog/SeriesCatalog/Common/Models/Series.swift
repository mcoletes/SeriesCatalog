//
//  Series.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 27/05/22.
//

import Foundation

// MARK: - WelcomeElement
struct Series: Codable {
  let id: Int?
  let name: String?
  let image: SeriesImage?
  let summary: String?
  let genres: [String]?
}

// MARK: - SeriesImage
struct SeriesImage: Codable {
  let medium: URL?
  let original: URL?
}

// MARK: - Search Result
struct SearchResult: Codable {
  let show: Series
}

// MARK: - Series Detail
struct SeriesDetail: Codable {
  let name: String?
  let genres: [String]?
  let schedule: Schedule?
  let network: Network?
  let image: SeriesImage?
  let summary: String?
  let embedded: Embedded?
  
  enum CodingKeys: String, CodingKey {
      case name
      case genres
      case schedule
      case network
      case image
      case summary
      case embedded = "_embedded"
  }
}

// MARK: - Embedded
struct Embedded: Codable {
  let episodes: [Episode]
}

// MARK: - Episode
struct Episode: Codable {
  let name: String
  let season: Int
  let number: Int
  let image: SeriesImage?
  let summary: String?
}

// MARK: - Network
struct Network: Codable {
  let name: String?
}


// MARK: - Schedule
struct Schedule: Codable {
  let time: String?
  let days: [String]?
}
