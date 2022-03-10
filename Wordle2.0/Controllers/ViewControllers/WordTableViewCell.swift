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
    
    //array of background colors
    
    //landing pad for to grab letters
    var userWord: String = ""{
        didSet{
            updateViews()
        }
    }
    
    var colors: [UIColor] = []
    
    func updateViews(){
        let wordArray = Array(userWord)
       // print("inside update views", colors)
        
        switch wordArray.count{
            
        case 1:
            firstLetter.text = String(wordArray[0])
        case 2:
            firstLetter.text = String(wordArray[0])
            secondLetter.text = String(wordArray[1])
        case 3:
            firstLetter.text = String(wordArray[0])
            secondLetter.text = String(wordArray[1])
            thirdLetter.text = String(wordArray[2])
        case 4:
            firstLetter.text = String(wordArray[0])
            secondLetter.text = String(wordArray[1])
            thirdLetter.text = String(wordArray[2])
            fourthLetter.text = String(wordArray[3])
        case 5:
            firstLetter.text = String(wordArray[0])
            secondLetter.text = String(wordArray[1])
            thirdLetter.text = String(wordArray[2])
            fourthLetter.text = String(wordArray[3])
            fifthLetter.text = String(wordArray[4])
            
        default:
            break
            
        }
        
        firstLetter.backgroundColor = colors[0]
        secondLetter.backgroundColor = colors[1]
        thirdLetter.backgroundColor = colors[2]
        fourthLetter.backgroundColor = colors[3]
        fifthLetter.backgroundColor = colors[4]
   
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        firstLetter.text = ""
        secondLetter.text = ""
        thirdLetter.text = ""
        fourthLetter.text = ""
        fifthLetter.text = ""
    }
    
    
    
    
    
}//end of class



