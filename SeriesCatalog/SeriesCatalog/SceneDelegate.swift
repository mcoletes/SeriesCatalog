//
//  SceneDelegate.swift
//  SeriesCatalog
//
//  Created by Mauro Coletes on 27/05/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
    window.rootViewController = TabBarController()
    self.window = window
    window.makeKeyAndVisible()
  }
}

