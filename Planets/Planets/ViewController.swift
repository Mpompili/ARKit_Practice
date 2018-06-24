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
        self.sceneView.autoenablesDefaultLighting = true 
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let sun = SCNNode(geometry: SCNSphere(radius: 0.35))
        sun.geometry?.firstMaterial?.diffuse.contents
            = #imageLiteral(resourceName: "sunDiffuse")
        sun.geometry?.firstMaterial?.emission.contents = #imageLiteral(resourceName: "sunDiffuse")
        
        let earthParent = SCNNode()
        let venusParent = SCNNode()
        
        let centerOfUniverse = SCNVector3(0,0,-1.75)

        
        [sun, earthParent, venusParent].forEach {planet in
            planet.position = centerOfUniverse
            self.sceneView.scene.rootNode.addChildNode(planet)
        }
//        self.sceneView.scene.rootNode.addChildNode(sun)
//        self.sceneView.scene.rootNode.addChildNode(
        let earth = planet(geometry: SCNSphere(radius: 0.2), diffuse: #imageLiteral(resourceName: "Earth"), specular: #imageLiteral(resourceName: "earthSpecular"), normal: #imageLiteral(resourceName: "earthNormal"), emission: #imageLiteral(resourceName: "earthEmission"), position: SCNVector3(1.35, 0, 0))
        let venus = planet(geometry: SCNSphere(radius: 0.1), diffuse: #imageLiteral(resourceName: "venusDif"), specular: nil , normal: nil, emission: #imageLiteral(resourceName: "venusEmi"), position: SCNVector3(0.7, 0, 0))
        let moon = planet(geometry: SCNSphere(radius: 0.025), diffuse: #imageLiteral(resourceName: "moonDiffuse"), specular: nil, normal: nil, emission: nil, position: SCNVector3(0.1, 0, 0))
        earthParent.addChildNode(earth)
        venusParent.addChildNode(venus)
        earth.addChildNode(moon)
        
        
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 8)
        let forever = SCNAction.repeatForever(action)
        sun.runAction(forever)
        
        let earthRotation = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 14)
        let venusRotation = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 10)
        let foreverEarth = SCNAction.repeatForever(earthRotation)
        let foreverVenus = SCNAction.repeatForever(venusRotation)
        earthParent.runAction(foreverEarth)
        venusParent.runAction(foreverVenus)
        
        earth.runAction(foreverEarth)
        venus.runAction(foreverVenus)
    }
    
    func planet(geometry: SCNGeometry, diffuse: UIImage, specular: UIImage?, normal: UIImage?, emission: UIImage?, position: SCNVector3) -> SCNNode {
        let planet = SCNNode(geometry: geometry)
        planet.geometry?.firstMaterial?.diffuse.contents = diffuse
        planet.geometry?.firstMaterial?.specular.contents = specular
        planet.geometry?.firstMaterial?.normal.contents = normal
        planet.geometry?.firstMaterial?.emission.contents = emission
        planet.position = position
        return planet
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180 }
}

