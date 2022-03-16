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
    
    let ref = Database.database().reference()
    
    var window: UIWindow?
    
    var playersGuesses: [String] = Array(repeating: "", count: 6)
    var currentRow = 0
    
    
    //array of array of background colors
    var colorsArray: [[UIColor]] = Array(repeating: Array(repeating: .white, count: 5), count: 6)
    //    [[.yellow, .gray, .green, .blue, .red],[.brown, .red, .blue, .cyan, .yellow], [.systemIndigo, .purple, .orange, .systemMint, .systemPink],[.yellow, .gray, .green, .blue, .red],[.brown, .red, .blue, .cyan, .yellow], [.systemIndigo, .purple, .orange, .systemMint, .systemPink]]
    
    var wordOfTheDay: String = ""
  //  var wordOfTheDay = "tired"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
      //  fetchAllWords()
        getWordFromDB()
      
        congratsLabel.isHidden = true
        //initialize notification center and provide function and provide identification string
        
        
    }
    
    //MARK: HELPER METHODS
    
    func fetchAllWords(){
        WordController.fetchWords { result in
            switch result{
            case .success(let response):
                //call getNewWord()
                //success only returning one word
              
                self.getNewWord()
                print("response is?", response)
            case .failure(let error):
                print("🔴error in \(#function), \(error.localizedDescription), \(error)🔴")
            }
        }
    }
    
    func checkGameInProgress(){
        if wordOfTheDay.isEmpty{
            fetchAllWords()
        }
    }
    
    
    
    func getNewWord(){
        guard let randomWord = WordController.filteredWords.randomElement() else {return}
        //self.wordOfTheDay = random element
         print("random word is", randomWord)
        ref.child("wordOfTheDay").setValue(randomWord)
        wordOfTheDay = randomWord
    }
    
    func getWordFromDB(){
        ref.child("wordOfTheDay").observeSingleEvent(of: .value) { snapshot in
            print("what is snapshot \(snapshot)")
            
            if let word = snapshot.value as? String {
                self.wordOfTheDay = word
                self.ref.child("usersGuesses").observeSingleEvent(of: .value) { snapshot in
                    guard let userGuessesFromDB = snapshot.value as? [String] else {return}
                    self.playersGuesses = userGuessesFromDB
                    self.updateColorsFromDB()
                }

            }else{
                self.fetchAllWords()
            }
                
        }
      
    }
    
    //clear database
    func clearDB(){
      //clear local
        playersGuesses = Array(repeating: "", count: 6)
        wordOfTheDay = ""
        colorsArray = Array(repeating: Array(repeating: .white, count: 5), count: 6)
        ref.child("wordOfTheDay").removeValue()
        ref.child("usersGuesses").removeValue()
        congratsLabel.isHidden = true
        keyBoardButtons.forEach({ $0.backgroundColor = #colorLiteral(red: 0.8744233251, green: 0.8745703101, blue: 0.8744040132, alpha: 1) })
        currentRow = 0
        fetchAllWords()
        tableView.reloadData()
    }
    
    func showStreakVC(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Streak", bundle:nil)
        let streakVC = storyBoard.instantiateViewController(withIdentifier: "streakID") as! StreakViewController
        streakVC.delegate = self
        
        //add timer to present
        self.present(streakVC, animated:true, completion:nil)
        
    }
  
    
    func lettersGuessed(letter: String){
        guard playersGuesses[currentRow].count < 5 else {return}
        playersGuesses[currentRow].append(letter)
        
    }
    
    func saveUsersGuesses(){
        ref.child("usersGuesses").setValue(playersGuesses)
        
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
        
        if playersGuesses[currentRow].lowercased() == wordOfTheDay{
            colorsArray[currentRow] = [#colorLiteral(red: 0.4489225149, green: 0.7674041986, blue: 0.4262357354, alpha: 1), #colorLiteral(red: 0.4489225149, green: 0.7674041986, blue: 0.4262357354, alpha: 1), #colorLiteral(red: 0.4489225149, green: 0.7674041986, blue: 0.4262357354, alpha: 1), #colorLiteral(red: 0.4489225149, green: 0.7674041986, blue: 0.4262357354, alpha: 1), #colorLiteral(red: 0.4489225149, green: 0.7674041986, blue: 0.4262357354, alpha: 1)]
        }

        let splitPlayersGuess = Array(playersGuesses[currentRow].lowercased())

        let splitWordOfTheDay = Array(wordOfTheDay)

        for btn in keyBoardButtons{
            guard let btnLetter = btn.titleLabel?.text else {return}


            for (i, letter) in splitPlayersGuess.enumerated(){
                if(i == 0 && letter == splitWordOfTheDay[0]) || (i == 1 && letter == splitWordOfTheDay[1]) || (i == 2 && letter == splitWordOfTheDay[2]) || (i == 3 && letter == splitWordOfTheDay[3]) || (i == 4 && letter == splitWordOfTheDay[4]){

                    if btnLetter.lowercased() == String(letter){
                        btn.backgroundColor = #colorLiteral(red: 0.4489225149, green: 0.7674041986, blue: 0.4262357354, alpha: 1)

                    }

                    colorsArray[currentRow][i] = #colorLiteral(red: 0.4489225149, green: 0.7674041986, blue: 0.4262357354, alpha: 1)

                }else if(wordOfTheDay.contains(letter)){
                    if btnLetter.lowercased() == String(letter){
                        btn.backgroundColor =  #colorLiteral(red: 0.8781039119, green: 0.7762021422, blue: 0.2915796041, alpha: 1)
                    }

                    colorsArray[currentRow][i] = #colorLiteral(red: 0.8781039119, green: 0.7762021422, blue: 0.2915796041, alpha: 1)
                }else{

                    colorsArray[currentRow][i] = #colorLiteral(red: 0.4011883438, green: 0.4024074376, blue: 0.4174343646, alpha: 1)

                }
            }
        }
        
    }
    
    func showLabel(){
        var playersGuess = playersGuesses[currentRow].lowercased()
        
        switch (wordOfTheDay == playersGuess, currentRow){
        case (true, 0):
          
            congratsLabel.isHidden = false
            congratsLabel.text = "AMAZING!"
            showStreakVC()
        case (true, 1):
            congratsLabel.isHidden = false
            congratsLabel.text = "Great!"
//            NotificationCenter.default.post(name: Notification.Name("StreakNotification"), object: nil)
            showStreakVC()
        case (true, 2):
            congratsLabel.isHidden = false
            congratsLabel.text = "Good Work!"
//            NotificationCenter.default.post(name: Notification.Name("StreakNotification"), object: nil)
            showStreakVC()
        case (true, 3):
            congratsLabel.isHidden = false
            congratsLabel.text = "Close One!"
            showStreakVC()
        case (true, 4):
            congratsLabel.isHidden = false
            congratsLabel.text = "Nail Biter!"
            showStreakVC()
        case (true, 5):
            congratsLabel.isHidden = false
            congratsLabel.text = "PHEW!"
            showStreakVC()

        case(false, 5):
            showStreakVC()
        default:
            break
        }
        
    }
    
//    func instantiateStreakView(window: UIWindow?){
//        guard let window = window else {return}
//        let rootVC = window.rootViewController
//        let streakStoryBoard = UIStoryboard(name: "Streak", bundle: nil)
//        let streakVC = streakStoryBoard.instantiateViewController(withIdentifier: "streakID")
//        streakVC.modalPresentationStyle = .automatic
//        rootVC?.present(streakVC, animated: true, completion: nil)
//        window.makeKeyAndVisible()
//    }
    
    
    
    
    
    
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
                saveUsersGuesses()
//                displayVC()
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



