import UIKit
import SpriteKit

class Plane: Life, MovingBodyTrait {
    let theTexture = SKTexture(imageNamed: "plane")
    var planeNode: SKSpriteNode?
    var angle: CGFloat = 0
    var movingSpeed: CGFloat = 60 {
        didSet {
            if movingSpeed > 0 {
                xScale = 1
            } else {
                xScale = -1
            }
        }
    }
    init(movingSpeed: CGFloat = 60) {
        super.init(size: theTexture.size())
        
        // MARK: set properties
        self.movingSpeed = movingSpeed
        
        setupPlaneNode()
        
        // MARK: set SKNode properties
//        self.position = position
        zPosition = 4
        physicsBody = SKPhysicsBody(texture: self.theTexture, size:planeNode!.size)
        physicsBody?.velocity = CGVector(dx: movingSpeed, dy: 0)
        physicsBody?.dynamic = true
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.allowsRotation = false
        physicsBody?.density = 15
        physicsBody?.categoryBitMask = CollisionCategories.Plane
        physicsBody?.contactTestBitMask = CollisionCategories.Bg | CollisionCategories.Explosion
        physicsBody?.collisionBitMask = CollisionCategories.Missle
        
        Util.movingBodies.append(self)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupPlaneNode() {
        planeNode = SKSpriteNode(texture: theTexture)
        planeNode!.size = size
        self.addChild(planeNode!)
    }
    
    func updateVelocity(angle: CGFloat) {
        let vx = cos(angle) * movingSpeed
        let vy = -sin(angle) * movingSpeed
        physicsBody?.velocity = CGVector(dx: vx, dy: vy)
    }
    
    private var canFlip = true
    func flip() {
        if canFlip {
            movingSpeed = -movingSpeed
            canFlip = false
        }
        
        removeActionForKey(Util.resumeFlipping)
        let doResumeFlipping = SKAction.runBlock({
            self.canFlip = true
        })
        let doWait = SKAction.waitForDuration(1)
        let doSequence = SKAction.sequence([doWait, doResumeFlipping])
        runAction(doSequence, withKey: Util.resumeFlipping)
    }
}
