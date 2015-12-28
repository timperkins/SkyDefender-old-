import UIKit
import SpriteKit

class PauseModal {
    var scene: LevelScene?
    var pauseModalBg: SKShapeNode?
    var pauseButton: SKSpriteNode?
    
    init(scene: LevelScene) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onTouch:", name: Util.onTouch, object: nil)
        self.scene = scene
        showPauseButton()
    }
    
    deinit {
        pauseModalBg?.removeFromParent()
        pauseButton?.removeFromParent()
    }

    @objc func onTouch(notification: NSNotification) {
        let nodesTouched = notification.userInfo!["nodesTouched"] as! [SKNode]
        for node in nodesTouched {
            if node.name == Util.pauseButton {
                open()
            } else if node.name == Util.closeModalButton {
                close()
            } else if node.name == Util.listButton {
                self.scene!.returnToLevelSelectScene()
            }
        }
    }
    
    func showPauseButton() {
        if pauseButton == nil {
            pauseButton = SKSpriteNode(imageNamed: "pause-button")
            pauseButton!.name = Util.pauseButton
            pauseButton!.zPosition = 100
            pauseButton!.position = CGPoint(x: scene!.size.width-30, y: scene!.size.height-30)
        }
        scene!.addChild(pauseButton!)
    }
    
    func hidePauseButton() {
        pauseButton!.removeFromParent()
    }
    
    func createModal() {
        let bgPath = CGPathCreateWithRoundedRect(CGRect(x: 0, y: 0, width: scene!.size.width-20, height: scene!.size.height-20), 20, 20, nil)
        pauseModalBg = SKShapeNode(path: bgPath, centered: false)
        pauseModalBg!.fillColor = SKColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        pauseModalBg!.zPosition = 101
        pauseModalBg!.lineWidth = 0
        pauseModalBg!.position = CGPoint(x: 10, y: 10)
        pauseModalBg!.name = "pauseModal"
        
        let closeButton = SKSpriteNode(imageNamed: "close-button")
        closeButton.position = CGPoint(x: pauseModalBg!.frame.width-30, y: pauseModalBg!.frame.height-30)
        closeButton.zPosition = 102
        closeButton.name = Util.closeModalButton
        pauseModalBg?.addChild(closeButton)
        
        let modalTitle = SKLabelNode(fontNamed: Util.fontLight)
        modalTitle.text = scene!.level!.title
        modalTitle.fontSize = 30
        modalTitle.fontColor = SKColor.whiteColor()
        modalTitle.position = CGPoint(x: pauseModalBg!.frame.width/2, y: pauseModalBg!.frame.height-120)
        modalTitle.zPosition = 102
        pauseModalBg?.addChild(modalTitle)
        
        let listButton = SKSpriteNode(imageNamed: "list")
        listButton.zPosition = 102
        listButton.name = Util.listButton
        listButton.position = CGPoint(x: pauseModalBg!.frame.width/2, y: pauseModalBg!.frame.height-250)
        pauseModalBg?.addChild(listButton)
    }
    
    func open() {
        if pauseModalBg == nil {
            createModal()
        }
        hidePauseButton()
        scene!.addChild(pauseModalBg!)
    }
    
    func close() {
        pauseModalBg?.removeFromParent()
        showPauseButton()
    }
}