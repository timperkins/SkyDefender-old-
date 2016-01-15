import UIKit
import SpriteKit

class GameOverModal: NSObject {
    var scene: LevelScene?
    var bg: SKShapeNode!
    let gameOverListButton = "gameOverListButton"
    let gameOverRestartButton = "gameOverRestartButton"
    
    init(scene: LevelScene) {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onTouch:", name: Util.onTouch, object: nil)
        levelStats.addObserver(self, forKeyPath: "gameOver", options: .New, context: &Util.gameOverContext)
        self.scene = scene
    }
    
    deinit {
        bg.removeFromParent()
        levelStats.removeObserver(self, forKeyPath: "gameOver", context: &Util.gameOverContext)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &Util.gameOverContext {
            open()
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    @objc func onTouch(notification: NSNotification) {
        let nodesTouched = notification.userInfo!["nodesTouched"] as! [SKNode]
        for node in nodesTouched {
            if node.name == gameOverListButton {
                self.scene!.returnToLevelSelectScene()
            } else if node.name == gameOverRestartButton {
                self.scene!.restartLevel()
            }
        }
    }
    
    func createModal() {
        let bgPath = CGPathCreateWithRoundedRect(CGRect(x: 0, y: 0, width: scene!.size.width-20, height: scene!.size.height-50), 20, 20, nil)
        bg = SKShapeNode(path: bgPath, centered: false)
        bg.fillColor = SKColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        bg.zPosition = 101
        bg.lineWidth = 0
        bg.position = CGPoint(x: 10, y: 40)
        bg.name = "gameOverModal"
        
        let modalTitle = SKLabelNode(fontNamed: Util.fontLight)
        modalTitle.text = "Level Failed!"
        modalTitle.fontSize = 41
        modalTitle.fontColor = SKColor.whiteColor()
        modalTitle.position = CGPoint(x: bg.frame.width/2, y: bg.frame.height-120)
        modalTitle.zPosition = 102
        bg.addChild(modalTitle)
        
        let modalSubTitle = SKLabelNode(fontNamed: Util.fontRegular)
        modalSubTitle.text = levelStats.gameOverReason
        modalSubTitle.fontSize = 21
        modalSubTitle.fontColor = SKColor.whiteColor()
        modalSubTitle.position = CGPoint(x: bg.frame.width/2, y: bg.frame.height/2)
        modalSubTitle.zPosition = 102
        bg.addChild(modalSubTitle)
        
        let listButton = SKSpriteNode(imageNamed: "list")
        listButton.zPosition = 102
        listButton.name = gameOverListButton
        listButton.position = CGPoint(x: bg.frame.width/2 - 50, y: 120)
        bg.addChild(listButton)
        
        let restartButton = SKSpriteNode(imageNamed: "restart")
        restartButton.zPosition = 102
        restartButton.name = gameOverRestartButton
        restartButton.position = CGPoint(x: bg.frame.width/2 + 50, y: 120)
        bg.addChild(restartButton)
    }
    
    func open() {
        scene!.hideShellComponents()
        if bg == nil {
            createModal()
        }
        scene!.addChild(bg)
    }
    
    func close() {
        bg.removeFromParent()
    }
}