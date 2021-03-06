//
//  GameViewController.swift
//  CookieClicker iOS
//
//  Created by Jonathan Pappas on 2/3/21.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as? SKView {
            let mainFrame = UIScreen.main.bounds.size
            w = (mainFrame.width / mainFrame.height) * 1000
            scene.scaleMode = .aspectFit
            view.preferredFramesPerSecond = 60
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = false
            view.showsNodeCount = false
            //view.window?.acceptsMouseMovedEvents = true
            //view.window?.mouseMoved(with: .init())
            //NSEvent().location(in: )
            //NSEvent().locationInWindow
        }
    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let scene = GameScene.newGameScene()
//
//        // Present the scene
//        let skView = self.view as! SKView
//        skView.presentScene(scene)
//
//        skView.ignoresSiblingOrder = true
//        skView.showsFPS = true
//        skView.showsNodeCount = true
//    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
