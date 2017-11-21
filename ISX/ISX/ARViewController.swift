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

class ARViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet var sceneView: ARSCNView!
    var product: Product?
    var scene: SCNScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        addProduct()
        addTapGestureToSceneView()
        addPanGestureToSceneView()
        addPinchGestureToSceneView()
    }
    
    func addProduct(x: Float = 0, y: Float = 0, z: Float = -0.2) {
        if let product = product {
            scene = SCNScene(named: "art.scnassets/\(product.id)/\(product.id).scn")!
            scene?.rootNode.position = SCNVector3(x, y, z)
            let node = scene?.rootNode.childNode(withName: "Cube_bake", recursively: true)
            node?.position = SCNVector3(x, y, z)
            node?.eulerAngles.y = -.pi / 2
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
    
    func CGPointToSCNVector3(view: SCNView, depth: Float, point: CGPoint) -> SCNVector3 {
        let locationWithz = SCNVector3Make(Float(point.x), Float(point.y), depth)
        return view.unprojectPoint(locationWithz)
    }
    
    @objc func didPan(withGestureRecognizer sender: UIGestureRecognizer) {
        let point = sender.location(in: view)
        let hitTestResults = sceneView.hitTest(point)
        print("point : ", point)
        guard let node = hitTestResults.first?.node else { return }
        print("node : ", node.position.x , ", " , node.position.y)
        
//        let result: SCNVector3 = CGPointToSCNVector3(view: sceneView, depth: node.position.z, point: point)
        let result: SCNVector3 = SCNVector3Make(Float(point.x), Float(point.y), 0.0)
        node.position = result
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

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}

