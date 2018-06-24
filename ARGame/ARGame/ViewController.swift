//
//  ViewController.swift
//  ARGame
//
//  Created by Michael Pompili on 6/24/18.
//  Copyright © 2018 Michael Pompili. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

   
    @IBOutlet weak var sceneView: ARSCNView!
    let config = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.session.run(config)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        self.sceneView.autoenablesDefaultLighting = true
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func reset(_ sender: Any) {
    }
    @IBAction func play(_ sender: Any) {
        self.addNode()
        self.play.isEnabled = false
        
    }
    
    func addNode() {
        let slenderScene = SCNScene(named: "art.scnassets/SlenderMan_Model.scn")
        let slenderNode = slenderScene?.rootNode.childNode(withName: "Slenderman", recursively: false)
        slenderNode?.position = SCNVector3(0,0, -1.5)
        self.sceneView.scene.rootNode.addChildNode(slenderNode!)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let sceneViewTappedOn = sender.view as! SCNView
        let touchCoordinates = sender.location(in: sceneViewTappedOn)
        let hitTest = sceneViewTappedOn.hitTest(touchCoordinates)
        if hitTest.isEmpty {
            print("didn't hit anything")
        } else {
            let results = hitTest.first!
            let node = results.node
            if node.animationKeys.isEmpty {
                self.animateNode(node: node)
            }
            
           print("touched obj")
        }
    }
    
    func animateNode(node: SCNNode) {
        let disappear = CABasicAnimation(keyPath: "opacity")
        disappear.fromValue = node.presentation.opacity
        disappear.toValue = 0
        disappear.duration = 1.5
        node.addAnimation(disappear, forKey: "opacity")
    }


}

