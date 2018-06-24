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
//        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
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
    
    
    
    func addNode() {
        let slenderScene = SCNScene(named: "art.scnassets/SlenderMan_Model.scn")
        let slenderNode = slenderScene?.rootNode.childNode(withName: "Slenderman", recursively: false)
        slenderNode?.position = SCNVector3(rNums(firstNum: -1, secondNum: 1),0, rNums(firstNum: 3, secondNum: -3))
        slenderNode?.pivot = SCNMatrix4Rotate((slenderNode?.pivot)!, Float.pi, 0, 1, 0)
        let constraint = SCNLookAtConstraint(target: sceneView.pointOfView)
        constraint.isGimbalLockEnabled = true
        slenderNode?.constraints = [constraint]
//        let spin = CGFloat(degToRadians(degrees: 180))
//        let rotate = SCNAction.rotateBy(x: 0, y: spin, z: 0, duration: 6)
//        slenderNode?.runAction(rotate)
        //        slenderNode?.rotation.z += degToRadians(degrees: 180)
        
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
                SCNTransaction.begin()
                self.animateNode(node: node)
                SCNTransaction.completionBlock = {
                    node.removeFromParentNode()
                    self.addNode()
                }
                SCNTransaction.commit()
                
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
    
    @IBOutlet weak var playBttn: UIButton!
    @IBAction func reset(_ sender: Any) {
    }

    @IBAction func play(_ sender: Any) {
        self.addNode()
        self.playBttn.isEnabled = false 
    }
    
    
    
}

func rNums(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
    return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
}

func degToRadians(degrees:Double) -> Double{
    return degrees * (.pi / 180);
}
