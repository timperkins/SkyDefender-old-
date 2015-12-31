import UIKit
import SpriteKit

class Missle: SKShapeNode, MovingBodyTrait {
    var angle: CGFloat = 0
    var movingSpeed = CGFloat(400)
    var damage: Int?
    init(position: CGPoint, angle: CGFloat = 0, damage: Int = 10) {
        super.init()

        self.angle = angle
        let rect = CGRect(origin: CGPoint(x: 0, y: -8), size: CGSize(width: 1, height: 8))
        self.damage = damage
        self.path = CGPathCreateWithRect(rect, nil)
        self.lineWidth = 0
        self.fillColor = UIColor(red: 1, green: 1, blue: 0.8, alpha: 1)
        self.zRotation = CGFloat(M_PI) - angle
        
        self.position = position
        self.zPosition = 4
        physicsBody = SKPhysicsBody(rectangleOfSize: rect.size)
        physicsBody?.dynamic = true
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.categoryBitMask = CollisionCategories.Missle
        physicsBody?.contactTestBitMask = CollisionCategories.Bg | CollisionCategories.Plane | CollisionCategories.Bomb
        physicsBody?.collisionBitMask = 0
        physicsBody?.velocity = CGVector(dx: 0, dy: movingSpeed)
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
        parent?.addChild(Explosion(position: self.position))
        removeFromParent()
        Util.movingBodies.removeObject(self as SKNode)
    }
}
