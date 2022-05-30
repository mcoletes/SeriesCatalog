//
//  PeopleSearchViewModel.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 29/05/22.
//

import Foundation

protocol PeopleSearchViewModelProtocol {
  var statePublisher: Published<RegularStates<[PeopleSearchModel]>>.Publisher { get }
  func search(text: String)
  func getPerson(for row: Int) -> Person?
}

class PeopleSearchViewModel: PeopleSearchViewModelProtocol {
  
  @Published var state: RegularStates<[PeopleSearchModel]> = .idle
  var statePublisher: Published<RegularStates<[PeopleSearchModel]>>.Publisher { $state }
  private let peopleAPI: PeopleAPIProtocol
  private var fetching = false
  private var people: [Person] = []
  private var searchedText = ""
  
  init(peopleAPI: PeopleAPIProtocol = PeopleAPI()) {
    self.peopleAPI = peopleAPI
  }
  
  func search(text: String) {
    guard !fetching else { return }
    state = .loading
    searchedText = text
    fetching = true
    Task {
      do {
        let searchResults = try await peopleAPI.searchPeople(query: text.lowercased())
        people = searchResults.map({ $0.person })
        let models = people.map({PeopleSearchModel(person: $0)})
        state = .success(models)
        fetching = false
      } catch let error as ServiceError {
        print(error)
        state = .error(error, searchRetry)
        fetching = false
      }
    }
  }
  
  private func searchRetry() {
    search(text: searchedText)
  }
  
  func getPerson(for row: Int) -> Person? {
    guard row < people.count else { return nil }
    return people[row]
  }
}

