//
//  ViewController.swift
//  world tracking
//
//  Created by Michael Pompili on 6/18/18.
//  Copyright © 2018 Michael Pompili. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
//
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func add(_ sender: Any) {
        let cylinder = SCNNode(geometry: SCNCylinder(radius: 0.1, height: 0.2))
        cylinder.geometry?.firstMaterial?.diffuse.contents = UIColor.green
        cylinder.position = SCNVector3(0,0,-0.3)
        cylinder.eulerAngles = SCNVector3(0,0,Float(90.degreesToRadians))
        self.sceneView.scene.rootNode.addChildNode(cylinder)
    }
    @IBAction func reset(_ sender: Any) {
        self.restartSession()
    }
    func  restartSession(){
        self.sceneView.session.pause()
        self.sceneView.scene.rootNode.enumerateChildNodes {(node, _) in
            node.removeFromParentNode()
        }
        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func randoNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
        print(CGFloat(arc4random()))
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180}
}
// this is house code
//let doorNode = SCNNode(geometry: SCNPlane(width: 0.03, height: 0.06))
//doorNode.geometry?.firstMaterial?.diffuse.contents = UIColor.brown
//let boxNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
//boxNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
//let node = SCNNode()
//node.geometry = SCNPyramid(width: 0.1, height: 0.1, length: 0.1)
//node.geometry?.firstMaterial?.specular.contents = UIColor.white
//node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
//node.position = SCNVector3(0, 0.05, -0.5)
//
//
//boxNode.position = SCNVector3(0, -0.05, 0)
//doorNode.position = SCNVector3(0, -0.02, 0.051)
//
//self.sceneView.scene.rootNode.addChildNode(node)
//node.addChildNode(boxNode)
//boxNode.addChildNode(doorNode)

