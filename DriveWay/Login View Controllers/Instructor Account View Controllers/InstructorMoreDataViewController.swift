//
//  InstructorMoreDataViewController.swift
//  DriveWay
//
//  Created by Morgan Eckersley on 30/03/2021.
//

import UIKit

class InstructorMoreDataViewController: UIViewController {

    // MARK: - Outlets and Variables
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var carOption: UIButton!
    @IBOutlet weak var motorcycleOption: UIButton!
    @IBOutlet weak var vehicleInfoRequestLabel: UILabel!

    @IBOutlet weak var carDetailView: UIView!
    @IBOutlet weak var motorcycleDetailView: UIView!
    
    var firstName = String()
    
    // MARK: - UI Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpObjects()
    }
    
    // Personalising the welcome label
    func setUpObjects() {
        welcomeLabel.text = "Hi \(firstName), let's finish setting up your account"
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
    
    // MARK: - Button Functions
    
    // When the car option is selected the car data entry form is revealed
    @IBAction func carSelected(_ sender: Any) {
        carOption.isSelected = true
        motorcycleOption.isSelected = false
        vehicleInfoRequestLabel.text = "Please enter the details of your car"
        vehicleInfoRequestLabel.isHidden = false
        carDetailView.isHidden = false
        motorcycleDetailView.isHidden = true
    }
    
    // When the motorcycle option is selected the motorcycle entry form is revealed
    @IBAction func motorcycleSelected(_ sender: Any) {
        motorcycleOption.isSelected = true
        carOption.isSelected = false
        vehicleInfoRequestLabel.text = "Please enter the details of your motorcycle"
        vehicleInfoRequestLabel.isHidden = false
        carDetailView.isHidden = true
        motorcycleDetailView.isHidden = false
    }
    
    // MARK: - Navigation
    
    // This function is called from a container view to trigger the segue
    func goToNextView() {
        performSegue(withIdentifier: "toInstructorPersonalDataEntry", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Getting the name of the segue
        let segueName = segue.identifier
        
        // Check the name of the segue
        if segueName == "toInstructorPersonalDataEntry" {
            // Set the destination
            let destination = segue.destination as! InstructorPersonalDataEntryViewController
            
            // If the segue has been triggered from the car view then pass the car data over
            if carOption.isSelected {
                let triggeredFrom = self.children[0]
                let carView = triggeredFrom as! InstructorAddCarDetailsViewController
                destination.firstName = self.firstName
                destination.vehicleInfo = carView.getVehicleInfo()
                destination.crashCourse = carView.getCrashCourse()
                print("CAR")
            }
            // If the segue has been triggered from the motorcycle view then pass the motorcycle data over
            if motorcycleOption.isSelected {
                let triggeredFrom = self.children[1]
                let bikeView = triggeredFrom as! InstructorAddMotorcycleDetailsViewController
                destination.firstName = self.firstName
                destination.vehicleInfo = bikeView.getVehicleInfo()
                destination.crashCourse = bikeView.getCrashCourse()
                print("MOTORCYCLE")
            }
        }
    }
}
