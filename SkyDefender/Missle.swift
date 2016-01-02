import UIKit
import SpriteKit

class Missle: Life, MovingBodyTrait {
    var angle: CGFloat = 0
    var movingSpeed = CGFloat(400)
    let rect = CGRect(origin: CGPoint(x: 0, y: -8), size: CGSize(width: 1, height: 8))
    init(position: CGPoint, angle: CGFloat = 0) {
        super.init(size: rect.size, hideHealthBar: true, health: 1)

        explosionSize = 15
        explosionDamage = 20
        self.angle = angle
        zRotation = CGFloat(M_PI) - angle
        self.position = position
        zPosition = 4
        
        setupMissleNode()
        initPhysics()
        
        Util.movingBodies.append(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateVelocity(angle: CGFloat) {
        let vx = sin(angle) * movingSpeed
        let vy = cos(angle) * movingSpeed
        physicsBody?.velocity = CGVector(dx: vx, dy: vy)
    }
    
    func initPhysics() {
        physicsBody = SKPhysicsBody(rectangleOfSize: rect.size)
        physicsBody?.dynamic = true
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.categoryBitMask = CollisionCategories.Missle
        physicsBody?.contactTestBitMask = CollisionCategories.Bg | CollisionCategories.Plane | CollisionCategories.Bomb
        physicsBody?.collisionBitMask = 0
        physicsBody?.velocity = CGVector(dx: 0, dy: movingSpeed)
    }
    
    func setupMissleNode() {
        let missleNode = SKShapeNode()
        missleNode.path = CGPathCreateWithRect(rect, nil)
        missleNode.lineWidth = 0
        missleNode.fillColor = UIColor(red: 1, green: 1, blue: 0.8, alpha: 1)
        self.addChild(missleNode)
    }
    
    override func didExplode() {
        Util.movingBodies.removeObject(self as SKNode)
    }
}
