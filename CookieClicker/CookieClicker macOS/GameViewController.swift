//
//  GameViewController.swift
//  CookieClicker macOS
//
//  Created by Jonathan Pappas on 2/3/21.
//

import Cocoa
import SpriteKit
import GameplayKit

typealias UIViewController = NSViewController
typealias UIScreen = NSScreen

//class GameViewController: NSViewController {
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
//        
//        skView.showsFPS = true
//        skView.showsNodeCount = true
//    }
//
//}

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as? SKView {
            let mainFrame = UIScreen.main!.frame.size
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
}
