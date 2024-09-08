//
//  MainViewController.swift
//  My World
//
//  Created by Parth Mehta on 1/20/24.
//

//Import for UI
import UIKit

//Code for Home Page

//Constructor
class MainViewController: UIViewController {

    //Makes sure the Page loaded
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //Checks if help button was pressed and sends user to help page
    @IBAction func touchHelpButton(_ sender: Any) {
        self.performSegue(withIdentifier: "moveToHelp", sender: self)
    }
    
    //Checks if AR world button was pressed and sends user to AR page
    @IBAction func touchWorldButton(_ sender: Any) {
        self.performSegue(withIdentifier: "mine", sender: self)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //Makes sure the transition is in the full screen.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .fullScreen
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
