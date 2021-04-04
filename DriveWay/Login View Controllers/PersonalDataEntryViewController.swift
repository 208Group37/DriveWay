//
//  PersonalDataEntryViewController.swift
//  DriveWay
//
//  Created by Morgan Eckersley on 29/03/2021.
//

import UIKit

class PersonalDataEntryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - Outlets and Variables
    // Outlets for the labels at the top of the view
    @IBOutlet weak var personalDetailsLabel: UILabel!
    @IBOutlet weak var warningLabel: UILabel!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    
    // Setting up the date and gender picker objects and the options for the gender picker
    let datePicker = UIDatePicker()
    let genderPicker = UIPickerView()
    let genderOptions = ["Male", "Female"]
    
    // Passed from the previous view via segue
    var accountType = String()
    
    // MARK: - UISetup
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpObjects()
    }
    
    // Styling the objects to our aesthetic
    func setUpObjects() {
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(dateOfBirthTextField)
        Utilities.styleTextField(genderTextField)
        createDatePicker()
        createGenderPicker()
        Utilities.styleButtonNeutral(nextButton)
    }
    
    // Function that removes the keyboard when the user taps outside of it
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Date Picker Functions
    func createDatePicker() {
        // Setting up the datePickers appearance
        datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        datePicker.datePickerMode = .date
        datePicker.locale = Locale.init(identifier: "en_GB")
        // Creating the toolbar that will hold the done button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Creating the done button for the tool bar
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dateSelected))
        toolbar.setItems([doneButton], animated: true)
        
        // Assigning the tool bar to the date picker
        dateOfBirthTextField.inputAccessoryView = toolbar
        
        // Assigning the datepicker to the text field
        dateOfBirthTextField.inputView = datePicker
    }
    
    @objc func dateSelected(){
        let dateFormatter = DateFormatter()
        dateFormatter.locale = datePicker.locale
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        dateOfBirthTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    // MARK: - Gender Picker Functions
    func createGenderPicker() {
        // Creating another toolbar, the same way as in the date picker
        genderPicker.delegate = self
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(genderSelected))
        
        toolbar.setItems([doneButton], animated: true)
        
        genderTextField.inputAccessoryView = toolbar
        genderTextField.inputView = genderPicker
        

    }
    
    // When done is pressed set the text field to be what the user chose
    @objc func genderSelected() {
        genderTextField.text = genderOptions[genderPicker.selectedRow(inComponent: 0)]
        self.view.endEditing(true)
    }
    
    // Compulsary functions for the picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = genderOptions[row]
    }
    
    //MARK: - Validation
    
    func validateFields() -> Bool {
        // Ensuring all the fields only contain the data they should and no whitespace or new line characters
        let firstName = firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let date = dateOfBirthTextField.text
        let gender = genderTextField.text
        
        // Checking that the text fields arent empty
        if firstName == "" || lastName == "" || date == "" || gender == "" {
            return true
        }
                
        return false
    }
    
    // MARK: - Button Functions
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        let isThereAnError = validateFields()
        
        if isThereAnError == true {
            Utilities.showError("Please fill in all fields", errorLabel: errorLabel)
        } else {
            performSegue(withIdentifier: "toEmailAndPassword", sender: nil)
        }
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Getting the name of the segue
        let segueName = segue.identifier
        // If the name is correct...
        if segueName == "toEmailAndPassword" {
            // Pass all data from this screen and the previous to the destination
            let destination = segue.destination as! EmailAndPasswordEntryViewController
            destination.firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            destination.lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            destination.dateOfBirth = dateOfBirthTextField.text!
            destination.gender = genderTextField.text!
            destination.accountType = accountType
        }
    }
}
