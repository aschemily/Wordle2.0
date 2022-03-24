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
    }
    
    func shouldPresentMainStoryboard(){
        if UserDefaults.standard.bool(forKey: Constants.isOnboardedKey){
            storyBoardManager.instatiateMainStoryBoard()
        }
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: Constants.isOnboardedKey)
        storyBoardManager.instatiateMainStoryBoard()
        HapticManager.createFeedBack()
    }
    
}
