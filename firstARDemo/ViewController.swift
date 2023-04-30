//
//  ViewController.swift
//  firstARDemo
//
//  Created by Ankush on 23/03/23.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    var shipNode: SCNNode?
    var shapeNode: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        
        let shipScene = SCNScene(named: "art.scnassets/ship.scn")
        let shapeScene = SCNScene(named: "art.scnassets/diamond.scn")
        
        shipNode = shipScene?.rootNode
        shapeNode = shapeScene?.rootNode
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "Fruits", bundle: Bundle.main) {
            configuration.trackingImages = trackingImages
            configuration.maximumNumberOfTrackedImages = 4
        }
        
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            
            let size = imageAnchor.referenceImage.physicalSize
            let plane = SCNPlane(width: size.width, height: size.height)
            plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.8)
            plane.cornerRadius = 0.005
            
            let planeNode  = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi/2
            node.addChildNode(planeNode)
            
            if let shapeNode = shipNode {
                node.addChildNode(shapeNode)
            }
        }
        return node
    }
}
