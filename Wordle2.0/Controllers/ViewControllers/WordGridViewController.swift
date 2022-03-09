//
//  WordGridViewController.swift
//  Wordle2.0
//
//  Created by Emily Asch on 3/7/22.
//

import UIKit

class WordGridViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var playersGuesses: [String] = Array(repeating: "", count: 6)
    var currentRow = 0
 
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func keyBoardTapped(_ sender: UIButton) {
        //pass keyboard press to cell
        switch sender.tag{
        case 1,2,3,4,5,6,7,8,9:
            guard let letter = sender.titleLabel?.text
               else {return}
                lettersGuessed(letter: letter)
        case 19:
//            if playersGuesses.count == 5{
//                currentRow += 1
//            }else{
//                print("enter more letters")
//            }
            currentRow += 1
            
        default:
            break
        }
        tableView.reloadData()
       
    }
    
    //MARK: Helper methods
    func lettersGuessed(letter: String){
        guard playersGuesses[currentRow].count < 5 else {return}
        playersGuesses[currentRow].append(letter)
        
    }
 
}//end of class

extension WordGridViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playersGuesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "letterCell", for: indexPath) as? WordTableViewCell else {return UITableViewCell()}
      
        let userWord = playersGuesses[indexPath.row]
        cell.userWord = userWord
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
 
}



