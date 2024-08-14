//
//  SceneDelegate.swift
//  MercadoNicoLibre
//
//  Created by Nicolas Di Santi on 06.08.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        guard let rootVc = self.window?.rootViewController as? UINavigationController else {
            print ("Initial ViewController not found")
            return
        }
        rootVc.viewControllers = [ScreenFactory.createSearchView()]
    }

}

