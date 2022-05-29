//
//  AppearanceManager.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 28/05/22.
//

import Foundation
import UIKit

protocol AppearanceManagerProtocol {
  func setupCommonAppearenceLayouts()
}

class AppearanceManager: AppearanceManagerProtocol {
  
  func setupCommonAppearenceLayouts() {
    setupNavigationBarAppearance()
    setupTabBarAppearance()
    setupTableViewAppearance()
  }
  
  private func setupNavigationBarAppearance() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
    appearance.backgroundColor = .systemBackground
    
    let backButton = UIImage(systemName: "arrow.left")
    appearance.setBackIndicatorImage(backButton, transitionMaskImage: backButton)
    UINavigationBar.appearance().tintColor = .label
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
  }
  
  private func setupTabBarAppearance() {
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor.secondarySystemBackground
    let normal: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor.secondaryLabel]
    let selected: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor.label]

    appearance.stackedLayoutAppearance.normal.titleTextAttributes = normal
    appearance.stackedLayoutAppearance.selected.titleTextAttributes = selected
    appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = normal
    appearance.compactInlineLayoutAppearance.selected.titleTextAttributes = selected
    appearance.inlineLayoutAppearance.normal.titleTextAttributes = normal
    appearance.inlineLayoutAppearance.selected.titleTextAttributes = selected
    
    UITabBar.appearance().standardAppearance = appearance
    UITabBar.appearance().scrollEdgeAppearance = appearance
  }
  
  private func setupTableViewAppearance() {
    UITableView.appearance().sectionHeaderTopPadding = 0
  }
}
