//
//  HapticManager.swift
//  Wordle2.0
//
//  Created by Emily Asch on 3/24/22.
//

import UIKit

class HapticManager {
    
    static var selection: UISelectionFeedbackGenerator?
   
    static func createFeedBack() {
        selection = UISelectionFeedbackGenerator()
        selection?.prepare()
        selection?.selectionChanged()
        
    }
}
