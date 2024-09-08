//
//  HelpViewController.swift
//  My World
//
//  Created by Parth Mehta on 1/20/24.
//

//Import for UI
import UIKit

//Code for Help Page

//Constructor
class HelpViewController: UIViewController {

    //Checks to see if Help Page Loaded
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //Checks to see if back button is pressed and sends user back to home page
    @IBAction func touchHelpButton(_ sender: Any) {
        self.dismiss(animated: true)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //Makes sure the transition to other pages uses the full screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .fullScreen
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
