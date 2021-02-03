//
//  GameScene.swift
//  CookieClicker Shared
//
//  Created by Jonathan Pappas on 2/3/21.
//
#if !os(watchOS)
import GameplayKit
#endif
import SpriteKit
#if !os(macOS)
import UIKit
#endif

var firstHost: Hostable.Type = MainMenu.self
var mega: CGFloat = 1
var w: CGFloat = 1000
var h: CGFloat = 1000
var scene = Scene()
var theScene: Scene { return scene }
var fonty: CGFloat = 20.0 // 9.0

var notSaveScenes: [String] = ["BagScene", "Settings", "MainMenu", "Story", "News"]
func resolveScene() -> Hostable.Type {
    let sce: [Hostable.Type] = []
    let namo = SaveData.currentScene
    return sce.first(where: { "\($0)" == namo }) ?? MainMenu.self
}

class Sprite: SKSpriteNode, SuperTouchable {
    var beforeTouchBegan: () -> () = {}
    var touchBegan: () -> () = {}
    var touchEndedOn: () -> () = {}
    var touchEnd: () -> () = {}
}
class Shape: SKShapeNode, SuperTouchable {
    var beforeTouchBegan: () -> () = {}
    var touchBegan: () -> () = {}
    var touchEndedOn: () -> () = {}
    var touchEnd: () -> () = {}
    var stopAnimating = false
}



class Label: SKLabelNode, SuperTouchable {
    var beforeTouchBegan: () -> () = {}
    var touchBegan: () -> () = {}
    var touchEndedOn: () -> () = {}
    var touchEnd: () -> () = {}
}

class Group: SKNode, SuperTouchable {
    var beforeTouchBegan: () -> () = {}
    var touchBegan: () -> () = {}
    var touchEndedOn: () -> () = {}
    var touchEnd: () -> () = {}
}

var olderSizo: CGSize = .zero
var safeAreaTop: CGFloat = 0
//class GameViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        if let view = self.view as? SKView {
//            w = (UIScreen.main.bounds.size.width / UIScreen.main.bounds.size.height) * 1000
//            scene.scaleMode = .aspectFit
//            view.preferredFramesPerSecond = 60
//            view.presentScene(scene)
//            view.ignoresSiblingOrder = true
//            view.showsFPS = false
//            view.showsNodeCount = false
//            //olderSizo = view.frame.size
//            //safeAreaTop = view.safeAreaInsets.top
//
//            //var offsetHeight: CGFloat = 0
//            //var offsetWidth: CGFloat = 0
//            if let safe = UIApplication.shared.delegate?.window??.safeAreaInsets {
//                //offsetWidth = -safe.right - safe.left
//                safeAreaTop = safe.top
//                //offsetHeight = safe.top// + safe.bottom
//                //scene.frame = CGRect.init(x: 0, y: -100, width: view.frame.width - safe.left - safe.right, height: view.frame.height - safe.top - safe.bottom)
//            }
//        }
//    }
//
//    override var shouldAutorotate: Bool {
//        return false
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return UIInterfaceOrientationMask.portrait
//    }
////
////    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
////        return .portrait
////    }
////
////    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
////        return .portrait
////    }
//
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
//}



import SpriteKit
extension SKNode {
    @discardableResult
    func edit<T: SKNode>(_ this: (T) -> ()) -> T {
        this(self as! T)
        return self as! T
    }
    
    func node<T: SKNode>(_ this: T) -> T {
        addChild(this); return this
    }
    func label(_ w: SKLabelNode) -> SKLabelNode {
        return node(w)
    }
}

extension SKNode: Doable {
    @discardableResult
    func doChildren(_ this: (SKNode) -> ()) -> Self { for i in self.children { this(i) }; return self }
}
protocol Doable { init() }
extension Doable {
    @discardableResult
    func `do`(_ this: (Self) -> ()) -> Self { this(self); return self }
    static func `do`(_ this: (Self) -> ()) -> Self { let foo = self.init(); this(foo); return foo }
}

extension Array where Element: SKNode {
    func `do`(_ this: (Element) -> ()) { for po in self { this(po) } }
    subscript(_ this: String, _ list: String...) -> SKNode? {
        var foo: SKNode? = self.first { $0.name == this }
        for chill in list {
            foo = foo?.children.first { $0.name == chill }
        }
        if foo == nil { print("Warning! self\(list) was not found") }
        return foo
    }
    subscript<T: SKNode>(_ type: T.Type,_ this: String, _ list: String...) -> T? {
        var foo: SKNode? = self.first { $0.name == this }
        for chill in list {
            foo = foo?.children.first { $0.name == chill }
        }
        return foo as? T
    }
}
extension SKNode {
    @discardableResult
    func callAsFunction<T: SKNode>(_ type: T.Type = SKNode.self as! T.Type, _ list: String..., wow: (T) -> ()) -> T? {
        var foo: SKNode? = self
        for chill in list {
            foo = foo?.childNode(withName: chill)
        }
        return foo as? T
    }
    
    func bye() {
        removeFromParent()
    }
}

extension Array where Element == SKLabelNode {
    func accumulatedSize() -> CGSize {
        var bigX: CGFloat = 0
        var bigY: CGFloat = 0
        for i in self {
            bigX = Swift.max(i.frame.width + (i.text?.numberOfLeadingAndTrailingSpaces ?? 0), bigX)
            bigY += i.frame.height + 10
        }
        return .init(width: bigX, height: bigY - 10)
    }
}

var textures = [String:SKTexture]()
func Texture(_ name: String) -> SKTexture {
    if textures[name] == nil {
        textures[name] = SKTexture(imageNamed: name)
    }
    return textures[name]!
}

public func eraseAllData() {
    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    UserDefaults.standard.synchronize()
}

var rememberTouchBegan = [SKNode]()
extension Array where Element == SKNode {
    func touchBegan() {
        _ = map {
            ($0 as? SuperTouchable)?.beforeTouchBegan()
        }
        _ = map {
            ($0 as? SuperTouchable)?.touchBegan()
        }
        rememberTouchBegan += self
    }
    func touchEnd() {
        _ = rememberTouchBegan.map {
            ($0 as? SuperTouchable)?.touchEnd()
        }
        _ = map {
            if rememberTouchBegan.contains($0) { ($0 as? SuperTouchable)?.touchEndedOn() }
        }
        rememberTouchBegan = []
    }
}
extension SKNode {
    var width: CGFloat { frame.width }
    var height: CGFloat { frame.height }
    var halfWidth: CGFloat { return width.half }
    var halfHeight: CGFloat { return height.half }
}

extension CGSize {
    static var fullScreen: CGSize { return .init(width: w, height: h) }
}
extension CGPoint {
    static var midScreen: CGPoint { return .init(x: w / 2, y: h / 2) }
    static var half: CGPoint { return .init(x: 0.5, y: 0.5) }
}
extension CGSize {
    var padding: CGSize {
        return .init(width: width + 20, height: height + 20)
    }
}
extension CGFloat {
    var half: CGFloat { self / 2 }
}

protocol SuperTouchable {
    var beforeTouchBegan: () -> () { get set }
    var touchBegan: () -> () { get set }
    var touchEnd: () -> () { get set }
    var touchEndedOn: () -> () { get set }
}


class Scene: SKScene {
    
    var host: Hostable = MainMenu()
    var previouslyHosted: [String:Hostable] = [:]
    
    var isLoading = false
    
//    override func didChangeSize(_ oldSize: CGSize) {
//        if olderSizo != .zero, size != oldSize {
//            host.reset()
//            (w, h) = (h, w)
//        }
//    }
    
    func loading() {
        
        if let blocko = childNode(withName: "Blocko") {
            blocko.removeFromParent()
        }
        let blocko = SKShapeNode.init(rectOf: CGSize.init(width: 4 * w, height: 4 * h))
        blocko.fillColor = backgroundColor//.black// .white// SaveData.Settings.chatBoxColor == "White" ? .white : .black
        blocko.strokeColor = backgroundColor//.black// .white// SaveData.Settings.chatBoxColor == "White" ? .white : .black
        blocko.alpha = 0
        blocko.zPosition = 10000000
        addChild(blocko)
        blocko.name = "Blocko"
        blocko.run(.fadeIn(withDuration: 0.1))
        
        if let loader = childNode(withName: "Loader") {
            loader.removeFromParent()
        }
//        if SaveData.Settings.wittyLoadingText {
//            let loaderNode = ChatBox.InfinityText(["Loading..."] + (SaveData.Settings.loadingText.randomElement() ?? ["oof."]))
//            loaderNode.zPosition = .infinity
//            loaderNode.name = "Loader"
//            loaderNode.alpha = 1
//            loaderNode.zPosition = 20000000
//            loaderNode.position = .init(x: (w / 2) - (loaderNode.width / 2), y: (h / 2) - (loaderNode.height / 2))
//            addChild(loaderNode)
//        }
    }
    func finishedLoading() {
        isLoading = false
        if let loader = childNode(withName: "Loader") {
            loader.alpha = 0
            loader.run(.fadeOut(withDuration: 0.1)) {
                loader.removeFromParent()
            }
//            loader.run(.fadeOut(withDuration: 0.1)) {
//                loader.removeFromParent()
//            }
        }
        if let blocko = childNode(withName: "Blocko") {
            blocko.run(.fadeOut(withDuration: 0.1)) {
                blocko.removeFromParent()
            }
        }
    }
    
    override init() {
        let foo = DispatchQueue.init(label: "foo")
        super.init(size: .init(width: w, height: h))
        //physicsWorld.contactDelegate = self
        isLoading = true
        //musical(.begin)
        backgroundColor = .white
        foo.async { [self] in
            self.loading()
            self.anchorPoint = .zero
            self.backgroundColor = .white
            
            self.addChild(self.host.this)
            self.addChild(self.host.that)
            
            self.host.this.name = "THIS"
            self.host.that.name = "THAT"
            
            self.host.begin()
            
            self.previouslyHosted["\(type(of: self.host))"] = self.host
            self.finishedLoading()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func checkIfPresenting() -> Bool { return host.this.hasActions() || host.that.hasActions() }
    var originalLocation = CGPoint.zero
    
    #if os(macOS)
    
    override func mouseDown(with event: NSEvent) {
        //view?.window?.acceptsMouseMovedEvents = true // For mouse moving without clicking!
        let e = event
        let pos = e.location(in: self)
        if checkIfPresenting() { return }
        let thisNodes = nodes(at: pos)
        originalLocation = pos
        prevLoc = pos
        host.touchBegan(pos, thisNodes)
    }
    override func mouseUp(with event: NSEvent) {
        if checkIfPresenting() { return }
        let e = event
        let pos = e.location(in: self)
        let thisNodes = nodes(at: pos)
        host.touchEnded(pos, thisNodes)
    }
    
    var prevLoc: CGPoint = .zero
    override func mouseDragged(with event: NSEvent) {
        if checkIfPresenting() { return }
        let loc = event.location(in: self)
        let d = CGVector(dx: (loc.x - prevLoc.x), dy: (loc.y - prevLoc.y))
        prevLoc = loc
        host.touchMoved(d)
    }
    
    #else
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if checkIfPresenting() { return }
        let thisNodes = touches.reduce([SKNode]()) { (foo, bar) -> [SKNode] in
            if bar.phase == .began {
                return foo + nodes(at: bar.location(in: self))
            } else {
                return foo
            }
        }
        guard let pos = touches.first?.location(in: self) else {return}
        originalLocation = pos
        host.touchBegan(pos, thisNodes)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if checkIfPresenting() { return }
        let thisNodes = touches.reduce([SKNode]()) { (foo, bar) -> [SKNode] in
            if bar.phase == .ended || bar.phase == .cancelled {
                return foo + nodes(at: bar.location(in: self))
            } else {
                return foo
            }
        }
        guard let pos = touches.first?.location(in: self) else {return}
        //let prevLoc = touches.first?.previousLocation(in: self) ?? pos
        //print(CGVector.init(dx: pos.x - originalLocation.x, dy: pos.y - originalLocation.y))
        //(host as? SuperHostable)?.swiped(CGVector.init(dx: pos.x - originalLocation.x, dy: pos.y - originalLocation.y))
        host.touchEnded(pos, thisNodes)
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if checkIfPresenting() { return }
        touchesEnded(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if checkIfPresenting() { return }
        for i in touches {
            if i.phase == .moved {
                let loc = i.location(in: self)
                let prevLoc = i.previousLocation(in: self)
                let d = CGVector(dx: (loc.x - prevLoc.x), dy: (loc.y - prevLoc.y))
                host.touchMoved(d)
            }
        }
    }
    #endif
    
    
    #if os(tvOS)
    let curserNode = SKShapeNode(circleOfRadius: 10)
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        if curserNode.alpha == 0 {
            curserNode.position = .midScreen
            curserNode.run(.fadeIn(withDuration: 0.2))
            curserNode.fillColor = .white
            curserNode.strokeColor = .black
            curserNode.zPosition = .infinity
        }
        
    }
    override func pressesChanged(_ presses: Set<UIPress>, with event: UIPressesEvent?) {}
    override func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent?) {}
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {}
    #endif
    
    override func update(_ currentTime: TimeInterval) {
        if checkIfPresenting() { return }
        host.update()
        //Music.o.song()
    }
    
    
}

protocol Hostable {
    var that: SKNode { get set }
    var this: SKNode { get set }
    init()
    func begin()
    func update()
    func touchBegan(_ pos: CGPoint,_ nodes: [SKNode])
    func touchMoved(_ moved: CGVector)
    func touchEnded(_ pos: CGPoint,_ nodes: [SKNode])
    func reset()
}
#if !os(macOS)
extension Hostable {
    func backgroundColor(_ to: UIColor) { scene.backgroundColor = to }
}
#endif



extension Hostable {
    func magicReset() {
        this.removeAllChildren()
        that.removeAllChildren()
        begin()
    }
    
    //@discardableResult func Label(_ label: SKLabelNode) -> SKLabelNode { return this.label(label) }
    
    @discardableResult func Image(_ name: ImageNames) -> SKSpriteNode {
        let wowo = SKSpriteNode.init(imageNamed: name.rawValue)
        that.addChild(wowo)
        return wowo
    }
    
    func updateWillEnd() {}
    
    func end(_ with: SKAction) {
        that.run(with) { self.that.removeFromParent() }
        this.run(with) { self.this.removeFromParent(); self.that.removeFromParent() }
    }
    
    func present(_ new: Hostable.Type) {
        
        scene.isLoading = true
        scene.loading()
        
        let foo = DispatchQueue.init(label: "hahaha")
        foo.async { [self] in
            
            //if "\(type(of: self))" == "\(new)" {
              //  scene.host.reset()
               // scene.finishedLoading()
                //return
            //}
            
            //if !notSaveScenes.contains("\(type(of: self))") {
              //  SaveData.savePosition((Int(this.position.x), Int(this.position.y)))
            //}
            if !notSaveScenes.contains("\(new)") {
                SaveData.currentScene = "\(new)"
            }
            
            self.that.run(.wait(forDuration: 0.2)) {
                self.that.removeFromParent()
            }
            self.this.run(.wait(forDuration: 0.2)) {
                self.that.removeFromParent()
                self.this.removeFromParent()
            }
            
            scene.run(.wait(forDuration: 0.3)) {
                if let loaded = scene.previouslyHosted["\(new)"] {
                    scene.host = loaded
                    scene.host.this.alpha = 0
                    scene.host.that.alpha = 0
                    if scene.host.this.parent == nil {
                        scene.addChild(scene.host.this)
                    }
                    if scene.host.that.parent == nil {
                        scene.addChild(scene.host.that)
                    }
                    scene.host.this.name = "THIS"
                    scene.host.that.name = "THAT"
                    scene.host.this.run(.fadeIn(withDuration: 0.2))
                    scene.host.that.run(.fadeIn(withDuration: 0.2))
                    scene.host.reset()
                } else {
                    scene.host = new.init()
                    scene.host.this.alpha = 0
                    scene.host.that.alpha = 0
                    scene.host.this.name = "THIS"
                    scene.host.that.name = "THAT"
                    if scene.host.this.parent == nil {
                        scene.addChild(scene.host.this)
                    }
                    if scene.host.that.parent == nil {
                        scene.addChild(scene.host.that)
                    }
                    scene.host.this.run(.fadeIn(withDuration: 0.2))
                    scene.host.that.run(.fadeIn(withDuration: 0.2))
                    scene.host.begin()
                    scene.previouslyHosted["\(new)"] = scene.host
                }
                //if SaveData.Settings.wittyLoadingText {
                //    sleep(1)
                //}
                scene.finishedLoading()
            }
        }
        
    }
}

extension String {
    var numberOfLeadingSpaces: CGFloat {
        var count: CGFloat = 0
        for i in self {
            if i != " " { return count * fonty }
            count += 1
        }
        return count * fonty
    }
    var numberOfLeadingAndTrailingSpaces: CGFloat {
        var count: CGFloat = 0
        for i in self.reversed() {
            if i != " " { return numberOfLeadingSpaces + (count * fonty) }
            count += 1
        }
        return (count * fonty)
    }
}

extension String.SubSequence { var s: String { String(self) } }
extension Character { var s: String { String(self) } }

extension Array where Element == String {
    func backToString() -> String {
        var wow = self.reduce("[") { $0 + "\"" + $1 + "\"" + "," }
        if wow.last == "," { wow = wow.dropLast().s }
        return wow + "]"
    }
}
