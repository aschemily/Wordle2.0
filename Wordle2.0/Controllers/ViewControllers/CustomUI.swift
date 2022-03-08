//
//  CustomUI.swift
//  Wordle2.0
//
//  Created by Emily Asch on 3/8/22.
//

import Foundation
import UIKit

class customLabel: UILabel{
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpViews()
    }
    
    func setUpViews(){
        self.layer.borderColor = #colorLiteral(red: 0.8744233251, green: 0.8745703101, blue: 0.8744040132, alpha: 1)
        self.layer.borderWidth = 2.0
    }
  
}//end of class
