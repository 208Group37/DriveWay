//
//  LearnerLessonRequestViewController.swift
//  DriveWay
//
//  Created by Jake Darby on 30/04/2021.
//

import UIKit

class LearnerLessonRequestViewController: UIViewController {
    
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBAction func submitButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Utilities.styleButtonGreen(submitButton)
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
