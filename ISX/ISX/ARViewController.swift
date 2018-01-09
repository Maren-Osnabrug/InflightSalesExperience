//
//  ARViewController.swift
//  ISX
//
//  Created by Maren Osnabrug on 02-11-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate, UIGestureRecognizerDelegate {
    @IBOutlet var sceneView: ARSCNView!
    var product: Product?
    var scene: SCNScene?
    var currentAngle: Float?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        currentAngle = -.pi / 2
        addProduct()
//        addTapGestureToSceneView()
//        addPanGestureToSceneView()
        addPinchGestureToSceneView()
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(didRotate(_:)))
        rotationGesture.delegate = self
        sceneView.addGestureRecognizer(rotationGesture)

    }
    
    func addProduct(x: Float = 0.2, y: Float = -0.15, z: Float = -0.7) {
        if let product = product {
            scene = SCNScene(named: "art.scnassets/\(product.id)/\(product.id).scn")!
            let node = scene?.rootNode.childNode(withName: "Cube_bake", recursively: true)
            node?.eulerAngles.y = currentAngle!
            let camera = sceneView.pointOfView!
            let position = SCNVector3(x, y, z)
            node?.position = camera.convertPosition(position, to: nil)
            sceneView.scene.rootNode.addChildNode(node!)
        }
    }
    
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }

    func addPanGestureToSceneView() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.didPan(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(panGestureRecognizer)
    }
    func addPinchGestureToSceneView(){
        let pinchGesture: UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(self.didPinch(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(pinchGesture)
    }

    @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer) {
//        let tapLocation = recognizer.location(in: sceneView)
//        let hitTestResults = sceneView.hitTest(tapLocation)
//        guard let node = hitTestResults.first?.node else {
//            let hitTestResultsWithFeaturePoints = sceneView.hitTest(tapLocation, types: .featurePoint)
//            if let hitTestResultWithFeaturePoints = hitTestResultsWithFeaturePoints.first {
//                let translation = hitTestResultWithFeaturePoints.worldTransform.translation
//                addProduct(x: translation.x, y: translation.y, z: translation.z)
//            }
//            return
//        }
//        node.removeFromParentNode()
    }
    
    /// - Tag: didRotate
    @objc
    func didRotate(_ gesture: UIRotationGestureRecognizer) {
        guard gesture.state == .changed else { return }
        print("point")
        
        var point = gesture.location(in: sceneView)
        point = CGPoint(x: point.x, y: point.y)
        
        let hitTestResults = sceneView.hitTest(point)
        guard let node = hitTestResults.first?.node else { return }
        
        /*
         - Note:
         For looking down on the object (99% of all use cases), we need to subtract the angle.
         To make rotation also work correctly when looking from below the object one would have to
         flip the sign of the angle depending on whether the object is above or below the camera...
         */
        node.eulerAngles.y -= Float(gesture.rotation)
        
        gesture.rotation = 0
    }
    
    func CGPointToSCNVector3(view: SCNView, depth: Float, point: CGPoint) -> SCNVector3 {
        let projectedOrigin = view.projectPoint(SCNVector3Make(0, 0, depth))
        let locationWithz = SCNVector3Make(Float(point.x), Float(point.y), projectedOrigin.z)
        return view.unprojectPoint(locationWithz)
    }
    
    @objc func didPan(withGestureRecognizer sender: UIPanGestureRecognizer) {
        var point = sender.location(in: sceneView)
        point = CGPoint(x: point.x, y: point.y)
        let hitTestResults = sceneView.hitTest(point)
        guard let node = hitTestResults.first?.node else { return }
//        let position = node.position
//        let cgpoint = CGPoint(x: CGFloat(position.x) + point.x, y: CGFloat(position.y) + point.y)
//        node.position = CGPointToSCNVector3(view: sceneView, depth: node.simdPosition.z, point: cgpoint)
        
        //getting the CGpoint at the end of the pan
        let translation = sender.translation(in: sender.view!)
        //creating a new angle in radians from the x value
        var newAngle = (Float)(translation.x)*(Float)(Double.pi)/640.0
        //current angle is an instance variable so i am adding the newAngle to the currentAngle to it
        newAngle += currentAngle!
        
        //transforming the sphere node
        node.transform = SCNMatrix4MakeRotation(newAngle, Float(translation.x), Float(translation.y),Float(0.0))
        
        //getting the end angle of the swipe put into the instance variable
        if(sender.state == .ended) {
            currentAngle = newAngle
        }
    }
    
    @objc func didPinch(withGestureRecognizer gesture: UIPinchGestureRecognizer) {
        if let view = gesture.view {
            switch gesture.state {
            case .changed:
                
                let hitTestResults = sceneView.hitTest(gesture.location(in: view))
                guard let node = hitTestResults.first?.node else { return }

                let pinchScaleX = Float(gesture.scale) * node.scale.x
                let pinchScaleY =  Float(gesture.scale) * node.scale.y
                let pinchScaleZ =  Float(gesture.scale) * node.scale.z

                node.scale = SCNVector3(pinchScaleX, pinchScaleY, pinchScaleZ)
                gesture.scale = 1
            default:
                return
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
    // MARK: - ARSCNViewDelegate
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }

}

//extension float4x4 {
//    var translation: float3 {
//        let translation = self.columns.3
//        return float3(translation.x, translation.y, translation.z)
//    }
//}

