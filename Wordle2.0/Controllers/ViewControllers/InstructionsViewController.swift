//
//  InstructionsViewController.swift
//  Wordle2.0
//
//  Created by Emily Asch on 3/17/22.
//

import UIKit

//protocol DismissInstructions: AnyObject{
//    func dismissInstructionVC(window: UIWindow)
//}

class InstructionsViewController: UIViewController {

    private let storyBoardManager = StoryboardManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shouldPresentMainStoryboard()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
      //  UserDefaults.standard.set(true, forKey: Constants.isOnboardedKey)
    }
    
    func shouldPresentMainStoryboard(){
        if UserDefaults.standard.bool(forKey: Constants.isOnboardedKey){
            storyBoardManager.instatiateMainStoryBoard()
//            guard let homeStoryboard = UIStoryboard(name: Constants.mainStoryboard, bundle: nil).instantiateInitialViewController() else {return}
//            homeStoryboard.modalPresentationStyle = .fullScreen
//            //TODO: -figure out uiwindow scene
//            let rootView = UIApplication.shared.windows.first{$0.isKeyWindow}
//            rootView?.rootViewController = homeStoryboard
//            present(homeStoryboard, animated: true, completion: nil)
        }
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: Constants.isOnboardedKey)
     //   self.dismiss(animated: true, completion: nil)
        storyBoardManager.instatiateMainStoryBoard()
        HapticManager.createFeedBack()
    }
    
}
