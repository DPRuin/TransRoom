//
//  ViewController.swift
//  TransRoom
//
//  Created by mac126 on 2018/3/29.
//  Copyright © 2018年 mac126. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    // var session: ARSession!
    private var worldTrackingConfigration: ARWorldTrackingConfiguration!
    private var planeAnthor: ARPlaneAnchor!
    
    /// 是否显示房子
    var isShow: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]

//        // Set the scene to the view
//        sceneView.scene = scene
        //  自动光
        sceneView.automaticallyUpdatesLighting = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        worldTrackingConfigration = ARWorldTrackingConfiguration()
        worldTrackingConfigration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(worldTrackingConfigration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - 私有方法
    func addPortal(withTransform transform: simd_float4x4) {
        isShow = true
        guard let portalScene = SCNScene(named: "art.scnassets/tjgc.scn") else {
            return
        }
        
        let portalNode = portalScene.rootNode.childNode(withName: "tjgc", recursively: true)!
        sceneView.scene.rootNode.addChildNode(portalNode)
        portalNode.position = SCNVector3Make(transform.columns.3.x, transform.columns.3.y - 0.1, transform.columns.3.z - 0.1)
        
        self.addPlane(nodeName: "roof", portalNode: portalNode, imageName: "top")
        self.addPlane(nodeName: "floor", portalNode: portalNode, imageName: "bottom")
        self.addWalls(nodeName: "backWall", portalNode: portalNode, imageName: "back")
        self.addWalls(nodeName: "sideWallA", portalNode: portalNode, imageName: "sideA")
        self.addWalls(nodeName: "sideWallB", portalNode: portalNode, imageName: "sideB")
        self.addWalls(nodeName: "sideDoorA", portalNode: portalNode, imageName: "sideDoorA")
        self.addWalls(nodeName: "sideDoorB", portalNode: portalNode, imageName: "sideDoorB")
        self.addWalls(nodeName: "doorHeader", portalNode: portalNode, imageName: "top")
        self.addNode(nodeName: "tower", portalNode: portalNode, imageName: "")
    }
    
    func addPlane(nodeName: String, portalNode: SCNNode, imageName: String) {
        let child = portalNode.childNode(withName: nodeName, recursively: true)
        child?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/textures/\(imageName).png")
        child?.renderingOrder = 200
    }
    
    func addWalls(nodeName: String, portalNode: SCNNode, imageName: String) {
        let child = portalNode.childNode(withName: nodeName, recursively: true)
        child?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/textures/\(imageName).png")
        child?.renderingOrder = 200
        
        if let mask = child?.childNode(withName: "mask", recursively: true) {
            // 设置渲染顺序，渲染顺序小的优先渲染，从而通过让优先渲染的节点透明使后面渲染的节点也透明
            mask.renderingOrder = 150
            mask.geometry?.firstMaterial?.transparency = 0.00001
        }
        
    }
    
    func addNode(nodeName: String, portalNode: SCNNode, imageName: String) {
        let child = portalNode.childNode(withName: nodeName, recursively: true)
        child?.renderingOrder = 200
    }

}

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            planeAnthor = anchor as! ARPlaneAnchor
            
            if isShow == false {
                // 添加传送门
                addPortal(withTransform: planeAnthor.transform)
            }
        }
    }
    
    
}

extension ViewController: ARSessionObserver {
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
