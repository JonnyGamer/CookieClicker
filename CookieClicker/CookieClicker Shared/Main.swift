//
//  Main.swift
//  CookieClicker iOS
//
//  Created by Jonathan Pappas on 2/3/21.
//

import Foundation
import SpriteKit

extension SaveData {
    @UserDefault(key: "cookies", defaultValue: 0)
    static var cookies: Int
}

var buttonSize: CGFloat = 0
typealias MainMenu = Test

struct Test: Hostable {
    init() { this = SKNode(); that = SKNode() }
    var that: SKNode
    var this: SKNode
    
    func begin() {
        backgroundColor(.init(red: 0.8863, green: 0.9255, blue: 0.9569, alpha: 1))
        
        let cookieStatus = Label
            .text("Cookies: \(SaveData.cookies)", parent: that)
            .setSize(maxWidth: w / 2)
            .setPosition(.center, .top)
        func eatCookie(_ num: Int = 1) {
            SaveData.cookies += num
            cookieStatus.text = "Cookies: \(SaveData.cookies)"
            cookieStatus.setPosition(.center, .top)
        }
        
        let foo = Sprite
            .image(.cookie, parent: this)
            .setSize(maxWidth: w / 2, maxHeight: h / 2)
            .setPosition(.center, .center)
        foo.touchBegan = {
            foo.setScale(foo.xScale * 0.9)
            foo.setPosition(.center, .center)
            eatCookie()
        }
        foo.touchEnd = {
            foo.setScale(foo.xScale / 0.9)
            foo.setPosition(.center, .center)
        }
        
        for i in 1...250 {
            let secretCookie = Sprite
                .image(.cookie, parent: that)
                .setSize(maxHeight: 50)
                .setZPosition(-1)
            if i == 250 {// 1000 {
                secretCookie.color = .init(red: 0.9922, green: 0.7686, blue: 0.1765, alpha: 1)
                secretCookie.colorBlendFactor = 1
                secretCookie.speed = 4
                secretCookie.setScale(secretCookie.xScale / 2)
                secretCookie.touchBegan = {
                    eatCookie(100)
                    secretCookie.alpha = 0
                }
            }
            
            secretCookie.run(
                .repeatForever(
                    .sequence([
                        .run {
                            secretCookie.position = CGPoint.init(x: CGFloat((Int(-w-100)...Int(w + 100)).randomElement()!), y: 1100)
                            secretCookie.alpha = 0.5
                            if secretCookie.colorBlendFactor == 1 {
                                secretCookie.alpha = 1
                            }
                        },
                        .wait(forDuration: Double((Int(0)...Int(100)).randomElement()!) / 10),
                        .moveTo(y: -100, duration: 5)
                    ])
                )
            )
        }
        

    }
    
    func update() {
    }
    
    func touchBegan(_ pos: CGPoint, _ nodes: [SKNode]) {
        nodes.touchBegan()
    }
    func touchMoved(_ moved: CGVector) {
        // Makes 'this' draggable
        this.position.x += moved.dx
        this.position.y += moved.dy
    }
    func touchEnded(_ pos: CGPoint, _ nodes: [SKNode]) {
        nodes.touchEnd()
    }
    func reset() {}
}
