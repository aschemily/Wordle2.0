//
//  StreakViewController.swift
//  Wordle2.0
//
//  Created by Emily Asch on 3/15/22.
//

import UIKit
import FirebaseDatabase

class StreakViewController: UIViewController {
    
    @IBOutlet weak var winsLabel: UILabel!
    @IBOutlet weak var row1Label: UILabel!
    @IBOutlet weak var row2Label: UILabel!
    @IBOutlet weak var row3Label: UILabel!
    
    @IBOutlet weak var row4Label: UILabel!
    
    @IBOutlet weak var row5Label: UILabel!
    
    @IBOutlet weak var row6Label: UILabel!
    
    
    
    var secondsRemaining = 30
    
    weak var delegate: ClearFireBaseDelegate?
    
    var numberOfWins = 0
    var streakArray: [Int] = []
    var databasedCleared = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        updateViews()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            // TODO: Do your stuff here.
            delegate?.clearDB()
        }
    }
    
    func updateViews(){
        winsLabel.text = String(numberOfWins)
        row1Label.text = String(streakArray[0])
        row2Label.text = String(streakArray[1])
        row3Label.text = String(streakArray[2])
        row4Label.text = String(streakArray[3])
        row5Label.text = String(streakArray[4])
        row6Label.text = String(streakArray[5])
    }
    
    
    @IBAction func continueBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        HapticManager.createFeedBack()
    }
    
}
