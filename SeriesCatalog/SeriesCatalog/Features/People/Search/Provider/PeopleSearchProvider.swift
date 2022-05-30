//
//  PeopleSearchProvider.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 29/05/22.
//

import Foundation

struct PeopleSearchProvider: URLRequestProtocol {
  var path: String = "search/people"
  var urlParameters: [URLQueryItem]
  
  init(query: String) {
    urlParameters = [URLQueryItem(name: "q", value: query)]
  }
}
