//
//  SeriesDetailProvider.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 29/05/22.
//

import Foundation

struct SeriesDetailProvider: URLRequestProtocol {
  var path: String
  var urlParameters: [URLQueryItem] = [URLQueryItem(name: "embed", value: "episodes")]
  
  init(id: Int) {
    path = "shows/\(id)"
  }
}
