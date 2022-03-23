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
    
    var secondsRemaining = 30
    
   weak var delegate: ClearFireBaseDelegate?
    
    var numberOfWins = 0
    var row1 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        print("number of wins in streak vc", numberOfWins)
        updateViews()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            // TODO: Do your stuff here.
            delegate?.clearDB()
          //  print("user swiping away")
        }
    }
    
    func updateViews(){
        winsLabel.text = String(numberOfWins)
        row1Label.text = String(row1)
    }
//    func startTimer(seconds: Int){
//        var secondsRemaining = seconds
//        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
//            if secondsRemaining > 0{
//                DispatchQueue.main.async {
//                    self.timerLabel.text = String(secondsRemaining)
//                }
//                secondsRemaining -= 1
//            }else{
//                Timer.invalidate()
//                //Notifcation: call upon notification broadcast with correct identifier string in order to clear db
//            }
//        }
//    }
    
  

    @IBAction func continueBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
