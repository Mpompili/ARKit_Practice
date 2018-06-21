//
//  ViewController.swift
//  ARdrawing
//
//  Created by Michael Pompili on 6/20/18.
//  Copyright © 2018 Michael Pompili. All rights reserved.
//

import UIKit
import ARKit
class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var draw: UIButton!
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.showsStatistics = true
        self.sceneView.session.run(configuration)
        self.sceneView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard let pointOfView = sceneView.pointOfView else {return}
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        let location = SCNVector3(transform.m41,transform.m42,transform.m43)
        let currentPositionOfCamera  = orientation + location
        if draw.isHighlighted {
            let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.02))
        sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
            sphereNode.position = currentPositionOfCamera
        self.sceneView.scene.rootNode.addChildNode(sphereNode)
//            print("draw button being pressed")
            print("currentPos: ")
            print(currentPositionOfCamera)
            print("location of cam: ")
            print(location.x, location.y, location.z)
        }
    }

}

func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

