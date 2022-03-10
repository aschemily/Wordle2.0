//
//  NetworkError.swift
//  Wordle2.0
//
//  Created by Emily Asch on 3/10/22.
//

import Foundation

enum NetworkError: LocalizedError{
    case invalidURL
    case thrownError(Error)
    case noData
    case unableToDecode
    
    var errorDescription: String?{
        switch self{
        case .invalidURL:
            return "unable to reach server, invalid URL"
        case .thrownError(let error):
            return "error \(error.localizedDescription)"
        case .noData:
            return "server responded with no data"
        case .unableToDecode:
            return "error trying to decode data"
        }
    }
    
}//end of enum
