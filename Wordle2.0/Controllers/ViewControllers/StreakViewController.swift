//
//  StreakViewController.swift
//  Wordle2.0
//
//  Created by Emily Asch on 3/15/22.
//

import UIKit

class StreakViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    var secondsRemaining = 30
    
   weak var delegate: ClearFireBaseDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer(seconds: secondsRemaining)
        // Do any additional setup after loading the view.
    }
    
    func startTimer(seconds: Int){
        var secondsRemaining = seconds
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
            if secondsRemaining > 0{
                DispatchQueue.main.async {
                    self.timerLabel.text = String(secondsRemaining)
                }
                secondsRemaining -= 1
            }else{
                Timer.invalidate()
                //Notifcation: call upon notification broadcast with correct identifier string in order to clear db
            }
        }
    }
    
    
    @IBAction func continueBtnPressed(_ sender: Any) {
        delegate?.clearDB()
        print("continue button pressed")
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
