//
//  ViewController.swift
//  ARGame
//
//  Created by Michael Pompili on 6/24/18.
//  Copyright © 2018 Michael Pompili. All rights reserved.
//

import UIKit
import ARKit
import Each
class ViewController: UIViewController {

   
    
    @IBOutlet weak var timer: UILabel!
    var counter = Each(1).seconds
    var countdown = 10
    
    
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
        slenderNode?.position = SCNVector3(rNums(firstNum: -4, secondNum: 4),0, rNums(firstNum: 4, secondNum: -4))
        slenderNode?.pivot = SCNMatrix4Rotate((slenderNode?.pivot)!, Float.pi, 0, 1, 0)
        let constraint = SCNLookAtConstraint(target: sceneView.pointOfView)
        constraint.isGimbalLockEnabled = true
        slenderNode?.constraints = [constraint]
        let moveToOrigin = SCNAction.move(to: SCNVector3(0,0,0), duration: 8)
        let alwaysMove = SCNAction.repeatForever(moveToOrigin)
        slenderNode?.runAction(alwaysMove)

        
        self.sceneView.scene.rootNode.addChildNode(slenderNode!)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let sceneViewTappedOn = sender.view as! SCNView
        let touchCoordinates = sender.location(in: sceneViewTappedOn)
        let hitTest = sceneViewTappedOn.hitTest(touchCoordinates)
        if hitTest.isEmpty {
            print("didn't hit anything")
        } else {
            if self.countdown > 0 {
                let results = hitTest.first!
                let node = results.node
                if node.animationKeys.isEmpty {
                    SCNTransaction.begin()
                    self.animateNode(node: node)
                    SCNTransaction.completionBlock = {
                        node.removeFromParentNode()
                        self.addNode()
                        self.restoreTimer()
                    }
                    SCNTransaction.commit()
                }
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
    
  
        
    
    func setTimer() {
        self.counter.perform { () -> NextStep in
            self.countdown -= 1
            self.timer.text = String(self.countdown)
            if self.countdown == 0 {
                self.timer.text = "you lose"
                return .stop
            }
            return .continue
        }
    }
    
    func restoreTimer() {
        self.countdown = 10
        self.timer.text = String(self.countdown)
    }
    
    @IBAction func reset(_ sender: Any) {
        self.counter.stop()
        self.restoreTimer()
        self.playBttn.isEnabled = true
    }
    
    @IBAction func play(_ sender: Any) {
        sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        self.setTimer()
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

