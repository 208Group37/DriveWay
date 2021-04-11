//
//  InstructorAddCarDetailsViewController.swift
//  DriveWay
//
//  Created by Morgan Eckersley on 05/04/2021.
//

import UIKit

class InstructorAddCarDetailsViewController: InstructorMoreDataViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Outlets
    @IBOutlet weak var makeOfCarTextField: UITextField!
    @IBOutlet weak var modelOfCarTextField: UITextField!
    @IBOutlet weak var numberPlateTextField: UITextField!
    @IBOutlet weak var transmissionTextField: UITextField!
    @IBOutlet weak var fuelTypeTextField: UITextField!
    
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var openLibraryButton: UIButton!
    
    @IBOutlet weak var selectedImageView: UIImageView!
    
    @IBOutlet weak var crashCourseOption: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - Variables
    // Creating the variable for the transmission picker
    let transmissionPicker = UIPickerView()
    let transmissionOptions = ["Manual", "Automatic"]
    
    // Creating the variable for the fuel type picker
    let fuelTypePicker = UIPickerView()
    let fuelTypeOptions = ["Petrol", "Diesel", "Electric", "Hybrid"]
    
    // MARK: - UI Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpObjects()
    }
    
    // Styling the view
    override func setUpObjects() {
        Utilities.styleTextField(makeOfCarTextField)
        Utilities.styleTextField(modelOfCarTextField)
        Utilities.styleTextField(numberPlateTextField)
        Utilities.styleTextField(transmissionTextField)
        Utilities.styleTextField(fuelTypeTextField)
        
        Utilities.styleButtonNeutral(takePhotoButton)
        Utilities.styleButtonNeutral(openLibraryButton)
        Utilities.styleButtonNeutral(nextButton)
        
        createTransmissionPicker()
        createFuelTypePicker()
    }
    
    // Function that sets the image selected in the image picker to be displayed
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        selectedImageView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Picker View Functions
    // Compulsary functions for the picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == transmissionPicker {
            return transmissionOptions.count
        }
        if pickerView == fuelTypePicker {
            return fuelTypeOptions.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == transmissionPicker {
            return transmissionOptions[row]
        }
        if pickerView == fuelTypePicker {
            return fuelTypeOptions[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == transmissionPicker {
            transmissionTextField.text = transmissionOptions[row]
        }
        if pickerView == fuelTypePicker {
            fuelTypeTextField.text = fuelTypeOptions[row]
        }
    }
    
    // MARK: - Button Functions
    // Opens the camera if the user has given permission for it to be used
    @IBAction func takePhotoButtonPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let camera = UIImagePickerController()
            camera.delegate = self
            camera.sourceType = .camera
            camera.allowsEditing = false
            self.present(camera, animated: true, completion: nil)
        }
    }
    
    // Opens the photo library if the user has given permission for us to use it
    @IBAction func openLibraryButtonPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibrary = UIImagePickerController()
            photoLibrary.delegate = self
            photoLibrary.sourceType = .photoLibrary
            photoLibrary.allowsEditing = true
            self.present(photoLibrary, animated: true, completion: nil)
        }
    }
    
    // Toggles the check box for the crash course option
    @IBAction func crashCourseSelected(_ sender: Any) {
        Utilities.toggleButton(crashCourseOption)
    }
    
    // When the next button is pressed
    @IBAction func nextButtonPressed(_ sender: Any) {
        // Validate data
        let isThereAnError = validateFields()
        
        // If there is an error...
        if isThereAnError == true {
            // Tell the user
            Utilities.showError("Please fill in all fields correctly", errorLabel: errorLabel)
        } else {
            // Otherwise pass the data to the next view controller
            let parent = self.parent as! InstructorMoreDataViewController
            parent.performSegue(withIdentifier: "toInstructorPersonalDataEntry", sender: nil)
        }
    }
    
    // MARK: - Validation
    // Validating all of the fields in the view
    func validateFields() -> Bool {
        // Creating clean versions of the data fields
        let makeOfCar = makeOfCarTextField.text?.trimmingCharacters(in: .newlines)
        let modelOfCar = modelOfCarTextField.text?.trimmingCharacters(in: .newlines)
        let numberPlate = numberPlateTextField.text?.trimmingCharacters(in: .newlines)
        let transmission = transmissionTextField.text
        let fuelType = fuelTypeTextField.text
        let carPic = selectedImageView.image
        
        // Chacking if any of them are empty
        if makeOfCar == "" || modelOfCar == "" || numberPlate == "" || transmission == "" || fuelType == "" || carPic == nil{
            // If they are then there is an error
            return true
        }
        // Other wise no error
        return false
    }
    
    // MARK: - Picker view transmission
    func createTransmissionPicker() {
        transmissionPicker.delegate = self
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(transmissionSelected))
        
        toolbar.setItems([doneButton], animated: true)
        
        transmissionTextField.inputAccessoryView = toolbar
        transmissionTextField.inputView = transmissionPicker
    }
    
    // When done is pressed set the text field to be what the user chose
    @objc func transmissionSelected() {
        transmissionTextField.text = transmissionOptions[transmissionPicker.selectedRow(inComponent: 0)]
        self.view.endEditing(true)
    }
    
    // MARK: - Picker view fuel type
    func createFuelTypePicker() {
        fuelTypePicker.delegate = self
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(fuelTypeSelected))
        
        toolbar.setItems([doneButton], animated: true)
        
        fuelTypeTextField.inputAccessoryView = toolbar
        fuelTypeTextField.inputView = fuelTypePicker
    }
    
    // When done is pressed set the text field to be what the user chose
    @objc func fuelTypeSelected() {
        fuelTypeTextField.text = fuelTypeOptions[fuelTypePicker.selectedRow(inComponent: 0)]
        self.view.endEditing(true)
    }
    
    // MARK: - Data Collection
    // Getting all of the data from the fields into a dictionary to pass over to the next view
    func getVehicleInfo() -> [String : Any]{
        let makeOfCar = makeOfCarTextField.text!.trimmingCharacters(in: .newlines)
        let modelOfCar = modelOfCarTextField.text!.trimmingCharacters(in: .newlines)
        let numberPlate = numberPlateTextField.text!.trimmingCharacters(in: .newlines)
        let transmission = transmissionTextField.text!
        let fuelType = fuelTypeTextField.text!
        let carPic = selectedImageView.image!
        
        let vehicleInfo = ["type" : "car",
                       "make" : makeOfCar,
                       "model" : modelOfCar,
                       "numberPlate" : numberPlate,
                       "transmission" : transmission,
                       "fuelType" : fuelType,
                       "photo" : carPic] as [String : Any]

        return vehicleInfo
    }
    
    // Getting the value of the crash course option and returning it
    func getCrashCourse() -> Bool {
        let crashCourseAvailable = crashCourseOption.isSelected
        return crashCourseAvailable
    }
}
