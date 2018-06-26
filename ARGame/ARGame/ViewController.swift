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
    var killCount = 0
    
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
       
        let originPoint = SCNVector3(0,0,0)
        let moveToOrigin = SCNAction.move(to: originPoint, duration: Double(rNums(firstNum: 4, secondNum: 6)))
   
            slenderNode?.runAction(moveToOrigin, completionHandler: {
                DispatchQueue.main.async {
                self.timer.text = "you lose"
                self.counter.stop()
                }
            })
        
         self.sceneView.scene.rootNode.addChildNode(slenderNode!)
        
        }

    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let sceneViewTappedOn = sender.view as! SCNView
        let touchCoordinates = sender.location(in: sceneViewTappedOn)
        let hitTest = sceneViewTappedOn.hitTest(touchCoordinates)
        var gettingHit = false
        if hitTest.isEmpty {
            print("didn't hit anything")
        } else {
            
            
            if self.timer.text != "you lose" {
                let results = hitTest.first!
                let node = results.node
                if gettingHit == false {
                    SCNTransaction.begin()
                    gettingHit = true
                    self.animateNode(node: node)
                    SCNTransaction.completionBlock = {
                        self.killCount += 1
                        self.timer.text = String(self.killCount)
                        SCNTransaction.cancelPreviousPerformRequests(withTarget: self)
                        node.removeFromParentNode()
                        self.addNode()
                    }
                    SCNTransaction.commit()
                    gettingHit = false
                }
            }
        
            
            
           print("touched obj")
        }
    }
    
    func animateMovement(node: SCNNode) {
        let moving = CABasicAnimation(keyPath: "position")
        moving.fromValue = SCNVector3(rNums(firstNum: -6, secondNum: 6),0, rNums(firstNum: 6, secondNum: -6))
        moving.toValue = SCNVector3(0, 0, 0)
        moving.duration = 6
        node.addAnimation(moving, forKey: "position")
    }
    
    func animateNode(node: SCNNode) {
        let disappear = CABasicAnimation(keyPath: "opacity")
        disappear.fromValue = node.presentation.opacity
        disappear.toValue = 0
        disappear.duration = 0.5
        node.addAnimation(disappear, forKey: "opacity")
    }
    
    @IBOutlet weak var playBttn: UIButton!
    
    func restoreTimer() {
        self.killCount = 0
        self.timer.text = String(self.killCount)
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
        self.killCount = 0
        self.timer.text = String(self.killCount)
        self.addNode()
        self.playBttn.isEnabled = false
    }
    
}


func rNums(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
    var result = CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    print(result)
    if result > 0 && result < 2 {
        result += 3
    } else if result < 0 && result > -2 {
        result -= 3
    }
    print("after")
    print(result)
    return result
}

func degToRadians(degrees:Double) -> Double{
    return degrees * (.pi / 180);
}

