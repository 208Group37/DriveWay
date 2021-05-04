//
//  LearnerLessonRequestViewController.swift
//  DriveWay
//
//  Created by Jake Darby on 30/04/2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class LearnerLessonRequestViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Variable declaration
    let datePicker = UIDatePicker()
    let startTimePicker = UIDatePicker()
    let endTimePicker = UIDatePicker()
    let pickupPicker = UIPickerView()
    let dropoffPicker = UIPickerView()
    var instructorID = ""
    var studentID = ""
    var day = ""
    var locations: [String] = []
    var instructorCost: Int = 0
    
    let userID = Auth.auth().currentUser!.uid
        
    // MARK: - Outlets
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var startTimeField: UITextField!
    @IBOutlet weak var endTimeField: UITextField!
    @IBOutlet weak var pickupField: UITextField!
    @IBOutlet weak var dropoffField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var dropoffToggle: UISwitch!
    @IBOutlet weak var noAvailabilityLabel: UILabel!
    
    
    // MARK: - Button and toggle actions
    @IBAction func submitButton(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale.init(identifier: "en_GB")
        let startLocation = pickupField.text!
        var endLocation = dropoffField.text!
        if dropoffToggle.isOn {
            endLocation = startLocation
        }
        let dataToAdd: [String : Any] = [
            "date" : dateField.text!,
            "location" : [
                "end" : endLocation,
                "start" : startLocation,
                ],
            "notes" : "",
            "people" : [
                "instructorID" : instructorID,
                "studentID" : userID,
            ],
            "status" : "Pending",
            "time" : [
                "end" : endTimeField.text!,
                "start" : startTimeField.text!,
            ]
        ]
        let database = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = database.collection("Lessons").addDocument(data: dataToAdd) { err in
            if let err = err {
                print("Error adding document: \(err)")
                let finish = UIAlertController(title: "Your request was not successful", message: "Try another time or date", preferredStyle: .alert)
                finish.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(finish, animated: true, completion: nil)
            } else {
                print("Document added with ID: \(ref!.documentID)")
                let finish = UIAlertController(title: "Your request has been submitted", message: "Your instructor will see your request soon.", preferredStyle: .alert)
                finish.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(finish, animated: true, completion: nil)
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func dropoffToggle(_ sender: Any) {
        if dropoffToggle.isOn {
            dropoffField.isHidden = true
        }
        else {
            dropoffField.isHidden = false
        }
        enableButton()
    }
    
    // MARK: - Built-in functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getAddresses()
        createLocationPickupPicker()
        createLocationDropoffPicker()
        noAvailabilityLabel.isHidden = true
        Utilities.styleButtonGreen(submitButton)
        if dropoffToggle.isOn {
            dropoffField.isHidden = true
        }
        createDatePicker(field: dateField, picker: datePicker)
        startTimeField.isEnabled = false
        endTimeField.isEnabled = false
        enableButton()
    }
    

    // MARK: - Custom functions
    
    func enableButton() {
        if dateField.hasText && startTimeField.hasText && endTimeField.hasText && pickupField.hasText && (dropoffToggle.isOn || dropoffField.hasText) {
            submitButton.isHidden = false
        }
        else {
            submitButton.isHidden = true
        }
    }
    
    // Gets all of the user's saved addresses
    func getAddresses() {
        var allAddresses: [String] = []
        let database = Firestore.firestore()
        let collectionReference = database.collection("Students")
        let query = collectionReference.whereField("userID", isEqualTo: userID)
        query.getDocuments { (snapshot, err) in
            if err != nil {
                print(err.debugDescription)
            } else {
                for document in snapshot!.documents {
                    // All the information stored in the document about the user
                    let userDocData = document.data()
                    let privateInfo = userDocData["privateInfo"] as! [String : Any]
                    let addresses = privateInfo["addresses"] as! [String : Any]
                    for i in addresses {
                        let address = addresses[i.key] as! [String : String]
                        allAddresses.append("\(address["line1"]!), \(address["postcode"]!)")
                    }
                    self.locations = allAddresses
                }
                
            }
        }
    }
        
    // A function that adds date and time pickers to the text fields in the view
    func createDatePicker(field: UITextField, picker: UIDatePicker) {
        // Setting up the datePickers appearance
        picker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        picker.locale = Locale.init(identifier: "en_GB")
        // If the field is the date field
        if field == dateField {
            picker.datePickerMode = .date
            picker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
            picker.maximumDate = Calendar.current.date(byAdding: .month, value: 3, to: Date())
        }
        else {
            let database = Firestore.firestore()
            let collectionReference = database.collection("Instructors")
            let query = collectionReference.whereField("userID", isEqualTo: instructorID)
            query.getDocuments { (snapshot, err) in
                if err != nil {
                    print(err.debugDescription)
                } else {
                    for document in snapshot!.documents {
                        // All the information stored in the document about the user
                        let userDocData = document.data()
                        let times = userDocData["availability"] as? [String: [String]]
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "HH:mm"
                        let timeFormatter = DateFormatter()
                        timeFormatter.locale = picker.locale
                        timeFormatter.dateStyle = .none
                        timeFormatter.timeStyle = .short
                        // If teh field is the start time field
                        if field == self.startTimeField {
                            picker.datePickerMode = .time
                            picker.minuteInterval = 15
                            picker.minimumDate = dateFormatter.date(from: String(times![((self.dateField.text?.components(separatedBy: ",")[0])?.lowercased())!]!.first?.prefix(5) ?? "00:15"))
                            picker.maximumDate = dateFormatter.date(from: String(times![((self.dateField.text?.components(separatedBy: ",")[0])?.lowercased())!]!.last?.suffix(5) ?? "00:15"))
                            if (picker.minimumDate == timeFormatter.date(from: "00:15")) && (picker.maximumDate == timeFormatter.date(from: "00:15")) {
                                self.startTimeField.isEnabled = false
                                self.startTimeField.text = ""
                                self.endTimeField.isEnabled = false
                                self.endTimeField.text = ""
                                self.noAvailabilityLabel.font = UIFont.italicSystemFont(ofSize: 15)
                                self.noAvailabilityLabel.text = "No availability on this day"
                                self.noAvailabilityLabel.isHidden = false
                                self.enableButton()
                            }
                            else {
                                self.noAvailabilityLabel.isHidden = true
                                self.startTimeField.isEnabled = true
                            }
                        }
                        else if field == self.endTimeField {
                            picker.datePickerMode = .time
                            picker.minuteInterval = 15
                            picker.minimumDate = dateFormatter.date(from: String(self.startTimeField.text ?? "07:00"))
                            picker.maximumDate = dateFormatter.date(from: String(times![(self.dateField.text?.components(separatedBy: ",")[0])?.lowercased() ?? "monday"]!.last?.suffix(5) ?? "21:00"))
                        }
                    }
                }
            }
        }
        // Creating the toolbar that will hold the done button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Creating the done button for the tool bar
        if field == dateField {
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dateSelected))
            toolbar.setItems([doneButton], animated: true)
        }
        else if field == startTimeField {
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(startTimeSelected))
            toolbar.setItems([doneButton], animated: true)
        }
        else if field == endTimeField {
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(endTimeSelected))
            toolbar.setItems([doneButton], animated: true)
        }
        
        // Assigning the tool bar to the date picker
        field.inputAccessoryView = toolbar
        
        // Assigning the datepicker to the text field
        field.inputView = picker
        enableButton()
    }
    
    // MARK: - 'Done' button functions
    @objc func dateSelected(){
        // Creates a format for the date with the correct layout and style for date and time
        let dateFormatter = DateFormatter()
        dateFormatter.locale = datePicker.locale
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        
        // Changes the text field to be the selected date
        dateField.text = dateFormatter.string(from: datePicker.date)
        createDatePicker(field: startTimeField, picker: startTimePicker)
        enableButton()
        
        // Dismissing the keyboard
        self.view.endEditing(true)
    }
    @objc func startTimeSelected(){
        // Creates a format for the date with the correct layout and style for date and time
        let dateFormatter = DateFormatter()
        dateFormatter.locale = datePicker.locale
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        // Changes the text field to be the selected date
        startTimeField.text = dateFormatter.string(from: startTimePicker.date)
        createDatePicker(field: endTimeField, picker: endTimePicker)
        endTimeField.isEnabled = true
        enableButton()
        // Dismissing the keyboard
        self.view.endEditing(true)
    }
    @objc func endTimeSelected(){
        // Creates a format for the date with the correct layout and style for date and time
        let dateFormatter = DateFormatter()
        dateFormatter.locale = endTimePicker.locale
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        // Changes the text field to be the selected date
        endTimeField.text = dateFormatter.string(from: endTimePicker.date)
        enableButton()
        // Dismissing the keyboard
        self.view.endEditing(true)
    }
    
    // MARK: - 
    func createLocationPickupPicker() {
        // Creating another toolbar, the same way as in the date picker
        pickupPicker.delegate = self
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(pickupSelected))
        
        toolbar.setItems([doneButton], animated: true)
        
        pickupField.inputAccessoryView = toolbar
        pickupField.inputView = pickupPicker
    }
    
    // When done is pressed set the text field to be what the user chose
    @objc func pickupSelected() {
        pickupField.text = locations[pickupPicker.selectedRow(inComponent: 0)]
        enableButton()
        self.view.endEditing(true)
    }
    
    func createLocationDropoffPicker() {
        // Creating another toolbar, the same way as in the date picker
        dropoffPicker.delegate = self
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dropoffSelected))
        
        toolbar.setItems([doneButton], animated: true)
        
        dropoffField.inputAccessoryView = toolbar
        dropoffField.inputView = dropoffPicker
    }
    
    // When done is pressed set the text field to be what the user chose
    @objc func dropoffSelected() {
        dropoffField.text = locations[dropoffPicker.selectedRow(inComponent: 0)]
        enableButton()
        self.view.endEditing(true)
    }
    
    
    // Compulsary functions for the picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locations.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return locations[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == dropoffPicker {
            dropoffField.text = locations[row]
        }
        else if pickerView == pickupPicker {
            pickupField.text = locations[row]
        }
        
    }

}
