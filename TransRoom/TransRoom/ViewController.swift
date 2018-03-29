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
        
//        // Set the scene to the view
//        sceneView.scene = scene
        
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
    private func addPortal(withTransform transform: matrix_float4x4) {
        isShow = true
        let portalScene = SCNScene(named: "art.scnassets/tjgc.scn")
        
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
