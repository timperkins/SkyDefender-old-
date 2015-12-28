import SpriteKit

class LoadingScene: SKScene {
    override func didMoveToView(view: SKView) {
        let bg = SKShapeNode(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        bg.fillColor = SKColor(red: 53/255, green: 60/255, blue: 66/255, alpha: 1)
        bg.lineWidth = 0
        bg.zPosition = 1
        self.addChild(bg)
        
        let splashImage = SKSpriteNode(imageNamed: "splash-image")
        splashImage.position = CGPoint(x: size.width/2, y: size.height/2)
        splashImage.zPosition = 2
        self.addChild(splashImage)
        
        let wait = SKAction.waitForDuration(0.1)
        let run = SKAction.runBlock {
            let levelSelectScene = LevelSelectScene(size: self.size)
            levelSelectScene.scaleMode = self.scaleMode
            let transitionType = SKTransition.fadeWithDuration(1)
            self.view?.presentScene(levelSelectScene,transition: transitionType)
        }
        runAction(SKAction.sequence([wait, run]))
    }
}
