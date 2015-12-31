import SpriteKit
import CoreMotion

class LevelScene: SKScene, SKPhysicsContactDelegate {
    let motionManager: CMMotionManager = CMMotionManager()
    var pauseModal: PauseModal?
    var background: SKSpriteNode?
    var base: SKSpriteNode?
    var gun: Gun?
    var level: Level?
    var deviceTilt = 0.0
    override func didMoveToView(view: SKView) {
        level = userData?.valueForKey("level") as? Level
        background = level!.background
        pauseModal = PauseModal(scene: self)
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
        initAccelerometer()
        initBackground()
        initBase()
        initGround()
        
        let plane = Plane(position: CGPoint(x: -500, y: 400))
        background!.addChild(plane)
        
        let plane2 = Plane(position: CGPoint(x: -510, y: 390))
        background!.addChild(plane2)
        
    }
    
    override func willMoveFromView(view: SKView) {
        background?.removeFromParent()
        pauseModal = nil
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location = touch!.locationInNode(self)
        let nodesTouched = nodesAtPoint(location)
        
        NSNotificationCenter.defaultCenter().postNotificationName(Util.onTouch, object: nil, userInfo: ["nodesTouched": nodesTouched])
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location = touch!.locationInNode(self)
        let nodesTouched = nodesAtPoint(location)
        
        NSNotificationCenter.defaultCenter().postNotificationName(Util.offTouch, object: nil, userInfo: ["nodesTouched": nodesTouched])
    }
    
    func returnToLevelSelectScene() {
        let levelSelectScene = LevelSelectScene(size: self.size)
        levelSelectScene.scaleMode = self.scaleMode
        let transitionType = SKTransition.fadeWithDuration(1)
        self.view?.presentScene(levelSelectScene,transition: transitionType)
    }
    
    func initBackground() {
        background!.zPosition = 1
        background!.name = Util.background
        background!.size = CGSize(width: Util.backgroundLength, height: Util.backgroundLength)
        background!.position = CGPoint(x: size.width/2, y: CGFloat(Util.backgroundAnchorHeight))
        background!.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(x: -Util.backgroundLength, y: -Util.backgroundAnchorHeight, width: Util.backgroundLength*2, height: Util.backgroundLength))
        background!.physicsBody?.dynamic = true
        background!.physicsBody?.usesPreciseCollisionDetection = true
        background!.physicsBody?.categoryBitMask = CollisionCategories.Bg
        background!.physicsBody?.contactTestBitMask = CollisionCategories.Missle
        background!.physicsBody?.collisionBitMask = 0
        
        addChild(background!)
    }
    
    func initBase() {
        base = SKSpriteNode(imageNamed: "base")
        base?.zPosition = 2
        base?.position = CGPoint(x: 0, y: 0)
        base?.anchorPoint = CGPoint(x: 0.5, y: 1)
        background?.addChild(base!)
        
        gun = Gun(scene: self)
        gun?.zPosition = 2
        base?.addChild(gun!)
    }
    
    func initGround() {
        let ground = SKShapeNode(rect: CGRect(x: Util.backgroundLength/(-2), y: 0, width: Util.backgroundLength, height: -1000))
        ground.fillColor = SKColor(red: 0, green: 0, blue: 0, alpha: 1)
        ground.zPosition = 2
        ground.lineWidth = 0
        ground.position = CGPoint(x: 0, y: base!.size.height*(-1))
        background?.addChild(ground)
    }
    
    func initAccelerometer() {
        motionManager.deviceMotionUpdateInterval = 0.08
        motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {
            (data: CMDeviceMotion?, error: NSError?) in
            
            // Found here: http://bit.ly/1MjsNoZ
            let q = data!.attitude.quaternion
            let roll = atan2(2*q.y*q.w-2*q.x*q.z, 1-2*q.y*q.y-2*q.z*q.z)
            self.deviceTilt = roll
            self.background!.zRotation = CGFloat(roll)
            self.gun?.angle = CGFloat(roll)
            
            for node in Util.movingBodies {
                if let movingBody = node as? MovingBodyTrait {
                    movingBody.updateVelocity(movingBody.angle - CGFloat(self.deviceTilt))
                }
            }
        })
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & CollisionCategories.Missle != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.Bg != 0)) {
                if let curMissle = firstBody.node as? Missle {
                    curMissle.removeFromParent()
                    Util.movingBodies.removeObject(curMissle as SKNode)
                }
        }
        
        if ((firstBody.categoryBitMask & CollisionCategories.Missle != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.Plane != 0)) {
                if let curMissle = firstBody.node as? Missle {
                    curMissle.explode()
                }
        }
        
        if ((firstBody.categoryBitMask & CollisionCategories.Plane != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.Explosion != 0)) {
                if let curPlane = firstBody.node as? Plane {
                    if let curExplosion = secondBody.node as? Explosion {
                        curPlane.hit(curExplosion)
                    }
                }
        }
    }
}
