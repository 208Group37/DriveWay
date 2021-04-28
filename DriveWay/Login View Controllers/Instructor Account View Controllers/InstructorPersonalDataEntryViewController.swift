//
//  InstructorPersonalDataEntryViewController.swift
//  DriveWay
//
//  Created by Morgan Eckersley on 07/04/2021.
//

import UIKit

class InstructorPersonalDataEntryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Outlets
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var takePictureButton: UIButton!
    @IBOutlet weak var openLibraryButton: UIButton!
    
    @IBOutlet weak var selectedImageView: UIImageView!
    
    @IBOutlet weak var aboutMeTextField: UITextView!
    
    @IBOutlet weak var addressLineOneTextField: UITextField!
    @IBOutlet weak var addressLineTwoTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var postcodeTextField: UITextField!
    
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - Variables
    // Data passed from the previous controllers
    var firstName = String()
    var vehicleInfo = [String : Any]()
    var crashCourse = Bool()
    
    
    
    // MARK: - UI Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpObjects()
    }
    
    // Styles all of the objects in the view
    func setUpObjects() {
        welcomeLabel.text = "\(firstName), add a bit about yourself"
        Utilities.styleButtonNeutral(takePictureButton)
        Utilities.styleButtonNeutral(openLibraryButton)
        Utilities.styleTextView(aboutMeTextField)
        Utilities.styleTextField(addressLineOneTextField)
        Utilities.styleTextField(addressLineTwoTextField)
        Utilities.styleTextField(cityTextField)
        Utilities.styleTextField(postcodeTextField)
        distanceLabel.text = "\(distanceSlider.value) Miles"
        Utilities.styleButtonNeutral(nextButton)
    }
    
    // Function that will allow us to hide the navigation controller when the view appears as we do not want it on the this screen
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // Function that will restore the login bar when this view disappears
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // Sets the image view to contain the selected image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        selectedImageView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - IBAction Functions
    // When the take photo button is pressed the camera will open
    @IBAction func takePictureButtonPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let camera = UIImagePickerController()
            camera.delegate = self
            camera.sourceType = .camera
            camera.allowsEditing = false
            self.present(camera, animated: true, completion: nil)
        }
    }
    
    // Opening the library when the open library button is pressed
    @IBAction func openLibraryButtonPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibrary = UIImagePickerController()
            photoLibrary.delegate = self
            photoLibrary.sourceType = .photoLibrary
            photoLibrary.allowsEditing = true
            self.present(photoLibrary, animated: true, completion: nil)
        }
    }
    
    // When the user changes the value on the slider
    @IBAction func sliderChanged(_ sender: UISlider) {
        // ROund that value to a multiple of 1 rather than it be a decimal
        let roundedValue = round(sender.value / 1) * 1
        // Set the value of the slider to be the rounded value
        sender.value = roundedValue
        // Change the text on the label showing how far has been selected
        distanceLabel.text = "\(sender.value) Miles"
    }
    
    // When the next button is pressed
    @IBAction func nextButtonPressed(_ sender: Any) {
        // Validate fields
        let isThereAnError = validateFields()
        
        // If there is an error...
        if isThereAnError == true {
            // Show the error to the user
            Utilities.showError("Please fill in all fields", errorLabel: errorLabel)
        } else {
            // Otherwise, pass the data to the next view
            performSegue(withIdentifier: "toInstructorAvailability", sender: nil)
        }
    }
    
    // MARK: - Validation
    func validateFields() -> Bool{
        // Creating clean versions of each field
        let profileImage = selectedImageView.image
        let aboutMe = aboutMeTextField.text
        let addressLineOne = addressLineOneTextField.text
        let addressLineTwo = addressLineTwoTextField.text
        let city = cityTextField.text
        let postcode = postcodeTextField.text
        
        if profileImage == nil || aboutMe == "" || addressLineOne == "" || addressLineTwo == "" || city == "" || postcode == "" {
            return true
        }
        return false
    }
    
    // MARK: - Data Collection
    // Collecting all of the peronal data added by the user into one dictionary to be passed over to the next view
    func addPersonalDataToDictionary() -> [String : Any] {
        let profileImage = selectedImageView.image!
        let aboutMe = aboutMeTextField.text!
        let addressLineOne = addressLineOneTextField.text!
        let addressLineTwo = addressLineTwoTextField.text!
        let city = cityTextField.text!
        let postcode = postcodeTextField.text!
        
        let personalData = ["type" : "Instructors",
                            "profileImage" : profileImage,
                            "aboutMe" : aboutMe,
                            "addressLineOne" : addressLineOne,
                            "addressLineTwo" : addressLineTwo,
                            "city" : city,
                            "postcode" : postcode
        ] as [String : Any]
        
        return personalData
    }
    
    
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueName = segue.identifier
        // When the segue is called pass all of the data to the next view
        if segueName == "toInstructorAvailability" {
            let destination = segue.destination as! InstructorAvailabilityViewController
            destination.personalData = addPersonalDataToDictionary()
            destination.vehicleInfo = vehicleInfo
            destination.distanceForALesson = distanceSlider.value
            destination.crashCourse = crashCourse            
        }
    }

}
