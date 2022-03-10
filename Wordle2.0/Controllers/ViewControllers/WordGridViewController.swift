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
    
 
    //array of array of background colors
    var colorsArray: [[UIColor]] = Array(repeating: Array(repeating: .white, count: 5), count: 6)
//    [[.yellow, .gray, .green, .blue, .red],[.brown, .red, .blue, .cyan, .yellow], [.systemIndigo, .purple, .orange, .systemMint, .systemPink],[.yellow, .gray, .green, .blue, .red],[.brown, .red, .blue, .cyan, .yellow], [.systemIndigo, .purple, .orange, .systemMint, .systemPink]]
    
    var wordOfTheDay: String = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        fetchAllWords()
        
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
        //  print(playersGuesses[currentRow].lowercased(), wordOfTheDay)
        if playersGuesses[currentRow].lowercased() == wordOfTheDay{
            //all letters should be green
            print("YAYYY")
            colorsArray[currentRow] = [.green, .green, .green, .green, .green]
        }
        
        let splitPlayersGuess = Array(playersGuesses[currentRow].lowercased())
            // print(splitPlayersGuess, wordOfTheDay)
        
        let splitWordOfTheDay = Array(wordOfTheDay)
            print(splitWordOfTheDay)
        
        for (i, letter) in splitPlayersGuess.enumerated(){
           // print(index, letter)
            if(i == 0 && letter == splitWordOfTheDay[0]) || (i == 1 && letter == splitWordOfTheDay[1]) || (i == 2 && letter == splitWordOfTheDay[2]) || (i == 3 && letter == splitWordOfTheDay[3]) || (i == 4 && letter == splitWordOfTheDay[4]){
                //letter should be green
                print(letter, i, "🟢")
                colorsArray[currentRow][i] = .green
            }else if(wordOfTheDay.contains(letter)){
                //letter should be yellow/orange
                print("letter in word🟠", letter)
                colorsArray[currentRow][i] = .orange
            }else{
                //gray
                colorsArray[currentRow][i] = .gray
                print("no match🌑", letter)
            }
        }
        
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



