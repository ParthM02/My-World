//
//  WorldViewController.swift
//  My World
//
//  Created by Parth Mehta on 1/29/24.
//

//Imports for UI libaray and AR library used in project
import UIKit
import ARKit
import RealityKit

//Main AR Page

// MARK: - Kill Me

//Constructor Class
class WorldViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, ARSCNViewDelegate{
    
    //AR Config and variables
    private var arView: ARView!
    @IBOutlet weak var sceneView: ARSCNView!
    let config = ARWorldTrackingConfiguration()
    
    //Gesture stuff
    var pinchGesture: UIPinchGestureRecognizer!
    var panGesture: UIPanGestureRecognizer!
    
    //Selected node thingy
    var selectedNode: SCNNode?
    
    //var draggedNode: SCNNode?
    //private var arScene: ARScene!
    
    //Checks if AR Page loaded correctly
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Debug
        //sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        //sceneView.showsStatistics = true
        
        //Runs the AR Scene
        sceneView.session.run(config)
        
        //Creates example pill
        //let capsuleNode = SCNNode(geometry: SCNCapsule(capRadius: 0.03, height: 0.1))
        //capsuleNode.position = SCNVector3(0.1, 0.1, -0.5)
        //sceneView.scene.rootNode.addChildNode(capsuleNode)
        
        // Gesture Recognizers
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
                sceneView.addGestureRecognizer(pinchGesture)
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
                sceneView.addGestureRecognizer(panGesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                sceneView.addGestureRecognizer(tapGesture)
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(_:)))
                sceneView.addGestureRecognizer(rotationGesture)
        
        // Do any additional setup after loading the view.
    }
    // MARK: - Navigation
    //Checks to see if back button was pressed and takes user to Main Menu
    @IBAction func touchBackButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    //Checks to see if take picture button is pressed and takes user to Pic Page
    @IBAction func touchPictureButton(_ sender: Any) {
        let image = sceneView.snapshot()
        print(image)
        self.performSegue(withIdentifier: "picMe", sender: image)
        
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //Makes page changes to the full screen.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .fullScreen
        //Sends snapshot of scene
        if segue.identifier == "picMe" {
            if let destinationVC = segue.destination as? PictureViewController,
               let capturedImage = sender as? UIImage {
                destinationVC.capturedImage = capturedImage
            }
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    // MARK: - Gestures
    //Pinch Gesture
    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        //print("pinch")
            guard let sceneView = gesture.view as? ARSCNView else { return }
            
            // Get the location in the scene
            let touchLocation = gesture.location(in: sceneView)
            
            // Perform a hit test to find the location in the AR scene
            let hitTestResults = sceneView.hitTest(touchLocation, options: nil)
            
            // Find the first object that was hit
            if let hit = hitTestResults.first {
                // Get the node of the object
                let node = hit.node
                
                // Scale the object based on the pinch gesture's scale factor
                let pinchScale = Float(gesture.scale)
                let newScaleX = node.scale.x * pinchScale
                let newScaleY = node.scale.y * pinchScale
                let newScaleZ = node.scale.z * pinchScale
                
                // Apply the scale to the node
                node.scale = SCNVector3(newScaleX, newScaleY, newScaleZ)
                
                // Reset the gesture's scale to 1 (so the scaling is incremental)
                gesture.scale = 1
            }
        }
    
    //Movement Gesture
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        //print("move")
        
        guard let sceneView = gestureRecognizer.view as? ARSCNView else { return }
        
        // Get the location in the scene
        let touchLocation = gestureRecognizer.location(in: sceneView)
        
        // Perform a hit test to find the location in the AR scene
        var hitTestResults = sceneView.hitTest(touchLocation, options: nil)
        
        // Find the first object that was hit
        if let hit = hitTestResults.first {
            // Get the node of the object
            selectedNode = hit.node
        }
        
        guard let selectedNode = selectedNode else { return }

        let location = gestureRecognizer.location(in: sceneView)
        hitTestResults = sceneView.hitTest(location, options: nil)
        
        //Movement
        switch gestureRecognizer.state {
            case .changed:
                if !hitTestResults.isEmpty {
                    let result = hitTestResults[0]
                    if result.node == selectedNode {
                        let translation = gestureRecognizer.translation(in: sceneView)
                        let newPosition = SCNVector3(selectedNode.position.x + Float(translation.x / 1000),
                                                     selectedNode.position.y - Float(translation.y / 1000),
                                                     selectedNode.position.z)
                        selectedNode.position = newPosition
                        gestureRecognizer.setTranslation(CGPoint.zero, in: sceneView)
                    }
                }

            default:
                break
            }
        }
    
    //Delete Gesture
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        print("tap")
        guard let sceneView = gesture.view as? ARSCNView else { return }

        let touchLocation = gesture.location(in: sceneView)

        // Perform a hit test to find the tapped object
        let hitTestResults = sceneView.hitTest(touchLocation, options: [:])

        // Check if an object was hit
        if let hit = hitTestResults.first {
            // Remove the node from the scene
            let node = hit.node
            node.removeFromParentNode()
        }
    }
    
    //Rotation Gesture
    @objc func handleRotation(_ gesture: UIRotationGestureRecognizer) {
        guard let sceneView = gesture.view as? ARSCNView else { return }

        let touchLocation = gesture.location(in: sceneView)

        // Perform a hit test to find the tapped object
        let hitTestResults = sceneView.hitTest(touchLocation, options: [:])

        // Check if an object was hit
        if let hit = hitTestResults.first {
            // Get the node of the object
            let node = hit.node

            switch gesture.state {
            case .changed:
                // Apply rotation incrementally to the node's euler angles
                let rotationX = Float(gesture.rotation) * 1 // Adjust the scale factor as needed
                let rotationY = Float(gesture.rotation) * 1 // Adjust the scale factor as needed
                let rotationZ = Float(gesture.rotation) * 1 // Adjust the scale factor as needed
                
                //node.eulerAngles.x += rotationX
                //node.eulerAngles.y += rotationY
                node.eulerAngles.z -= rotationZ

                // Reset the gesture recognizer's rotation
                gesture.rotation = 0

            default:
                break
            }
        }
    }



    
    
    // MARK: - UICollectionView Datasource and Delegate
    //Makes cells in note/sticker selecter.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Number of cells for now
        return 11
    }
    
    //Determines which cells are stickers and which are notes
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Emojis for the sticker selection
        let emojis = ["😁","😭","😎","🥳","😍","🤮","🔥","❤️","🎩","👑"]
        
        //Makes a singular note cell and 19 sticker ones
        if indexPath.row == 0
        {
            //Creates Note Cell object
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "idStickyNoteCell", for: indexPath) as! NoteCollectionViewCell
            //Label for tests
            let noteText = "🗒️"
            cell.initializeCell(noteText: noteText)
            return cell
        } else {
            //Creates Sticker Cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "idStickerCell", for: indexPath) as! StickerCollectionViewCell
            //Label for tests
            let stickText = "\(emojis[indexPath.row - 1])"
            cell.initializeCell(stickText: stickText)
            return cell
        }
    }
    // MARK: - AR Stuff
    //Checks to see if a cell is pressed
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Prints cell selected
        print("Selected: \(indexPath.row)")
        //Sticker Options
        let emojis = ["😁","😭","😎","🥳","😍","🤮","🔥","❤️","🎩","👑"]
        
        //If the note cell is pressed, note object is created.
        if indexPath.row == 0 {
            
            let frame = sceneView.session.currentFrame
            
            //Finds position and angle of the camera within the space
            let cameraTransform = frame?.camera.transform
            let cameraAngles = frame?.camera.eulerAngles
            let cameraOrientation = SCNVector3((cameraAngles?.x ?? 0) * 180/Float.pi,
                                               (cameraAngles?.y ?? 0) * 180/Float.pi,
                                               (cameraAngles?.z ?? 0) * 180/Float.pi)
            
            let rotationMatrixX = SCNMatrix4MakeRotation(cameraAngles?.x ?? 0, 1, 0, 0) // Pitch
            let rotationMatrixY = SCNMatrix4MakeRotation(cameraAngles?.y ?? 0, 0, 1, 0) // Yaw
            let rotationMatrixZ = SCNMatrix4MakeRotation(cameraAngles?.z ?? 0, 0, 0, 1) // Roll
            
            //Finds rotation matrix
            let rotationMatrix = SCNMatrix4Mult(rotationMatrixZ, SCNMatrix4Mult(rotationMatrixY, rotationMatrixX))
            
            //Interprets roation matrix into camera direction
            let cameraDirection = SCNVector3(-rotationMatrix.m31, -rotationMatrix.m32, -rotationMatrix.m33)
            
            //Make distance from camera
            let distanceFromCamera: Float = 1.0

            //Position of camera
            let cameraPosition = SCNVector3(cameraTransform?.columns.3.x ?? 0,
                                            cameraTransform?.columns.3.y ?? 0,
                                            cameraTransform?.columns.3.z ?? 0)
                    
            // Prints position values
            print(cameraPosition)
            print(cameraDirection)
            
            // create the actual alert controller view that will be the pop-up
            let alertController = UIAlertController(title: "New Note", message: "Write your note", preferredStyle: .alert)

            alertController.addTextField { (textField) in
                // configure the properties of the text field
                textField.placeholder = "Note"
            }
            
            //Node for text
            var node = SCNNode()
            

            // add the buttons/actions to the view controller
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let saveAction = UIAlertAction(title: "Note", style: .default) { _ in

                //Name
                let inputName = alertController.textFields![0].text
                
                //Creates Note Object
                let text = SCNText(string: inputName, extrusionDepth: 0.1)
                let material = SCNMaterial()
                material.diffuse.contents = UIColor.black
                text.materials = [material]
                //let node = SCNNode()
                //node.position = SCNVector3(x:0, y:0.02, z:-0.1)
                node.scale = SCNVector3(x:0.01, y:0.01, z:0.01)
                node.geometry = text
                
                

            }
            
            
            //Sets postion
            node.position = SCNVector3((cameraPosition.x + cameraDirection.x * distanceFromCamera) - 0.1, cameraPosition.y + cameraDirection.y * distanceFromCamera, cameraPosition.z + cameraDirection.z * distanceFromCamera)
            
            //Accomodates for camera angle
            node.eulerAngles.y = cameraAngles?.y ?? 0
            
            //Places into scene
            sceneView.scene.rootNode.addChildNode(node)
            
            
            alertController.addAction(cancelAction)
            alertController.addAction(saveAction)

            present(alertController, animated: true, completion: nil)
        }else{
            //Gets current frame of the AR Space
            let frame = sceneView.session.currentFrame
            
            //Finds position and angle of the camera within the space
            let cameraTransform = frame?.camera.transform
            let cameraAngles = frame?.camera.eulerAngles
            let cameraOrientation = SCNVector3((cameraAngles?.x ?? 0) * 180/Float.pi,
                                               (cameraAngles?.y ?? 0) * 180/Float.pi,
                                               (cameraAngles?.z ?? 0) * 180/Float.pi)
            
            let rotationMatrixX = SCNMatrix4MakeRotation(cameraAngles?.x ?? 0, 1, 0, 0) // Pitch
            let rotationMatrixY = SCNMatrix4MakeRotation(cameraAngles?.y ?? 0, 0, 1, 0) // Yaw
            let rotationMatrixZ = SCNMatrix4MakeRotation(cameraAngles?.z ?? 0, 0, 0, 1) // Roll
            
            //Finds rotation matrix
            let rotationMatrix = SCNMatrix4Mult(rotationMatrixZ, SCNMatrix4Mult(rotationMatrixY, rotationMatrixX))
            
            //Interprets roation matrix into camera direction
            let cameraDirection = SCNVector3(-rotationMatrix.m31, -rotationMatrix.m32, -rotationMatrix.m33)
            
            //Make distance from camera
            let distanceFromCamera: Float = 1

            //Position of camera
            let cameraPosition = SCNVector3(cameraTransform?.columns.3.x ?? 0,
                                            cameraTransform?.columns.3.y ?? 0,
                                            cameraTransform?.columns.3.z ?? 0)
                    
            // Prints position values
            print(cameraPosition)
            print(cameraDirection)
            
            //Creates Emoji Sticker
            let planeGeometry = SCNPlane(width: 0.25, height: 0.25)
            
            let emoji = "\(emojis[indexPath.row - 1])"
            let imageSize = CGSize(width: 100, height: 100)
            if let emojiImage = emojiToImage(text: emoji, size: imageSize) {
                // Create a material
                let material = SCNMaterial()
                material.diffuse.contents = emojiImage
                
                // Apply the material to the plane geometry
                planeGeometry.materials = [material]
            }
            
            //Creates node for sticker
            let planeNode = SCNNode(geometry: planeGeometry)
            
            //Creates new sticker object relative to the camera postion and rotation
            planeNode.position = SCNVector3(cameraPosition.x + cameraDirection.x * distanceFromCamera, cameraPosition.y + cameraDirection.y * distanceFromCamera, cameraPosition.z + cameraDirection.z * distanceFromCamera)
            
            //Adjusts for Camera Angle
            planeNode.eulerAngles.y = cameraAngles?.y ?? 0
            planeNode.eulerAngles.x = cameraAngles?.x ?? 0
            
            
            //Places into ar world
            sceneView.scene.rootNode.addChildNode(planeNode)
            //sceneView.autoenablesDefaultLighting = true
            // Handle selection of collection view item
            // You can start dragging here
            
        }
        
    }
    // MARK: - Emoji to Image
    // Convert an emoji to UIImage - So proud of this
    func emojiToImage(text: String, size: CGSize) -> UIImage? {
        let label = UILabel(frame: CGRect(origin: .zero, size: size))
        label.text = text
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: size.height)
        label.backgroundColor = .clear
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        label.layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
   
}
