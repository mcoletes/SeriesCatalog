//
//  PeopleDetailViewModel.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 30/05/22.
//

import Foundation

protocol PersonDetailViewModelProtocol {
  var statePublisher: Published<RegularStates<PersonDetailModels.Model>>.Publisher { get }
  func load()
  func getSeriesId(for row: Int, section: Int) -> Int?
}

class PersonDetailViewModel: PersonDetailViewModelProtocol {
  
  @Published var state: RegularStates<PersonDetailModels.Model> = .idle
  var statePublisher: Published<RegularStates<PersonDetailModels.Model>>.Publisher { $state }
  let peopleAPI: PeopleAPIProtocol
  let person: Person
  var personDetail: [PersonDetailResult] = []

  init(peopleAPI: PeopleAPIProtocol = PeopleAPI(), person: Person) {
    self.peopleAPI = peopleAPI
    self.person = person
  }
  
  func load() {
    state = .loading
    Task {
      do {
        personDetail = try await peopleAPI.fetchPersonDetail(id: person.id)
        state = .success(PersonDetailModels.Model(person: person, personDetail: personDetail))
      } catch let error as ServiceError {
        print(error)
        state = .error(error, load)
      }
    }
  }
  
  func getSeriesId(for row: Int, section: Int) -> Int? {
    guard section == 1, row < personDetail.count else { return nil }
    return personDetail[row].embedded.show?.id
  }
}

