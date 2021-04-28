//
//  EmailAndPasswordEntryViewController.swift
//  DriveWay
//
//  Created by Morgan Eckersley on 29/03/2021.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class EmailAndPasswordEntryViewController: UIViewController {

    
    // MARK: - Outlets
    // Outlets for objects
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: - Variables
    // The variables that are passed from the previous segue
    var firstName = String()
    var lastName = String()
    var dateOfBirth = String()
    var gender = String()
    var accountType = String()
    
    
    // MARK: - UI Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpObjects()
    }
    
    // Set up view in correct style
    func setUpObjects() {
        Utilities.styleTextField(emailAddressTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleTextField(confirmPasswordTextField)
        Utilities.styleButtonGreen(createAccountButton)
    }
    
    // MARK: - Account Creation
    // When the create account button is pressed
    @IBAction func createAccountPressed(_ sender: Any) {
        
        // Checking for an error in the entered data
        let isThereAnError = validateFields()
        
        // If there is an error
        if isThereAnError == true {
            // Show the error message
            showError("Please fill in fields correctly")
        } else {
            // Create clean versions of the email and password
            let email = emailAddressTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Show activity indicator
            self.loadingIndicator.isHidden = false
            // Disable the button so it cannot be pressed repeatedly
            createAccountButton.isEnabled = false
            // Create the user with clean email and password
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                // If there is an error with the creation tell the user
                if error != nil {
                    Utilities.showError("Error Creating user.", errorLabel: self.errorLabel)
                }
                // Otherwise add all of their entered data to the database
                else {
                    // Creating a reference to the firestore database
                    let database = Firestore.firestore()
                    
                    // Variable that holds the data that is to be added to the database
                    let documentData: [String: Any] = [
                        "userID" : authResult!.user.uid,
                        "name" : [
                            "first" : self.firstName,
                            "last" : self.lastName
                        ],
                        "publicInfo" : [
                            "birthDate" : self.dateOfBirth,
                            "sex" : self.gender
                        ]
                    ]
                    
                    // Adding the data to the database
                    database.collection(self.accountType).addDocument(data: documentData) { (error) in
                        // If there is an error tell the user
                        if error != nil {
                            self.showError("Error saving user data")
                        }
                                                
                        // Otherwise transition to the next screen
                        if self.accountType == "Students" {
                            self.performSegue(withIdentifier: "toLearnerMoreData", sender: nil)
                        }
                        if self.accountType == "Instructors" {
                            self.performSegue(withIdentifier: "toInstructorMoreData", sender: nil)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Validation
    
    func validateFields() -> Bool{
        // Creating clean versions of the data entered to verify
        let email = emailAddressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let confirmPassword = confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // If any fields are empty...
        if email == "" || password == "" || confirmPassword == ""{
            // There is an error
            return true
        }
        // If the entered passwords arent the same...
        if password != confirmPassword {
            // There is an error
            return true
        }
        // If the password does is not of the correct format
        if Utilities.validatePassword(password!) != true{
            // There is an error
            return true
        }
        // Otherwise..
        // No error
        return false
    }
    
    func showError(_ message:String) {
        // Change the error label to be the error message
        errorLabel.text = message
        // Make the label visable
        errorLabel.isHidden = false
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Identifying the activated segway
        let segueName = segue.identifier
        // If instructor was selected
        if segueName == "toInstructorMoreData" {
            // Pass the first name to the instructor view
            let destination = segue.destination as! InstructorMoreDataViewController
            destination.firstName = self.firstName
        }
        // If learner
        if segueName == "toLearnerMoreData" {
            // Pass the name to the learner view
            let destination = segue.destination as! LearnerMoreDataViewController
            destination.firstName = self.firstName
        }
    }
}
