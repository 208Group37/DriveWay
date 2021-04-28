//
//  InstructorAddMotorcycleDetailsViewController.swift
//  DriveWay
//
//  Created by Morgan Eckersley on 05/04/2021.
//

import UIKit

class InstructorAddMotorcycleDetailsViewController: InstructorMoreDataViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - Outlets
    
    @IBOutlet weak var engineClassTextField: UITextField!
    @IBOutlet weak var makeTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var numberPlateTextField: UITextField!
    @IBOutlet weak var transmissionTextField: UITextField!
    @IBOutlet weak var fuelTypeTextField: UITextField!
    @IBOutlet weak var takePictureButton: UIButton!
    
    @IBOutlet weak var openLibraryButton: UIButton!
    
    @IBOutlet weak var motorbikeImageView: UIImageView!
    
    @IBOutlet weak var crashCourseOption: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet var nextButton: UIButton!
    
    // MARK: - Variables
    
    // Setting up the variables for the pickerviews and their options
    let enginePicker = UIPickerView()
    let engineOptions = ["AM (50cc)", "A1 (125cc)", "A2 (35kW)", "A (Unrestricted)"]
    
    let transmissionPicker = UIPickerView()
    let transmissionOptions = ["Manual", "Automatic"]
    
    let fuelTypePicker = UIPickerView()
    let fuelTypeOptions = ["Petrol", "Electric"]
    
    // MARK: - UI Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpObjects()
    }
    
    // Function to stylise all of the objects in the view
    override func setUpObjects() {
        Utilities.styleTextField(engineClassTextField)
        Utilities.styleTextField(makeTextField)
        Utilities.styleTextField(modelTextField)
        Utilities.styleTextField(numberPlateTextField)
        Utilities.styleTextField(transmissionTextField)
        Utilities.styleTextField(fuelTypeTextField)
        
        Utilities.styleButtonNeutral(takePictureButton)
        Utilities.styleButtonNeutral(openLibraryButton)
        Utilities.styleButtonNeutral(nextButton)
        
        createEnginePicker()
        createTransmissionPicker()
        createFuelTypePicker()
    }
    
    // Sets the image view to contain the selected image from the image picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        motorbikeImageView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Picker View Functions
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == enginePicker {
            return engineOptions.count
        }
        if pickerView == transmissionPicker {
            return transmissionOptions.count
        }
        if pickerView == fuelTypePicker {
            return fuelTypeOptions.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == enginePicker {
            return engineOptions[row]
        }
        if pickerView == transmissionPicker {
            return transmissionOptions[row]
        }
        if pickerView == fuelTypePicker {
            return fuelTypeOptions[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == enginePicker {
            return engineClassTextField.text = engineOptions[row]
        }
        if pickerView == transmissionPicker {
            return transmissionTextField.text = transmissionOptions[row]
        }
        if pickerView == fuelTypePicker {
            return fuelTypeTextField.text = fuelTypeOptions[row]
        }
    }
    
    // MARK: - Button Functions
    
    // Open the camera when the take photo button is pressed
    @IBAction func takePhotoButtonPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let camera = UIImagePickerController()
            camera.delegate = self
            camera.sourceType = .camera
            camera.allowsEditing = false
            self.present(camera, animated: true, completion: nil)
        }
    }
    
    // Open the library when the button is pressed
    @IBAction func openLibraryButtonPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibrary = UIImagePickerController()
            photoLibrary.delegate = self
            photoLibrary.sourceType = .photoLibrary
            photoLibrary.allowsEditing = true
            self.present(photoLibrary, animated: true, completion: nil)
        }
    }
    
    // Toggle the crash course option button when it is pressed
    @IBAction func crashCourseSelected(_ sender: Any) {
        Utilities.toggleButton(crashCourseOption)
    }
    
    // When the next button is pressed
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        // Check all fields have data in them
        let isThereAnError = validateFields()
        
        // If not, show the user the error
        if isThereAnError == true {
            Utilities.showError("Please fill in all fields correctly", errorLabel: errorLabel)
        } else {
            // Otherwise trigger the parent segue to the next controller
            let parent = self.parent as! InstructorMoreDataViewController
            parent.performSegue(withIdentifier: "toInstructorPersonalDataEntry", sender: nil)
        }
    }
    
    // MARK: - Engine Picker Setup
    // Creating the engine picker
    func createEnginePicker() {
        enginePicker.delegate = self
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(engineSelected))
        
        toolbar.setItems([doneButton], animated: true)
        
        engineClassTextField.inputAccessoryView = toolbar
        engineClassTextField.inputView = enginePicker
    }
    
    // When done is pressed set the text field to be what the user chose
    @objc func engineSelected() {
        engineClassTextField.text = engineOptions[enginePicker.selectedRow(inComponent: 0)]
        self.view.endEditing(true)
    }
    
    // MARK: - Transmission Picker Setup
    // Creating the transmission picker
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
    
    // MARK: - Fuel Type Picker Setup
    //  Creating the transmission picker
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
    
    // MARK: - Validation
    // Function to make sure all fields have data in them
    func validateFields() -> Bool{
        let engine = engineClassTextField.text
        let make = makeTextField.text?.trimmingCharacters(in: .newlines)
        let model = modelTextField.text?.trimmingCharacters(in: .newlines)
        let numberPlate = numberPlateTextField.text?.trimmingCharacters(in: .newlines)
        let transmission = transmissionTextField.text
        let fuelType = fuelTypeTextField.text
        let motorbikeImage = motorbikeImageView.image
        
        if engine == "" || make == "" || model == "" || numberPlate == "" || transmission == "" || fuelType == "" || motorbikeImage == nil {
            return true
        }
        return false
    }
    
    // MARK: - Data Collection
    // Collecting all of the bike data into one dictionary to pass to the next controller
    func getVehicleInfo() -> [String : Any] {
        let engine = engineClassTextField.text!
        let make = makeTextField.text!.trimmingCharacters(in: .newlines)
        let model = modelTextField.text!.trimmingCharacters(in: .newlines)
        let numberPlate = numberPlateTextField.text!.trimmingCharacters(in: .newlines)
        let transmission = transmissionTextField.text!
        let fuelType = fuelTypeTextField.text!
        let motorbikeImage = motorbikeImageView.image!
        
        let vehicleInfo = ["type" : "motorcycle",
                           "engine" : engine,
                           "make" : make,
                           "model" : model,
                           "numberPlate" : numberPlate,
                           "transmission" : transmission,
                           "fuelType" : fuelType,
                           "image" : motorbikeImage] as [String : Any]
        
        return vehicleInfo
    }
    
    // Getting the state of the crash course button
    func getCrashCourse() -> Bool {
        let crashCourseAvailable = crashCourseOption.isSelected
        return crashCourseAvailable
    }
}
