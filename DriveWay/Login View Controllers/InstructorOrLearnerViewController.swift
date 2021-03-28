//
//  InstructorOrLearnerViewController.swift
//  DriveWay
//
//  Created by Morgan Eckersley on 28/03/2021.
//

import UIKit

class InstructorOrLearnerViewController: UIViewController {

    @IBOutlet weak var instructorButton: UIButton!
    @IBOutlet weak var learnerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpObjects()
    }
    
    func setUpObjects() {
        Utilities.styleButton(instructorButton)
        Utilities.styleButton(learnerButton)
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
