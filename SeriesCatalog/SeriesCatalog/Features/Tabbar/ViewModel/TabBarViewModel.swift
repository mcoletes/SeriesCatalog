//
//  TabBarViewModel.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 29/05/22.
//

import Foundation

protocol TabBarViewModelProtocol {
  func getMenuItems() -> [TabBarTabs]
}

class TabBarViewModel: TabBarViewModelProtocol {
  
  func getMenuItems() -> [TabBarTabs] {
    return TabBarTabs.allCases
  }
}

