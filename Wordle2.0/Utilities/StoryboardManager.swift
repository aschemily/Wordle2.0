//
//  StoryboardManager.swift
//  Wordle2.0
//
//  Created by Emily Asch on 3/22/22.
//

import UIKit

struct StoryboardManager{
    
    func presentMyStoryboard(window: UIWindow?){
        guard let window = window else {return}
        
        if UserDefaults.standard.bool(forKey: Constants.isOnboardedKey){
            //if user defaults is true do the following
            let storyboard = UIStoryboard(name: Constants.mainStoryboard, bundle: nil)
            window.rootViewController = storyboard.instantiateInitialViewController()
        }else{
            //if user defaults is false do the following
            let storyboard = UIStoryboard(name: Constants.instructionsStoryboard, bundle: nil)
            window.rootViewController = storyboard.instantiateInitialViewController()
        }
        window.makeKeyAndVisible()
    }
    
    func instatiateMainStoryBoard(){
        let storyboard = UIStoryboard(name: Constants.mainStoryboard, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: Constants.mainStoryBoardID) as? WordGridViewController else {return}
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        window?.rootViewController = vc
        window?.makeKeyAndVisible()

    }
    

    
}
