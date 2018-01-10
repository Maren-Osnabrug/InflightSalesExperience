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
    let scale: CGFloat = 1
    let rotation: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        addProduct()
        addPinchGestureToSceneView()
        addRotationGestureToSceneView()
//        addPanGestureToSceneView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration and run the view's session
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    // Adds one node to the sceneview, without position specified it spawns at defaults values
    func addProduct(x: Float = 0.0, y: Float = -0.15, z: Float = -0.9) {
        if let product = product, let scene = SCNScene(named: "art.scnassets/\(product.id)/\(product.id).dae") {
            let node = scene.rootNode.childNode(withName: Constants.nodeName, recursively: true)
            node?.eulerAngles.y = -.pi / 2
            let camera = sceneView.pointOfView!
            let position = SCNVector3(x, y, z)
            node?.position = camera.convertPosition(position, to: nil)
            sceneView.scene.rootNode.addChildNode(node!)
        }
    }

//      PRAGMA MARK: - Add Gesture to View
    
    func addPinchGestureToSceneView(){
        let pinchGesture: UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(self.didPinch(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(pinchGesture)
    }
    
    func addRotationGestureToSceneView() {
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(didRotate(_:)))
        rotationGesture.delegate = self
        sceneView.addGestureRecognizer(rotationGesture)
    }

    func addPanGestureToSceneView() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.didPan(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(panGestureRecognizer)
    }
    
//      PRAGMA MARK: OBJC Gesture Functions
    
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
                gesture.scale = scale
            default:
                return
            }
        }
    }
    
    @objc func didRotate(_ gesture: UIRotationGestureRecognizer) {
        guard gesture.state == .changed else { return }

        var point = gesture.location(in: sceneView)
        point = CGPoint(x: point.x, y: point.y)
        
        let hitTestResults = sceneView.hitTest(point)
        guard let node = hitTestResults.first?.node else { return }
        node.eulerAngles.y -= Float(gesture.rotation)
        
        gesture.rotation = rotation
    }
    
    @objc func didPan(withGestureRecognizer sender: UIPanGestureRecognizer) {
        var point = sender.location(in: sceneView)
        point = CGPoint(x: point.x, y: point.y)
        let hitTestResults = sceneView.hitTest(point)
        guard let node = hitTestResults.first?.node else { return }
        let hitTestResultsWithFeaturePoints = sceneView.hitTest(point, types: .featurePoint)
        if let hitTestResultWithFeaturePoints = hitTestResultsWithFeaturePoints.first {
            let translation = hitTestResultWithFeaturePoints.worldTransform.translation
            node.position = SCNVector3(x: translation.x, y: translation.y, z: translation.z)
        }
    }
    
//      PRAGMA MARK: - ARSCNViewDelegate
    
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

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}

