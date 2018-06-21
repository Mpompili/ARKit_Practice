//
//  ViewController.swift
//  Planets
//
//  Created by Michael Pompili on 6/21/18.
//  Copyright © 2018 Michael Pompili. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.session.run(configuration)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let earth = SCNNode(geometry: SCNSphere(radius: 0.2))
        earth.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "Earth")
        earth.position = SCNVector3(0,0,-0.3)
        self.sceneView.scene.rootNode.addChildNode(earth)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

