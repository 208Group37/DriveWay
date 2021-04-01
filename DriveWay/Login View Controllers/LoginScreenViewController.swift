//
//  ViewController.swift
//  DriveWay
//
//  Created by Morgan Eckersley on 27/03/2021.
//

import UIKit

// Class for the login screen view conroller
class LoginScreenViewController: UIViewController {

    // MARK: - Outlets
    // Outlets for the objects on the view controller
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
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

}

