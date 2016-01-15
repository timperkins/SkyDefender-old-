import UIKit
import SpriteKit

class Plane: Life, MovingBodyTrait, PointTrait {
    var theTexture: SKTexture!
    var planeNode: SKSpriteNode?
    var indicator: PlaneIndicator!
    var color: SKColor!
    var angle: CGFloat = 0
    var points: Int = 100
    var movingSpeed: CGFloat = 60 {
        didSet {
            if movingSpeed > 0 {
                xScale = 1
            } else {
                xScale = -1
            }
        }
    }
    
    init(theTexture: SKTexture, movingSpeed: CGFloat = 60, points: Int = 100, color: SKColor = SKColor.blackColor()) {
        super.init(size: theTexture.size())
        
        self.theTexture = theTexture
        self.movingSpeed = movingSpeed
        self.points = points
        self.color = color
        
        zPosition = 5
        
        setupPlaneNode()
        setupIndicator()
        initPhysics()
        
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
    
    func setupIndicator() {
        indicator = PlaneIndicator(plane: self)
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
    
    func initPhysics() {
        physicsBody = SKPhysicsBody(texture: self.theTexture, size:planeNode!.size)
        physicsBody?.velocity = CGVector(dx: movingSpeed, dy: 0)
        physicsBody?.dynamic = true
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.allowsRotation = false
        physicsBody?.density = 15
        physicsBody?.categoryBitMask = CollisionCategories.Plane
        physicsBody?.contactTestBitMask = CollisionCategories.Bg | CollisionCategories.Explosion
        physicsBody?.collisionBitMask = CollisionCategories.Missle
    }
    
    override func didExplode() {
        super.didExplode()
        Util.movingBodies.removeObject(self as SKNode)
        levelStats.score += points
    }
}
