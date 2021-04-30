//
//  Utilities.swift
//  DriveWay
//
//  Created by Morgan Eckersley on 28/03/2021.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth
import CoreLocation

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
    
    static func styleTextViewNonInteractive(_ textView:UITextView) {
        textView.layer.masksToBounds = true
        textView.layer.borderColor = UIColor(named: "black")?.cgColor
        textView.layer.borderWidth = 3
    }
    
    // Displaying the error message on a label
    static func showError(_ message:String, errorLabel: UILabel) {
        errorLabel.text = message
        errorLabel.isHidden = false
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
    
    // MARK: - Firebase Functions
    // This function recieves a user and a collection and gives all documents that have that user involved in that collection
    static func addDataToUserDocument(_ user: User, collection: String, dataToAdd: [String : Any]) {
        
        // Create database reference
        let database = Firestore.firestore()
        
        // Creating a reference to the collection
        let collectionReference = database.collection(collection)
        
        // Creating a query for all documents that match the userID
        let query = collectionReference.whereField("userID", isEqualTo: user.uid)
        
        // Getting the documents that forfill the query
        query.getDocuments() { (snapshot, err) in
            // If there is an error
            if err != nil {
                // Print the error and a message
                print("There was an error obtaining the documentID: \(err!)")
            // Otherwise
            } else {
                // For every document in the snapshot
                for document in snapshot!.documents {
                    // Add the data to the document
                    let documentReference = collectionReference.document(document.documentID)
                    documentReference.setData(dataToAdd, merge: true)
                }
            }
        }
    }
    
    // MARK: - Useful Functions
    static func calculateAge(birthday: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_GB")
        
        let birthdate = dateFormatter.date(from: birthday)!
        
        let calendar = Calendar.current
        
        let today = Date()
        
        let components = calendar.dateComponents([.year], from: birthdate, to: today)
        
        return Int(components.year!)
    }
    
    static func distanceBetweenTwoAddresses(learnerAddress: String, instructorAddress: String) -> Int {
        let geocoder1 = CLGeocoder()
        let geocoder2 = CLGeocoder()
        
        var learnerLocation = CLLocation()
        var instructorLocation = CLLocation()
        
        geocoder1.geocodeAddressString(learnerAddress) { placemark, err in
            if err != nil {
                print("There was an error, \(err.debugDescription)")
            } else {
                for place in placemark! {
                    learnerLocation = place.location!
                    print(learnerLocation)
                }
            }
        }
        
        geocoder2.geocodeAddressString(instructorAddress) { placemark, err in
            if err != nil {
                print("There was an error, \(err.debugDescription)")
            } else {
                for place in placemark! {
                    instructorLocation = place.location!
                    print(instructorLocation)
                }
            }
        }
        
        let distance = learnerLocation.distance(from: instructorLocation)
        return Int(distance)
    }
}
