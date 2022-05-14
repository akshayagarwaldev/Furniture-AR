//
//  ViewController.swift
//  FurnitureAR
//
//  Created by Apple on 20/03/18.
//  Copyright © 2018 hustle. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, TypeDelegate {

    @IBOutlet var sceneView: ARSCNView!
    //pull 1
    var selectedNode = SCNNode()
    var object: String!
    var selectedObjName: String?
    var previousPanPoint: CGPoint?
    let pixelToAngleConstant: Float = .pi / 180
//    var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?

    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var antiBtn: UIButton!
    @IBOutlet weak var rotateBtn: UIButton!
    
    @IBAction func addPressed(_ sender: Any) {
        selectedNode.removeFromParentNode()
        selectedNode.removeAllActions()
        selectedNode = SCNNode()
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUp") as! ModalViewController
        popOverVC.delegate = self
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBtn.layer.cornerRadius = 25
        addBtn.clipsToBounds = true

        let gesture1 = UILongPressGestureRecognizer(target: self, action: #selector(antistartRotation(gesture:)))
        gesture1.minimumPressDuration = 0.1
        antiBtn.addGestureRecognizer(gesture1)
        antiBtn.adjustsImageWhenHighlighted = false
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(startRotation(gesture:)))
        gesture.minimumPressDuration = 0.1
        rotateBtn.addGestureRecognizer(gesture)
        rotateBtn.adjustsImageWhenHighlighted = false
        // Set the view's delegate
        sceneView.delegate = self
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        print(object)
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/main.scn")!
        // Set the scene to the view
        sceneView.scene = scene
        sceneView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:))))

    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        // Run the view's session
        sceneView.session.run(configuration)
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    func handlePan(_ newPoint: CGPoint) {
        if let previousPoint = previousPanPoint {
            let dx = Float(newPoint.x - previousPoint.x)
            let dy = Float(newPoint.y - previousPoint.y)
            
            rotateUp(by: dy * pixelToAngleConstant)
            rotateRight(by: dx * pixelToAngleConstant)
        }
        
        previousPanPoint = newPoint
    }
    
    func rotateUp(by angle: Float) {
        let axis = SCNVector3(1, 0, 0) // x-axis
        rotate(by: angle, around: axis)
    }
    
    func rotateRight(by angle: Float) {
        let axis = SCNVector3(0, 1, 0) // y-axis
        rotate(by: angle, around: axis)
    }
    
    func rotate(by angle: Float, around axis: SCNVector3) {
        let transform = SCNMatrix4MakeRotation(angle, axis.x, axis.y, axis.z)
        selectedNode.transform = SCNMatrix4Mult(selectedNode.transform, transform)
    }
    
    @objc func handleGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            previousPanPoint = gestureRecognizer.location(in: view)
        case .changed:
            handlePan(gestureRecognizer.location(in: view))
        default:
            previousPanPoint = nil
        }
    }
    
    func objectType(desc : String){
        object = desc
        print(object)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        selectedNode.removeFromParentNode()
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: sceneView)
        let hitResults = sceneView.hitTest(location, options: nil)
        
        let results = sceneView.hitTest(touch.location(in: sceneView), types: [.existingPlaneUsingExtent])
        guard let hitFeature = results.last else { return }
        let hitTransform = SCNMatrix4(hitFeature.worldTransform)
        let hitPosition = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
        placeFurniture(position: hitPosition)
        
//        if hitResults.count > 0 {
//            let result = hitResults.first!
//
//            if result.node.name == object{
//                selectedNode = result.node
//                result.node.position = hitPosition
//            }
//            else{
//                placeFurniture(position: hitPosition)
//            }
//        }
        
    }

    
    func placeFurniture(position: SCNVector3){
            if object == "Sofa" {
                
                guard let carScene = SCNScene(named: "art.scnassets/Chair1.dae") else { return }
                let carSceneChildNodes = carScene.rootNode.childNodes
                selectedNode.scale = SCNVector3(0.06, 0.06, 0.06)
                for childNode in carSceneChildNodes {
                    selectedNode.addChildNode(childNode)
                }
                selectedNode.name = object
                selectedNode.position = position
                let fadein = SCNAction.scale(by: 5.0, duration: 0.75)
                selectedNode.runAction(fadein)
                sceneView.scene.rootNode.addChildNode(selectedNode)
                
            }
            else if object == "Sofa Chair"{
                
                guard let carScene = SCNScene(named: "art.scnassets/chair.DAE") else { return }
                let carSceneChildNodes = carScene.rootNode.childNodes
                let fadein = SCNAction.scale(by: 5.0, duration: 0.75)
                selectedNode.scale = SCNVector3(0.0015, 0.0015, 0.0015)
                selectedNode.runAction(fadein)
                
                for childNode in carSceneChildNodes {
                    selectedNode.addChildNode(childNode)
                }
                selectedNode.name = object
                selectedNode.position = position
                sceneView.scene.rootNode.addChildNode(selectedNode)
            }
            else if object == "Chair"{
                
                guard let carScene = SCNScene(named: "art.scnassets/Wooden_Chair.dae") else { return }
                let carSceneChildNodes = carScene.rootNode.childNodes
                selectedNode.scale = SCNVector3(0.12, 0.12, 0.12)
                let fadein = SCNAction.scale(by: 5.0, duration: 0.75)
                for childNode in carSceneChildNodes {
                    selectedNode.addChildNode(childNode)
                }
                selectedNode.runAction(fadein)
                selectedNode.name = object
                selectedNode.position = position
                sceneView.scene.rootNode.addChildNode(selectedNode)
            }
            else if object == "Table"{
                
                let fadein = SCNAction.scale(by: 5.0, duration: 0.75)
                guard let carScene = SCNScene(named: "art.scnassets/Table.dae") else { return }
                let carSceneChildNodes = carScene.rootNode.childNodes
                selectedNode.scale = SCNVector3(0.0017, 0.0017, 0.0017)
                for childNode in carSceneChildNodes {
                    selectedNode.addChildNode(childNode)
                }
                selectedNode.position = position
                selectedNode.runAction(fadein)
                selectedNode.name = object
                sceneView.scene.rootNode.addChildNode(selectedNode)
        }
      
            selectedNode.removeAllAnimations()
        }
    
    @objc func panGesture(_ gesture: UIPanGestureRecognizer) {
        
        selectedNode.removeAllAnimations()
        gesture.minimumNumberOfTouches = 1
        
        let results = self.sceneView.hitTest(gesture.location(in: gesture.view), types: ARHitTestResult.ResultType.featurePoint)
        guard let result: ARHitTestResult = results.first else {
            return
        }
        
        let position = SCNVector3Make(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y, result.worldTransform.columns.3.z)
        selectedNode.position = position
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func antistartRotation(gesture: UILongPressGestureRecognizer){
        if gesture.state == .ended {
            selectedNode.removeAllActions()
        }
            else if gesture.state == .began{
                    let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(-0.05 * Double.pi), z: 0, duration: 0.1))
                    selectedNode.runAction(rotate)
            }
    }
    
    func startRotation(gesture: UILongPressGestureRecognizer){
        if gesture.state == .ended {
            selectedNode.removeAllActions()
        } else if gesture.state == .began{
        let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.05 * Double.pi), z: 0, duration: 0.1))
        selectedNode.runAction(rotate)
    }
    }

}
