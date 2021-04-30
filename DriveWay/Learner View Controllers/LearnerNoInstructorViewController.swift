//
//  LearnersInstructorViewController.swift
//  DriveWay
//
//  Created by Morgan Eckersley on 29/04/2021.
//

import UIKit

class LearnerNoInstructorViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var searchForInstructorButton: UIButton!
    
    
    // MARK: - UI Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpObjects()
    }
    
    func setUpObjects() {
        Utilities.styleButtonNeutral(searchForInstructorButton)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
