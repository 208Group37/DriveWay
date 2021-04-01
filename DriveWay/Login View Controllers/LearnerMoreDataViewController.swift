//
//  LearnerMoreDataViewController.swift
//  DriveWay
//
//  Created by Morgan Eckersley on 30/03/2021.
//

import UIKit

class LearnerMoreDataViewController: UIViewController {

    // MARK: - Outlets and Variables
    // Outlet for the welcome label so it can be customized with the users name
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var carOption: UIButton!
    @IBOutlet weak var motorcycleOption: UIButton!
    
    @IBOutlet weak var addressLineOneTextField: UITextField!
    @IBOutlet weak var addressLineTwoTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var postcodeTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    
    var firstName = String()
        
    // MARK: - UI Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpObjects()
    }
    
    // Function to set the objects in the view to be the correct style
    func setUpObjects() {
        welcomeLabel.text = "Hi \(firstName), let's finish setting up your account"
        Utilities.styleTextField(addressLineOneTextField)
        Utilities.styleTextField(addressLineTwoTextField)
        Utilities.styleTextField(cityTextField)
        Utilities.styleTextField(postcodeTextField)
        Utilities.styleButtonNeutral(nextButton)
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
    
    // Function that removes the keyboard when the user taps outside of it
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Button Actions
    // When the car radio button is selected...
    @IBAction func carSelected(_ sender: Any) {
        // Selects the car option and deselects the motorcycle option
        carOption.isSelected = true
        motorcycleOption.isSelected = false
    }
    
    // When the motorcycle radio button is selected...
    @IBAction func motorcycleSelected(_ sender: Any) {
        // Selects the motorcycle option and deselects the car option
        motorcycleOption.isSelected = true
        carOption.isSelected = false
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        let isThereAnError = validateFields()
        
        if isThereAnError == true {
            showError("Please fill in all fields")
        } else {
            performSegue(withIdentifier: "toSelectAvailability", sender: nil)
        }
    }
    
    //MARK: - Validation
    func validateFields() -> Bool {
        if carOption.isSelected == false && motorcycleOption.isSelected == false {
            return true
        }
        if addressLineOneTextField.text?.trimmingCharacters(in: .newlines) == "" {
            return true
        }
        if addressLineTwoTextField.text?.trimmingCharacters(in: .newlines) == "" {
            return true
        }
        if cityTextField.text?.trimmingCharacters(in: .newlines) == "" {
            return true
        }
        if postcodeTextField.text?.trimmingCharacters(in: .newlines) == "" {
            return true
        }
        return false
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let segueName = segue.identifier
        
        if segueName == "toSelectAvailability" {
            let destination = segue.destination as! SelectAvailabilityViewController
            if carOption.isSelected == true {
                destination.carOrMotorcycle = "car"
            }
            if motorcycleOption.isSelected == true {
                destination.carOrMotorcycle = "motorcycle"
            }
            destination.address.append(addressLineOneTextField.text!)
            destination.address.append(addressLineTwoTextField.text!)
            destination.address.append(cityTextField.text!)
            destination.address.append(postcodeTextField.text!)
        }
    }
}
