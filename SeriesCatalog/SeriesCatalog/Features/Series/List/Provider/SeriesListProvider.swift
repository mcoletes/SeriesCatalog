//
//  SeriesListProvider.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 29/05/22.
//

import Foundation

struct SeriesListProvider: URLRequestProtocol {
  var path: String = "shows"
  var urlParameters: [URLQueryItem]
  
  init(page: Int) {
    urlParameters = [URLQueryItem(name: "page", value: "\(page)")]
  }
}
