import UIKit
import SpriteKit

class Gun: SKSpriteNode {
    let theTexture = SKTexture(imageNamed: "gun")
    var automaticInterval = 0.2
    var theScene: LevelScene?
    var angle: CGFloat = 0 {
        didSet {
            self.zRotation = angle * -1 + CGFloat(M_PI_2)
            if angle < 0 {
                self.yScale = -1
            } else {
                self.yScale = 1
            }
        }
    }
    init(scene: LevelScene) {
        super.init(texture: theTexture, color: SKColor.clearColor(), size: theTexture.size())
        theScene = scene
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onTouch:", name: Util.onTouch, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "offTouch:", name: Util.offTouch, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func onTouch(notification: NSNotification) {
        let nodesTouched = notification.userInfo!["nodesTouched"] as! [SKNode]
        for node in nodesTouched {
            if node.name == Util.background {
                startFire()
            }
        }
    }
    
    @objc func offTouch(notification: NSNotification) {
        removeActionForKey(Util.missleRepeat)
    }
    
    func startFire() {
        let adj = size.width/2
        let missleDelay = SKAction.waitForDuration(automaticInterval)
        let fireMissle = SKAction.runBlock({
            let missleX = CGFloat(sin(self.angle)) * adj
            let missleY = CGFloat(cos(self.angle)) * adj + self.parent!.position.y
            let missle = Missle(position: CGPoint(x: missleX, y: missleY), angle: self.angle)
            self.theScene?.background?.addChild(missle)
            Util.movingBodies.append(missle)
        })
        let missleSequence = SKAction.sequence([fireMissle, missleDelay])
        let missleRepeat = SKAction.repeatActionForever(missleSequence)
        runAction(missleRepeat, withKey: Util.missleRepeat)
    }
    
    func endFire() {
        removeActionForKey(Util.missleRepeat)
    }
}
