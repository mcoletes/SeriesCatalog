//
//  Series.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 27/05/22.
//

import Foundation

// MARK: - WelcomeElement
struct Series: Codable {
  let name: String
  let image: SeriesImage
  let summary: String
  let genres: [String]
}

// MARK: - SeriesImage
struct SeriesImage: Codable {
  let medium: URL?
  let original: URL?
}
