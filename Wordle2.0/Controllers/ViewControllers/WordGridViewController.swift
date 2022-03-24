//
//  WordGridViewController.swift
//  Wordle2.0
//
//  Created by Emily Asch on 3/7/22.
//

import UIKit
import FirebaseDatabase

protocol ClearFireBaseDelegate: AnyObject{
    func clearDB()
}

class WordGridViewController: UIViewController, ClearFireBaseDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var keyBoardButtons: [UIButton]!
    
    @IBOutlet weak var congratsLabel: UILabel!
    @IBOutlet weak var invalidGuessLabel: UILabel!
    
    let ref = Database.database().reference()
    
    var window: UIWindow?
    
    var playersGuesses: [String] = Array(repeating: "", count: 6)
    var playersRowStreak: [Int] = Array(repeating: 0, count: 6)
    var row1 = 0
    var currentRow = 0
    
    
    //array of array of background colors
    /// color array is a two dimensional array of ui color
    var colorsArray: [[UIColor]] = Array(repeating: Array(repeating: .white, count: 5), count: 6)
    
    
    var wordOfTheDay: String = ""
    var uid: String?
    var numberOfWins = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uid = UIDevice.current.identifierForVendor?.uuidString
        tableView.delegate = self
        tableView.dataSource = self
        getWordFromDB()
        invalidGuessLabel.isHidden = true
        congratsLabel.isHidden = true
        //initialize notification center and provide function and provide identification string
        fetchUserInfo()
    }
    
    
    func fetchAllWords(){
        WordController.fetchWords { result in
            switch result{
            case .success(let response):
                //success only returning one word
                self.checkGameInProgress()
                print("response is?", response)
            case .failure(let error):
                print("🔴error in \(#function), \(error.localizedDescription), \(error)🔴")
            }
        }
    }
    
    func checkGameInProgress(){
        if wordOfTheDay.isEmpty{
            getNewWord()
        }
    }
    
    func fetchUserInfo(){
        guard let id = uid else {return}
        
        ref.child("userInfo/\(id)").child("numberOfWins").observeSingleEvent(of: .value) { snapshot in
            if let wins = snapshot.value as? Int {
                self.numberOfWins = wins
            }
        }
        
        ref.child("userInfo/\(id)").child("playersRowStreak").observeSingleEvent(of: .value) { snapshot in
            if let streak = snapshot.value as? [Int] {
                self.playersRowStreak = streak
            }
        }
        
    }
    
    func saveUserInfo(){
        guard let id = uid else {return}
        
        ref.child("userInfo/\(id)").setValue(["numberOfWins": "\(numberOfWins)", "playersGuesses": "\(playersGuesses)", "row1": "\(row1)","playersRowStreak": "\(playersRowStreak)", "wordOfTheDay": "\(wordOfTheDay)"])
    }
    
    
    func getNewWord(){
        guard let randomWord = WordController.filteredWords.randomElement() else {return}
        
        print("random word is", randomWord)
        guard let id = uid else {return}
        
        ref.child("userInfo/\(id)").child("wordOfTheDay").setValue(randomWord)
        
        wordOfTheDay = randomWord
    }
    
    func getWordFromDB(){
        guard let currentID =  uid else {return}
        
        ref.child("userInfo/\(currentID)").child("wordOfTheDay").observeSingleEvent(of: .value) { snapshot in
            
            if let word = snapshot.value as? String {
                self.wordOfTheDay = word
                self.fetchAllWords()
                self.ref.child("userInfo/\(currentID)").child("playersGuesses").observeSingleEvent(of: .value) { snapshot in
                    guard let userGuessesFromDB = snapshot.value as? [String] else {return}
                    self.playersGuesses = userGuessesFromDB
                    self.updateColorsFromDB()
                    
                    print("array count", userGuessesFromDB.count)
                    if userGuessesFromDB.contains(word.uppercased()) || !userGuessesFromDB[5].isEmpty{
                        self.clearDB()
                    }
                }
                
            }else{
                self.fetchAllWords()
            }
            
        }
        
    }
    
    func saveUsersGuesses(){
        guard let id = uid else {return}
        ref.child("userInfo/\(id)").child("playersGuesses").setValue(playersGuesses)
        
    }
    
    //clear database
    func clearDB(){
        //clear local
        guard let id = uid else {return}
        playersGuesses = Array(repeating: "", count: 6)
        wordOfTheDay = ""
        colorsArray = Array(repeating: Array(repeating: .white, count: 5), count: 6)
        ref.child("userInfo/\(id)").child("wordOfTheDay").removeValue()
        ref.child("userInfo/\(id)").child("playersGuesses").removeValue()
        congratsLabel.isHidden = true
        keyBoardButtons.forEach({ $0.backgroundColor = #colorLiteral(red: 0.8744233251, green: 0.8745703101, blue: 0.8744040132, alpha: 1) })
        currentRow = 0
        getNewWord()
        tableView.reloadData()
    }
    
    func showStreakVC(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Streak", bundle:nil)
        let streakVC = storyBoard.instantiateViewController(withIdentifier: "streakID") as! StreakViewController
        streakVC.delegate = self
        
        streakVC.numberOfWins = numberOfWins
        streakVC.streakArray = playersRowStreak
        
        self.present(streakVC, animated:true, completion:nil)
    }
    
    func showInstructionsVC(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Instructions", bundle: nil)
        let instructionsVC = storyBoard.instantiateViewController(withIdentifier: "instructionsID") as! InstructionsViewController
        
        self.present(instructionsVC, animated: true, completion: nil)
    }
    
    
    func lettersGuessed(letter: String){
        guard playersGuesses[currentRow].count < 5 else {return}
        playersGuesses[currentRow].append(letter)
        
    }
    
    
    func updateColorsFromDB(){
        for word in playersGuesses{
            if !word.isEmpty{
                compareWords()
                currentRow += 1
            }
        }
        tableView.reloadData()
    }
    
    func compareWords(){
        print("word of the day \(wordOfTheDay)")
        //if word of the day has repeating char increase count
        //compare count to letters guess
        //if letters guessed
        
        
        if playersGuesses[currentRow].lowercased() == wordOfTheDay{
            colorsArray[currentRow] = [#colorLiteral(red: 0.4489225149, green: 0.7674041986, blue: 0.4262357354, alpha: 1), #colorLiteral(red: 0.4489225149, green: 0.7674041986, blue: 0.4262357354, alpha: 1), #colorLiteral(red: 0.4489225149, green: 0.7674041986, blue: 0.4262357354, alpha: 1), #colorLiteral(red: 0.4489225149, green: 0.7674041986, blue: 0.4262357354, alpha: 1), #colorLiteral(red: 0.4489225149, green: 0.7674041986, blue: 0.4262357354, alpha: 1)]
        }
        
        for btn in keyBoardButtons{
            guard let btnLetter = btn.titleLabel?.text else {return}
            var splitPlayersGuess = Array(playersGuesses[currentRow].lowercased())
            var splitWordOfTheDay = Array(wordOfTheDay)
            
            
            for (i, letter) in splitPlayersGuess.enumerated(){
                if letter == splitWordOfTheDay[i]{
                    
                    splitPlayersGuess[i] = "#" //["n", "a", "n", "#", "y"]
                    
                    splitWordOfTheDay[i] = "!"//["j", "n", "a", "!", "a"]
                    
                    if btnLetter.lowercased() == String(letter){
                        btn.backgroundColor = #colorLiteral(red: 0.4489225149, green: 0.7674041986, blue: 0.4262357354, alpha: 1)
                    }
                    
                    colorsArray[currentRow][i] = #colorLiteral(red: 0.4489225149, green: 0.7674041986, blue: 0.4262357354, alpha: 1)
                    
                }
            }
            for (i, letter) in splitPlayersGuess.enumerated(){
                if splitWordOfTheDay.contains(letter){
                    guard let index = splitWordOfTheDay.firstIndex(of: letter) else {return}
                    
                    splitWordOfTheDay[index] = "+"
                    
                    if btnLetter.lowercased() == String(letter) && btn.backgroundColor != #colorLiteral(red: 0.4489225149, green: 0.7674041986, blue: 0.4262357354, alpha: 1){
                        btn.backgroundColor =  #colorLiteral(red: 0.8781039119, green: 0.7762021422, blue: 0.2915796041, alpha: 1)
                    }
                    
                    colorsArray[currentRow][i] = #colorLiteral(red: 0.8781039119, green: 0.7762021422, blue: 0.2915796041, alpha: 1)
                    
                }else{
                    if colorsArray[currentRow][i] != #colorLiteral(red: 0.4489225149, green: 0.7674041986, blue: 0.4262357354, alpha: 1){
                        colorsArray[currentRow][i] = #colorLiteral(red: 0.4011883438, green: 0.4024074376, blue: 0.4174343646, alpha: 1)
                    }
                    
                    if String(letter) == btnLetter.lowercased() && btn.backgroundColor != #colorLiteral(red: 0.4489225149, green: 0.7674041986, blue: 0.4262357354, alpha: 1){
                        btn.backgroundColor = #colorLiteral(red: 0.4011883438, green: 0.4024074376, blue: 0.4174343646, alpha: 1)
                    }
                }
            }
        }
        
    }
    
    func updateWins(){
        guard let id = uid else {return}
        let ref = ref.child("userInfo").child(id)
        
        numberOfWins += 1
        playersRowStreak[currentRow] += 1
        ref.child("numberOfWins").setValue(numberOfWins)
        ref.child("playersRowStreak").setValue(playersRowStreak)
    }
    
    
    func showLabel(){
        
        var playersGuess = playersGuesses[currentRow].lowercased()
        
        switch (wordOfTheDay == playersGuess, currentRow){
        case (true, 0):
            
            congratsLabel.isHidden = false
            congratsLabel.text = "AMAZING!"
            updateWins()
            showStreakVC()
        case (true, 1):
            congratsLabel.isHidden = false
            congratsLabel.text = "Great!"
            updateWins()
            showStreakVC()
        case (true, 2):
            congratsLabel.isHidden = false
            congratsLabel.text = "Good Work!"
            updateWins()
            showStreakVC()
        case (true, 3):
            congratsLabel.isHidden = false
            congratsLabel.text = "Close One!"
            updateWins()
            showStreakVC()
        case (true, 4):
            congratsLabel.isHidden = false
            congratsLabel.text = "Nail Biter!"
            updateWins()
            showStreakVC()
        case (true, 5):
            congratsLabel.isHidden = false
            congratsLabel.text = "PHEW!"
            updateWins()
            showStreakVC()
            
        case(false, 5):
            showStreakVC()
        default:
            break
        }
        
    }
    
    func isValidGuess()-> Bool{
        return WordController.filteredWords.contains(playersGuesses[currentRow].lowercased())
    }
    
    //MARK: ACTIONS
    @IBAction func keyBoardTapped(_ sender: UIButton) {
        //pass keyboard press to cell
        switch sender.tag{
        case 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,20,21,22,23,24,25,26:
            guard let letter = sender.titleLabel?.text
            else {return}
            lettersGuessed(letter: letter)
            
        case 19:
            if playersGuesses[currentRow].count == 5 {
                guard isValidGuess() == true else {
                    invalidGuessLabel.text = "INVALID GUESS"
                    invalidGuessLabel.isHidden = false
                    return
                }
                compareWords()
                invalidGuessLabel.isHidden = true
                showLabel()
                saveUsersGuesses()
                currentRow += 1
            }
            
        case 27:
            playersGuesses[currentRow] = String(playersGuesses[currentRow].dropLast())
            
        default:
            break
        }
        HapticManager.createFeedBack()
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



