//
//  PictureViewController.swift
//  My World
//
//  Created by Parth Mehta on 1/29/24.
//

//Import for UI
import UIKit

//Code for Picture Page

//Constructor
class PictureViewController: UIViewController {
    
    //Element that shows images
    @IBOutlet var imageView: UIImageView!
    
    //Captured image variable
    var capturedImage: UIImage?
    
    //Image to show
    var image: UIImage?

    //Checks to see if Pic Page loaded
    override func viewDidLoad() {
        super.viewDidLoad()

        // Grabs image and shows it
        image = capturedImage
        imageView.image = image
        
    }
    
    //Checks if cancel button is pressed and user is sent to AR Page
    @IBAction func touchRetakeButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    //Saves picture to camera roll
    @IBAction func savePhoto(_ sender: Any) {
        //Saves image
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil);
        //Sends alert when done
        let alert = UIAlertController(title: "Image Saved to Camera Roll", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            //Goes back to ar scene when acknowledged
            self.dismiss(animated: true)
        }))
        //Present the Alert
        self.present(alert, animated: true, completion: nil)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //Makes sure page transition takes up full screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .fullScreen
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
