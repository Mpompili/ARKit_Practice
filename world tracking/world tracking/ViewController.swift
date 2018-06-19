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
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func add(_ sender: Any) {
        let node = SCNNode()
        node.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.03)
        node.geometry?.firstMaterial?.specular.contents = UIColor.orange
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.darkGray
        
        let x = randoNumbers(firstNum: -0.3, secondNum: 0.3)
        let y = randoNumbers(firstNum: -0.3, secondNum: 0.3)
        
        node.position = SCNVector3(x, y, -0.3)
        self.sceneView.scene.rootNode.addChildNode(node)
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

