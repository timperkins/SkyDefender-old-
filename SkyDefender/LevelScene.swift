import SpriteKit
import CoreMotion

class LevelScene: SKScene, SKPhysicsContactDelegate {
    let motionManager: CMMotionManager = CMMotionManager()
    var pauseModal: PauseModal?
    var gameOverModal: GameOverModal?
    var baseHealthBar: BaseHealthBar?
    var background: SKSpriteNode?
    var base: Base?
    var gun: Gun?
    var level: Level?
    var deviceTilt = 0.0
    var levelScore: LevelScore?
    var hideableShellComponents: [String] = [Util.pauseButton, Util.baseHealthBar, Util.levelScore]
    override func didMoveToView(view: SKView) {
        level = userData?.valueForKey("level") as? Level
        background = level!.background
        pauseModal = PauseModal(scene: self)
        gameOverModal = GameOverModal(scene: self)

        levelScore = LevelScore(scene: self)
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
        initAccelerometer()
        initBackground()
        initBase()
        initGround()
        
        var steps = [SKAction]()
        for levelPlane in level!.levelPlanes {
            let doAddPlane = SKAction.runBlock({
                let plane = levelPlane.createPlane()
                self.background!.addChild(plane)
                self.addChild(plane.indicator)
            })
            let doDelay = SKAction.waitForDuration(Double(levelPlane.delay!))
            steps.append(doDelay)
            steps.append(doAddPlane)
        }
        let doSequence = SKAction.sequence(steps)
        runAction(doSequence)
    }
    
    func removeScene() {
        background?.removeAllChildren()
        background?.removeAllActions()
        background?.removeFromParent()
        
        // Remove shell nodes
        pauseModal = nil
        baseHealthBar = nil
        gameOverModal!.close()
        gameOverModal = nil
        levelScore = nil
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        mapPlanePositions()
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
    
    
    func mapPlanePositions() {
        for node in children {
            if node is PlaneIndicator {
                let indicator = node as! PlaneIndicator
                let plane = indicator.plane
                indicator.hidden = intersectsNode(plane.planeNode!)
                if !indicator.hidden {
                    let gap: CGFloat = 4
                    let p = convertPoint(plane.position, fromNode: background!)
                    let xPos: CGFloat = p.x < 0 ? gap : size.width - gap
                    var yPos = (p.x - xPos) * CGFloat(-tan(deviceTilt)) + p.y
                    if yPos > size.height - gap {
                        yPos = size.height - gap
                    }
                    indicator.position = CGPoint(x: xPos, y: yPos)
                }
            }
        }
    }
    
    func returnToLevelSelectScene() {
        removeScene()
        
        let levelSelectScene = LevelSelectScene(size: self.size)
        levelSelectScene.scaleMode = self.scaleMode
        let transitionType = SKTransition.fadeWithDuration(1)
        self.view?.presentScene(levelSelectScene,transition: transitionType)
    }
    
    func hideShellComponents() {
        for node in children {
            if let n = node.name {
                if hideableShellComponents.indexOf(n) != nil {
                    node.hidden = true
                }
            }
            
        }
    }
    
    func showShellComponents() {
        for node in children {
            if let n = node.name {
                print(n)
                if hideableShellComponents.indexOf(n) != nil {
                    node.hidden = false
                }
            }
            
        }
    }
    
    func restartLevel() {
        removeScene()
        
        let levelScene = LevelScene(size: self.size)
        levelScene.scaleMode = self.scaleMode
        levelScene.userData = NSMutableDictionary()
        levelScene.userData?.setObject(self.level!, forKey: "level")
        let transitionType = SKTransition.fadeWithDuration(1)
        self.view?.presentScene(levelScene,transition: transitionType)
    }
    
    func initBackground() {
        background!.zPosition = 1
        background!.name = Util.background
        background!.size = CGSize(width: Util.backgroundLength, height: Util.backgroundLength)
        background!.position = CGPoint(x: size.width/2, y: CGFloat(Util.backgroundAnchorHeight))
        background!.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(x: -Util.backgroundLength/2, y: -Util.backgroundAnchorHeight, width: Util.backgroundLength, height: Util.backgroundLength/2))
        background!.physicsBody?.dynamic = true
        background!.physicsBody?.usesPreciseCollisionDetection = true
        background!.physicsBody?.categoryBitMask = CollisionCategories.Bg
        background!.physicsBody?.contactTestBitMask = CollisionCategories.Missle
        background!.physicsBody?.collisionBitMask = 0
        
        addChild(background!)
    }
    
    func initBase() {
        base = Base()
        background?.addChild(base!)
        baseHealthBar = BaseHealthBar(scene: self, base: base!)
        
        gun = Gun(scene: self)
        base?.addChild(gun!)
    }
    
    func initGround() {
        let ground = SKShapeNode(rect: CGRect(x: Util.backgroundLength/(-2), y: 0, width: Util.backgroundLength, height: -1000))
        ground.fillColor = SKColor(red: 0, green: 0, blue: 0, alpha: 1)
        ground.zPosition = 2
        ground.lineWidth = 0
        ground.position = CGPoint(x: 0, y: base!.size.height*(-1))
        ground.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(x: -Util.backgroundLength/2, y: 0, width: Util.backgroundLength, height: Util.backgroundLength/2))
        ground.physicsBody?.categoryBitMask = CollisionCategories.Ground
        ground.physicsBody?.contactTestBitMask = CollisionCategories.Bomb
        ground.physicsBody?.collisionBitMask = 0
        background?.addChild(ground)
    }
    
    func initAccelerometer() {
        motionManager.deviceMotionUpdateInterval = 0.08
        motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {
            (data: CMDeviceMotion?, error: NSError?) in
            
            // Found here: http://bit.ly/1x90vdx
            let rotation = atan2(data!.gravity.y, data!.gravity.x) + M_PI_2
            
            self.deviceTilt = rotation
            self.background!.zRotation = CGFloat(rotation)
            self.gun?.angle = CGFloat(rotation)
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
                    curMissle.quietExplode()
                }
        }
        
        if ((firstBody.categoryBitMask & CollisionCategories.Missle != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.Plane != 0)) {
                if let curMissle = firstBody.node as? Missle {
                    curMissle.explode()
                }
        }
        
        if ((firstBody.categoryBitMask & CollisionCategories.Missle != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.Bomb != 0)) {
                if let curMissle = firstBody.node as? Missle {
                    curMissle.explode()
                    if let curBomb = secondBody.node as? Bomb {
                        levelStats.score += curBomb.points
                    }
                }
        }
        
        if ((firstBody.categoryBitMask & CollisionCategories.Plane != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.Bg != 0)) {
                if let curPlane = firstBody.node as? Plane {
                    curPlane.flip()
                }
        }
        
        if ((firstBody.categoryBitMask & CollisionCategories.Bomb != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.Base != 0)) {
                if let curBomb = firstBody.node as? Bomb {
                    curBomb.explode()
                }
        }
        
        if ((firstBody.categoryBitMask & CollisionCategories.Bomb != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.Ground != 0)) {
                if let curBomb = firstBody.node as? Bomb {
                    curBomb.explode()
                }
        }
        
        if ((firstBody.categoryBitMask & CollisionCategories.Explosion != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.Base != 0)) {
                if let curExplosion = firstBody.node as? Explosion {
                    if let curBase = secondBody.node as? Base {
                        curBase.hit(curExplosion)
                    }
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
        
        if ((firstBody.categoryBitMask & CollisionCategories.Bomb != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.Explosion != 0)) {
                if let curBomb = firstBody.node as? Bomb {
                    if let curExplosion = secondBody.node as? Explosion {
                        curBomb.hit(curExplosion)
                    }
                }
        }
    }
}
