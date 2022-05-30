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
  let image: Image?
  let summary: String?
  let genres: [String]?
}

// MARK: - SeriesImage
struct Image: Codable {
  let medium: URL?
  let original: URL?
}

// MARK: - Search Result
struct SearchResult: Codable {
  let show: Series
}

