//
//  PersonDetailProvider.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 30/05/22.
//

import Foundation

struct PersonDetailProvider: URLRequestProtocol {
  var urlParameters: [URLQueryItem]
  var path: String
  
  init(id: Int) {
    path = "people/\(id)/castcredits"
    urlParameters = [URLQueryItem(name: "embed", value: "show")]
  }
}
