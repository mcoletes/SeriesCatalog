//
//  PeopleSearchModel.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 29/05/22.
//

import Foundation

struct PeopleSearchModel: Hashable {
  let id = UUID()
  let imageURL: URL?
  let name: String?
  
  init(person: Person) {
    imageURL = person.image?.medium
    name = person.name
  }
}
