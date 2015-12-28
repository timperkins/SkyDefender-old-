import SpriteKit

class LevelSelectScene: SKScene {
    var levels = Util.levels
    
    override func didMoveToView(view: SKView) {
        let bg = SKShapeNode(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        bg.name = "bg"
        bg.fillColor = Util.darkBlue
        bg.lineWidth = 0
        bg.zPosition = 1
        self.addChild(bg)
        
        initLevelButtons()
        initSmallLogo()
    }
    
    override func willMoveFromView(view: SKView) {
        for node in self.children {
            node.removeFromParent()
        }
    }
    
    func initSmallLogo() {
        let smallLogo = SKSpriteNode(imageNamed: "small-logo")
        smallLogo.position = CGPoint(x: 20, y: size.height-20)
        smallLogo.zPosition = 2
        smallLogo.anchorPoint = CGPoint(x: 0, y: 1)
        addChild(smallLogo)
    }
    
    func initLevelButtons() {
        for level in levels {
            let button = SKShapeNode(rect: CGRect(x: 0, y: 0, width: size.width - 50, height: 50), cornerRadius: 3)
            button.name = "button"
            button.lineWidth = 1
            button.strokeColor = SKColor.whiteColor()
            button.zPosition = 2
            button.position = CGPoint(x: 25, y: size.height/2)
            button.userData = NSMutableDictionary()
            button.userData?.setObject(level, forKey: "level")
            
            let levelOneLabel = SKLabelNode(fontNamed: Util.fontLight)
            levelOneLabel.text = level.title
            levelOneLabel.name = "levelLabel"
            levelOneLabel.fontSize = 30
            levelOneLabel.fontColor = SKColor.whiteColor()
            levelOneLabel.position = CGPoint(x: button.frame.width/2, y: 15)
            levelOneLabel.zPosition = 3
            
            button.addChild(levelOneLabel)
            
            addChild(button)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location = touch!.locationInNode(self)
        let nodesTouched = nodesAtPoint(location)
        
        for nodeTouched in nodesTouched {
            if nodeTouched.name == "button" {
                let button = nodeTouched as! SKShapeNode
                button.fillColor = SKColor.whiteColor()
                let label = button.childNodeWithName("levelLabel") as! SKLabelNode
                label.fontColor = Util.darkBlue
                
                let wait = SKAction.waitForDuration(0.2)
                let run = SKAction.runBlock {
                    let levelScene = LevelScene(size: self.size)
                    levelScene.scaleMode = self.scaleMode
                    levelScene.userData = NSMutableDictionary()
                    let level = button.userData?.valueForKey("level") as! Level
                    levelScene.userData?.setObject(level, forKey: "level")
                    let transitionType = SKTransition.fadeWithDuration(1)
                    self.view?.presentScene(levelScene,transition: transitionType)
                }
                runAction(SKAction.sequence([wait, run]))
            }

        }
    }
}
