import UIKit
import SpriteKit

class Bomb: Life, MovingBodyTrait, PointTrait {
    let theTexture = SKTexture(imageNamed: "bomb")
    var bombNode: SKSpriteNode?
    var angle: CGFloat = 0
    var movingSpeed = CGFloat(40)
    var damage: Int?
    var points = 50
    var initialDirection: CGFloat = 0
    init(position: CGPoint, angle: CGFloat = CGFloat(M_PI), damage: Int = 10, initialDirection: CGFloat = 0) {
        super.init(size: theTexture.size(), hideHealthBar: true, health: 1)
        
        self.angle = angle
        self.damage = damage
        self.initialDirection = initialDirection
        explosionSize = 50
        explosionDamage = 20
        self.position = position
        zRotation = initialDirection
        zPosition = 4
        
        setupBombNode()
        initPhysics()
        initRotation()
        
        Util.movingBodies.append(self)
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
    
    override func didExplode() {
        Util.movingBodies.removeObject(self as SKNode)
        levelStats.score += points
    }
    
    func initRotation() {
        let rotate = SKAction.rotateToAngle(-CGFloat(M_PI_2), duration: 1, shortestUnitArc: true)
        runAction(rotate)
    }
    
    func initPhysics() {
        physicsBody = SKPhysicsBody(rectangleOfSize: theTexture.size())
        physicsBody?.dynamic = true
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.categoryBitMask = CollisionCategories.Bomb
        physicsBody?.contactTestBitMask = CollisionCategories.Bg | CollisionCategories.Explosion
        physicsBody?.collisionBitMask = 0
        physicsBody?.velocity = CGVector(dx: -50, dy: 0)
    }
}
