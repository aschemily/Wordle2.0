//
//  WordController.swift
//  Wordle2.0
//
//  Created by Emily Asch on 3/8/22.
//

import Foundation
import Firebase

class WordController{

    //word of the day
    //source of truth filtered array
    static var filteredWords: [String] = []
    //url
    //https://random-word-api.herokuapp.com/all
    let ref = Database.database().reference()
    
  static let url = URL(string:"https://random-word-api.herokuapp.com/all")
    
    
    /**
        This functions fetches words from Firebase

     # Notes: #
     1.  If no internet connection is there then the function won't work
     2.  Function will either return a string value or network error

     # Example #
    ```
     // fetch the string value
     let wordData = try JSONDecoder().decode([String].self, from: data)
     filteredWords = wordData.filter{$0.count == 5}
     return completion(.success("🟢successfully fetched all words🟢"))
     
     // Save to local array variable on WordController
     static var filteredWords: [String] = []
    ```
    */
    static func fetchWords(completion: @escaping (Result <String, NetworkError>)-> Void){
        //ensure url is there
        guard let url = url else{
            return completion(.failure(.invalidURL))
        }
      
        //DATA
        URLSession.shared.dataTask(with: url) { data, response, error in
            //handle error first
            if let error = error{
                return completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse{
                if response.statusCode != 200{
                    print("STATUS CODE \(response.statusCode)")
                }
            }
            
            //guard against data
            guard let data = data else {return completion(.failure(.noData))}
            
            do{
                let wordData = try JSONDecoder().decode([String].self, from: data)
                
                //do filter here
              //  assign words to result of filter
                 filteredWords = wordData.filter{$0.count == 5}
                
                return completion(.success("🟢successfully fetched all words🟢"))
            }catch{
                return completion(.failure(.unableToDecode))
            }
        }.resume()
  
    }
    
   
}//end of class
