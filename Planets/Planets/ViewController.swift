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
        let centerOfUniverse = SCNVector3(0,0,-1.75)
        
        let sun = planet(geometry: SCNSphere(radius: 0.35), diffuse: #imageLiteral(resourceName: "sunDiffuse"), specular: nil, normal: nil, emission: #imageLiteral(resourceName: "sunDiffuse"), position: centerOfUniverse)
        let earth = planet(geometry: SCNSphere(radius: 0.2), diffuse: #imageLiteral(resourceName: "Earth"), specular: #imageLiteral(resourceName: "earthSpecular"), normal: #imageLiteral(resourceName: "earthNormal"), emission: #imageLiteral(resourceName: "earthEmission"), position: SCNVector3(1.35, 0, 0))
        let venus = planet(geometry: SCNSphere(radius: 0.1), diffuse: #imageLiteral(resourceName: "venusDif"), specular: nil , normal: nil, emission: #imageLiteral(resourceName: "venusEmi"), position: SCNVector3(0.7, 0, 0))
        let moon = planet(geometry: SCNSphere(radius: 0.04), diffuse: #imageLiteral(resourceName: "moonDiffuse"), specular: nil, normal: nil, emission: nil, position: SCNVector3(0.35, 0, 0))

        let earthParent = SCNNode()
        let venusParent = SCNNode()
        let moonParent = SCNNode()
        
        [sun, earthParent, venusParent].forEach {planet in
            planet.position = centerOfUniverse
            self.sceneView.scene.rootNode.addChildNode(planet)
        }
    
        moonParent.position = SCNVector3(1.35, 0, 0)
        
        earthParent.addChildNode(earth)
        earthParent.addChildNode(moonParent)
        venusParent.addChildNode(venus)
        moonParent.addChildNode(moon)
        
        let moonRotation = Rotation(time: 5)
        let sunAction = Rotation(time: 8)
        let earthParentRotation = Rotation(time: 14)
        let venusParentRotation = Rotation(time: 10)
        
        sun.runAction(sunAction)
        earthParent.runAction(earthParentRotation)
        venusParent.runAction(venusParentRotation)
        earth.runAction(earthParentRotation)
        venus.runAction(venusParentRotation)
        moonParent.runAction(moonRotation)
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

    func Rotation(time: TimeInterval) -> SCNAction {
        let rotation = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: time)
        let foreverRotation = SCNAction.repeatForever(rotation)
        return foreverRotation
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180 }
}

