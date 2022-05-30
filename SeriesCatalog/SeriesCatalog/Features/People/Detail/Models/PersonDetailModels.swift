//
//  PersonDetailModels.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 30/05/22.
//

import Foundation

struct PersonDetailModels {
  enum Cell: Hashable {
    case logoAndTitle(URL?, String)
    case series(SeriesListCellModel)
  }
  
  struct Section: Hashable {
    
    let id = UUID()
    let title: String?
    let cells: [Cell]
    
    static func == (lhs: PersonDetailModels.Section, rhs: PersonDetailModels.Section) -> Bool {
      lhs.id == rhs.id
    }
  }
  
  struct Model {
    let sections: [Section]
    
    init(person: Person, personDetail: [PersonDetailResult]) {
      var tmpSection: [Section] = []
      tmpSection.append(Section(title: nil, cells: [.logoAndTitle(person.image?.original, person.name)]))
      
      var cellSeries: [Cell] = []
      personDetail.forEach { result in
        if let series = result.embedded.show {
          cellSeries.append(.series(SeriesListCellModel(series: series)))
        }
      }
      tmpSection.append(Section(title: "Known For", cells: cellSeries))
      sections = tmpSection
    }
  }
}


