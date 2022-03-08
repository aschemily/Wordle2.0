//
//  WordGridViewController.swift
//  Wordle2.0
//
//  Created by Emily Asch on 3/7/22.
//

import UIKit

class WordGridViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var guesses: [String] = Array(repeating: "", count: 6)
    var currentRow = 0
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func keyBoardTapped(_ sender: UIButton) {
        switch sender.tag{
        case 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 20, 21, 22, 23, 24, 25, 26:
            guard let letterPressed = sender.titleLabel!.text else {return}
            addLetter(letterPressed)
        case 19:
            //make function and call it here
            //guesses[currentRow].count = 5
            //logic to guess word/ update keyboard
            //current row is < 6
            //increment count
        
            guard currentRow < 6 else {return}
            currentRow += 1
        case 27:
            print("27")
        default:
            break
        }
        tableView.reloadData()
    }
    
    //MARK: Helper methods
  
    func addLetter(_ letter: String){
        guard guesses[currentRow].count < 5 else {return}
        guesses[currentRow].append(letter)
        print(guesses)
        print(letter)
    }
   
    
}//end of class

extension WordGridViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "letterCell", for: indexPath) as? WordTableViewCell else {return UITableViewCell()}
        
        let userWord = guesses[indexPath.row]
        cell.userWord = userWord
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
 
}


//Notes
/*
 - add a tag to all letter buttons on keyboard
 - create a function that assigns all the tags and call function in viewDidLoad
 - create function that takes in button tag and figure out which label you're on
 - on didSet, when detects a change updates button tag (possibly delete)
 - fetch api and save one word at random locally on device
 - create function that takes saved word that you compare
 - create fetch function that grabs one word at random, filter words thats are 5 letters
 -
 - fetchWords -> Word{
 let words = [Word]
 words.onlyWordsThatAreFiveLetters
 let randomNumber = words.lowerNumber...words.upperNumber.random
 let myIdentifiedWord = words[randomNumber]
 return myIdentifiedWord
 - way to not duplicate word where words in db compare to random word
 
 }
 
 */
