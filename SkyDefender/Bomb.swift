import UIKit
import SpriteKit

class Bomb: SKSpriteNode, MovingBodyTrait {
    let theTexture = SKTexture(imageNamed: "bomb")
    var angle: CGFloat = 0
    var movingSpeed = CGFloat(40)
    var damage: Int?
    var initialDirection: CGFloat = 0
    var explosionSize: CGFloat = 50
    var explosionDamage: CGFloat = 20
    init(position: CGPoint, angle: CGFloat = CGFloat(M_PI), damage: Int = 10, initialDirection: CGFloat = 0) {
        super.init(texture: theTexture, color: SKColor.clearColor(), size: theTexture.size())
        
        self.angle = angle
        self.damage = damage
        self.initialDirection = initialDirection
        
        self.position = position
        self.zRotation = initialDirection
        self.zPosition = 4
        physicsBody = SKPhysicsBody(rectangleOfSize: theTexture.size())
        physicsBody?.dynamic = true
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.categoryBitMask = CollisionCategories.Bomb
        physicsBody?.contactTestBitMask = CollisionCategories.Bg
        physicsBody?.collisionBitMask = 0
        physicsBody?.velocity = CGVector(dx: -50, dy: 0)
        
        Util.movingBodies.append(self)
        initRotation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateVelocity(angle: CGFloat) {
        let vx = sin(angle) * movingSpeed
        let vy = cos(angle) * movingSpeed
        physicsBody?.velocity = CGVector(dx: vx, dy: vy)
    }
    
    func explode() {
        parent?.addChild(Explosion(position: self.position, size: explosionSize, damage: explosionDamage))
        removeFromParent()
        Util.movingBodies.removeObject(self as SKNode)
    }
    
    func initRotation() {
        let rotate = SKAction.rotateToAngle(-CGFloat(M_PI_2), duration: 1, shortestUnitArc: true)
        runAction(rotate)
    }
}
