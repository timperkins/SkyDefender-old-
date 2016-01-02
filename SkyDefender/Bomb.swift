import UIKit
import SpriteKit

class Bomb: Life, MovingBodyTrait {
    let theTexture = SKTexture(imageNamed: "bomb")
    var bombNode: SKSpriteNode?
    var angle: CGFloat = 0
    var movingSpeed = CGFloat(40)
    var damage: Int?
    var initialDirection: CGFloat = 0
    var explosionSize: CGFloat = 50
    var explosionDamage: CGFloat = 20
    init(position: CGPoint, angle: CGFloat = CGFloat(M_PI), damage: Int = 10, initialDirection: CGFloat = 0) {
        super.init(size: theTexture.size(), hideHealthBar: true, health: 1)
        
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
        physicsBody?.contactTestBitMask = CollisionCategories.Bg | CollisionCategories.Explosion
        physicsBody?.collisionBitMask = 0
        physicsBody?.velocity = CGVector(dx: -50, dy: 0)
        
        Util.movingBodies.append(self)
        setupBombNode()
        initRotation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupBombNode() {
        bombNode = SKSpriteNode(texture: theTexture)
        bombNode!.size = size
        self.addChild(bombNode!)
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
