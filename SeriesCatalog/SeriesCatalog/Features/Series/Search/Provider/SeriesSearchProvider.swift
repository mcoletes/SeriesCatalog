//
//  SeriesSearchProvider.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 29/05/22.
//

import Foundation

struct SeriesSearchProvider: URLRequestProtocol {
  var path: String = "search/shows"
  var urlParameters: [URLQueryItem]
  
  init(query: String) {
    urlParameters = [URLQueryItem(name: "q", value: query)]
  }
}

