//
//  ViewController.swift
//  DriveWay
//
//  Created by Morgan Eckersley on 27/03/2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

// Class for the login screen view conroller
class LoginScreenViewController: UIViewController {

    // MARK: - Outlets
    // Outlets for the objects on the view controller
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    // MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Setting up the elements on this view controller
        setUpObjects();
    }
    
    // Function that will allow us to hide the navigation controller when the view appears as we do not want it on the this screen
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // Function that will restore the navigation bar when this view disappears
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // This function will set up objects in this view
    func setUpObjects() {
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleButtonNeutral(loginButton)
    }

    // MARK: - Button Functions
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        // A boolean variable for weather there is an error or not
        let isThereAnError = validateFields()
        
        // If there is an error
        if isThereAnError == true {
            // Error: the user has not filled in all fields
            Utilities.showError("Please fill in all fields", errorLabel: self.errorLabel)
        }
        
        // Creating clean versions of the email and password
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Attempting to sign in with email and password
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            // If there is an error with signing in
            if let error = error as NSError? {
            switch AuthErrorCode(rawValue: error.code) {
            case .userDisabled:
              // Error: The user account has been disabled by an administrator.
                Utilities.showError("Account has been disabled", errorLabel: self.errorLabel)
            case .wrongPassword:
              // Error: The password is invalid or the user does not have a password.
                Utilities.showError("Password incorrect", errorLabel: self.errorLabel)
            case .invalidEmail:
              // Error: Indicates the email address is malformed.
                Utilities.showError("Not a real email address", errorLabel: self.errorLabel)
            default:
                print("Error: \(error.localizedDescription)")
            }
          } else {
            // Otherwise the user is signed in
            print("User signs in successfully")
            let userInfo = Auth.auth().currentUser
            
            
            // Decide if user is instructor or learner and perform segue
            
            let database = Firestore.firestore()
            let collectionReference = database.collection("Students")
            let query = collectionReference.whereField("userID", isEqualTo: userInfo!.uid)
            
            query.getDocuments { (snapshot, err) in
                if err != nil {
                    print("There was an error, \(err.debugDescription)")
                } else {
                    if snapshot!.documents.isEmpty {
                        self.performSegue(withIdentifier: "toInstructorHomeScreen", sender: nil)
                    } else {
                        self.performSegue(withIdentifier: "toLearnerHomeScreen", sender: nil)
                    }
                }
            }
          }
        }
    }
    
    // MARK: - Validate Fields
    // Function to check that the fields are not empty
    func validateFields() -> Bool {
        // Attempting to create clean versions of the email and password
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // If either are empty return true
        if email == "" || password == "" {
            return true
        }
        // Else there is no error and return false
        return false
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueName = segue.identifier
        
        if segueName == "toLearnerHomeScreen" {
            let destination = segue.destination
            
        }
    }
}

