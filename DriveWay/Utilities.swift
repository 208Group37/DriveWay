//
//  Utilities.swift
//  DriveWay
//
//  Created by Morgan Eckersley on 28/03/2021.
//

import Foundation
import UIKit

// Custom class containing methods that will allow us to keep a consistent style throughout the app
class Utilities {
    
    // This function stylizes the text fields
    static func styleTextField(_ textField:UITextField) {
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.layer.borderColor = UIColor(named: "black")?.cgColor
        textField.layer.borderWidth = 3
    }
    
    // This function stylizes the buttons
    static func styleButton(_ button:UIButton) {
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor(named: "black")?.cgColor
        button.layer.borderWidth = 5
    }
}
