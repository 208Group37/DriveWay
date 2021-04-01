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
    
    // MARK: - Text Field Style Functions
    // This function stylizes the text fields
    static func styleTextField(_ textField:UITextField) {
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.layer.borderColor = UIColor(named: "black")?.cgColor
        textField.layer.borderWidth = 3
    }
    
    static func styleTextView(_ textView:UITextView) {
        textView.layer.cornerRadius = 15
        textView.layer.masksToBounds = true
        textView.layer.borderColor = UIColor(named: "black")?.cgColor
        textView.layer.borderWidth = 3
    }
    
    // MARK: - Button Style Functions
    // This function stylizes the buttons to be black and white
    static func styleButtonNeutral(_ button:UIButton) {
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor(named: "black")?.cgColor
        button.layer.borderWidth = 5
    }
    
    // This function stylizes the buttons to be black and green
    static func styleButtonGreen(_ button:UIButton) {
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 1)
        button.layer.borderColor = UIColor(named: "black")?.cgColor
        button.layer.borderWidth = 5
    }
    
    // This function stylizes the buttons to be black and amber
    static func styleButtonAmber(_ button:UIButton) {
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor(red: 1, green: 0.75, blue: 0, alpha: 1)
        button.layer.borderColor = UIColor(named: "black")?.cgColor
        button.layer.borderWidth = 5
    }
    
    // This function stylizes the buttons to be black and red
    static func styleButtonRed(_ button:UIButton) {
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        button.layer.borderColor = UIColor(named: "black")?.cgColor
        button.layer.borderWidth = 5
    }
    
    // MARK: - Validation Functions
    // This function makes sure the password fits within our requirements
    static func validatePassword(_ password:String) -> Bool {
        let goodPassword = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[$@$#!%*?&]).{8,}$")
        return goodPassword.evaluate(with: password)
    }
    
    // This function ensures that the email is of the correct format
    static func validateEmail(_ email:String) -> Bool {
        let goodEmail = NSPredicate(format: "SELF MATCHES %@ ", "")
        return goodEmail.evaluate(with: email)
    }
    
    // MARK: - Button Functions
    // This function toggles a button
    static func toggleButton(_ button: UIButton) {
        if button.isSelected == false {
            button.isSelected = true
        } else {
            button.isSelected = false
        }
    }
}
