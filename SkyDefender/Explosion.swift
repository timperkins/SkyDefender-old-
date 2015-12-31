import UIKit
import SpriteKit

class Explosion: SKShapeNode {
    var damage: CGFloat = 20
    var size: CGFloat = 30
    var id: Int = 0
    init(position: CGPoint, size: CGFloat = 30, damage: CGFloat = 20) {
        super.init()
        
        self.damage = damage
        self.size = size
        
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, 0);
        let radius: CGFloat = 1
        CGPathAddArc(path, nil, 0, 0, radius, CGFloat(-M_PI_2), CGFloat(M_PI_2*3), false);
        self.path = path
        lineWidth = 0
        fillColor = UIColor(red: 1, green: 0, blue: 0.1, alpha: 0.7)
        
        self.position = position
        zPosition = 90
        
        let doGrow = SKAction.scaleTo(size, duration: 0.3)
        let doFade = SKAction.fadeOutWithDuration(0.3)
        let doExplode = SKAction.group([doGrow, doFade])
        
        // Update the physics body as the explosion grows
        let doUpdateWait = SKAction.waitForDuration(1/30)
        let doUpdatePhysicsBody = SKAction.runBlock({
            self.updatePhysicsBody()
        })
        let doUpdateSequence = SKAction.sequence([doUpdateWait, doUpdatePhysicsBody])
        let doUpdate = SKAction.repeatActionForever(doUpdateSequence)
        runAction(doUpdate, withKey: "doUpdate")
        
        
        let doDestroySelf = SKAction.runBlock({
            self.removeFromParent()
        })
        let doAnimation = SKAction.sequence([doExplode, doDestroySelf])
        runAction(doAnimation)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updatePhysicsBody() {
        physicsBody = SKPhysicsBody(circleOfRadius: xScale)
        physicsBody?.dynamic = true
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.categoryBitMask = CollisionCategories.Explosion
        physicsBody?.contactTestBitMask = 0
        physicsBody?.collisionBitMask = 0
    }
    
    func getDamage() -> Int {
        return Int(damage * (1 - (xScale * 0.5 / size)))
    }
}
