//
//  WordTableViewCell.swift
//  Wordle2.0
//
//  Created by Emily Asch on 3/8/22.
//

import UIKit

class WordTableViewCell: UITableViewCell {
    
    @IBOutlet weak var firstLetter: UILabel!
    @IBOutlet weak var secondLetter: UILabel!
    @IBOutlet weak var thirdLetter: UILabel!
    @IBOutlet weak var fourthLetter: UILabel!
    @IBOutlet weak var fifthLetter: UILabel!
    
    
    var userWord: String = ""{
        didSet{
            updateViews()
        }
    }
    
    
    func updateViews(){
        var userWord = userWord
        //while userWord length is less than five add empty spaces to word
        while userWord.count < 5{
            userWord.append(" ")
        }
        //create array
        var wordArray = Array(repeating: " ", count: 5)
        
        for i in 0...4{
            let index = String.Index(utf16Offset: i, in: userWord)
          
        }
        
//        firstLetter.text = String(splitWord[0])
//        secondLetter.text = String(splitWord[1])
//        thirdLetter.text = String(splitWord[2])
//        fourthLetter.text = String(splitWord[3])
//        fifthLetter.text = String(splitWord[4])
    
       
    }
    
//    func updateViews(){
//        var userWord = userWord
//        while userWord.count < 5{
//            userWord.append(" ")
//        }
//        var array = Array(repeating: " ", count: 5)
//        for i in 0...4{
//            let index = String.Index(utf16Offset: i, in: userWord)
//            array[i] = String(userWord[index])
//        }
//        firstLetter.text = String(array[0])
//        secondLetter.text = String(array[1])
//        thirdLetter.text = String(array[2])
//        fourthLetter.text = String(array[3])
//        fifthLetter.text = String(array[4])
//
//    }
    
 
    
    
}//end of class
