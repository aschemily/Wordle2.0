//
//  WordGridViewController.swift
//  Wordle2.0
//
//  Created by Emily Asch on 3/7/22.
//

import UIKit

class WordGridViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var keyBoardButtons: [UIButton]!
    
    @IBOutlet weak var congratsLabel: UILabel!
    
    
    
    var playersGuesses: [String] = Array(repeating: "", count: 6)
    var currentRow = 0
    
    
    //array of array of background colors
    var colorsArray: [[UIColor]] = Array(repeating: Array(repeating: .white, count: 5), count: 6)
    //    [[.yellow, .gray, .green, .blue, .red],[.brown, .red, .blue, .cyan, .yellow], [.systemIndigo, .purple, .orange, .systemMint, .systemPink],[.yellow, .gray, .green, .blue, .red],[.brown, .red, .blue, .cyan, .yellow], [.systemIndigo, .purple, .orange, .systemMint, .systemPink]]
    
    var wordOfTheDay: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        fetchAllWords()
        congratsLabel.isHidden = true
        
    }
    
    //MARK: HELPER METHODS
    
    func fetchAllWords(){
        WordController.fetchWords { result in
            switch result{
            case .success(let response):
                //call getNewWord()
                //success only returning one word
                self.getNewWord()
                print(response)
            case .failure(let error):
                print("🔴error in \(#function), \(error.localizedDescription), \(error)🔴")
            }
        }
    }
    
    func getNewWord(){
        guard let randomWord = WordController.filteredWords.randomElement() else {return}
        //self.wordOfTheDay = random element
        // print("random word is", randomWord)
        wordOfTheDay = randomWord
    }
    
    
    func lettersGuessed(letter: String){
        guard playersGuesses[currentRow].count < 5 else {return}
        playersGuesses[currentRow].append(letter)
    }
 
    
    func compareWords(){
        
        if playersGuesses[currentRow].lowercased() == wordOfTheDay{
            colorsArray[currentRow] = [#colorLiteral(red: 0.4489225149, green: 0.7674041986, blue: 0.4262357354, alpha: 1), #colorLiteral(red: 0.4489225149, green: 0.7674041986, blue: 0.4262357354, alpha: 1), #colorLiteral(red: 0.4489225149, green: 0.7674041986, blue: 0.4262357354, alpha: 1), #colorLiteral(red: 0.4489225149, green: 0.7674041986, blue: 0.4262357354, alpha: 1), #colorLiteral(red: 0.4489225149, green: 0.7674041986, blue: 0.4262357354, alpha: 1)]
        }
        
        let splitPlayersGuess = Array(playersGuesses[currentRow].lowercased())
        
        let splitWordOfTheDay = Array(wordOfTheDay)
        
        for btn in keyBoardButtons{
            guard let btnLetter = btn.titleLabel?.text else {return}
         //   print(btnLetter)

          
            for (i, letter) in splitPlayersGuess.enumerated(){
                if(i == 0 && letter == splitWordOfTheDay[0]) || (i == 1 && letter == splitWordOfTheDay[1]) || (i == 2 && letter == splitWordOfTheDay[2]) || (i == 3 && letter == splitWordOfTheDay[3]) || (i == 4 && letter == splitWordOfTheDay[4]){
                    
                    if btnLetter.lowercased() == String(letter){
                        btn.backgroundColor = #colorLiteral(red: 0.4489225149, green: 0.7674041986, blue: 0.4262357354, alpha: 1)
                      
                    }
                    
                    colorsArray[currentRow][i] = #colorLiteral(red: 0.4489225149, green: 0.7674041986, blue: 0.4262357354, alpha: 1)
                   // print(btnLetter, letter)
                    
                }else if(wordOfTheDay.contains(letter)){
                    if btnLetter.lowercased() == String(letter){
                        btn.backgroundColor =  #colorLiteral(red: 0.8781039119, green: 0.7762021422, blue: 0.2915796041, alpha: 1)
                      
                    }
                    
                    colorsArray[currentRow][i] = #colorLiteral(red: 0.8781039119, green: 0.7762021422, blue: 0.2915796041, alpha: 1)
                }else{
                   // btn.backgroundColor = .gray
                    colorsArray[currentRow][i] = #colorLiteral(red: 0.4011883438, green: 0.4024074376, blue: 0.4174343646, alpha: 1)
                    
                }
            }
        }
        
    }
    
    func showLabel(){
        //print(playersGuesses[currentRow], currentRow)
        print(wordOfTheDay)
        var playersGuess = playersGuesses[currentRow].lowercased()
        
        switch (wordOfTheDay == playersGuess, currentRow){
        case (true, 0):
            print("YAY")
            congratsLabel.isHidden = false
            congratsLabel.text = "AMAZING"
        case (true, 1):
            print("yes")
            congratsLabel.isHidden = false
            congratsLabel.text = "Great!"
        case (true, 2):
            congratsLabel.isHidden = false
            congratsLabel.text = "Good Work!"
        case (true, 3):
            congratsLabel.isHidden = false
            congratsLabel.text = "close one!"
        case (true, 4):
            congratsLabel.isHidden = false
            congratsLabel.text = "nail biter"
        case (true, 4):
            congratsLabel.isHidden = false
            congratsLabel.text = "PHEW!"

        default:
            break
        }
        
      //  tableView.reloadData()
            
            
    }
    
    
    
    
    //MARK: ACTIONS
    @IBAction func keyBoardTapped(_ sender: UIButton) {
        //pass keyboard press to cell
        switch sender.tag{
        case 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,20,21,22,23,24,25,26:
            guard let letter = sender.titleLabel?.text
            else {return}
            lettersGuessed(letter: letter)
            
        case 19:
            if playersGuesses[currentRow].count == 5{
                compareWords()
                showLabel()
                currentRow += 1
            }
            
            
            
        case 27:
            playersGuesses[currentRow] = String(playersGuesses[currentRow].dropLast())
            
        default:
            break
        }
        tableView.reloadData()
    }
    
    
    
}//end of class

extension WordGridViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playersGuesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "letterCell", for: indexPath) as? WordTableViewCell else {return UITableViewCell()}
        
        let userWord = playersGuesses[indexPath.row]
        cell.colors = colorsArray[indexPath.row]
        cell.userWord = userWord
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}



