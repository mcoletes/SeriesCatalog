//
//  People.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 29/05/22.
//

import Foundation

struct PeopleResult: Codable {
  let person: Person
}

// MARK: - Person
struct Person: Codable {
    let id: Int
    let name: String
    let image: Image?
}
