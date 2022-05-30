//
//  TabBarModels.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 29/05/22.
//

import Foundation
import UIKit

struct TabBarModel {
  let title: String
  let image: String
  let viewController: UIViewController
}

enum TabBarTabs: CaseIterable {
  case series
  case favorites
  case people
  case settings

  var model: TabBarModel {
    switch self {
    case .series:
      return TabBarModel(title: "Series",
                         image: "photo",
                         viewController: SeriesTableViewController())
    case .favorites:
      return TabBarModel(title: "Favorites",
                         image: "heart",
                         viewController: UIViewController())
    case .people:
      return TabBarModel(title: "People",
                         image: "person",
                         viewController: PeopleSearchViewController())
    case .settings:
      return TabBarModel(title: "Settings",
                         image: "gear",
                         viewController: UIViewController())
    }
  }
}
