import UIKit
import SpriteKit

class LevelScore: NSObject {
    var scene: LevelScene?
    var scoreLabel: SKLabelNode!
    
    init(scene: LevelScene) {
        super.init()
        self.scene = scene
        levelStats.addObserver(self, forKeyPath: "score", options: .New, context: &Util.scoreContext)
        setupScore()
    }
    
    deinit {
        levelStats.removeObserver(self, forKeyPath: "score", context: &Util.scoreContext)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &Util.scoreContext {
            if let newValue = change?[NSKeyValueChangeNewKey] {
                updateScore(Int(newValue as! NSNumber))
            }
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    func setupScore() {
        scoreLabel = SKLabelNode(fontNamed: Util.fontFat)
        scoreLabel.text = "000000"
        scoreLabel.name = "levelScore"
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = SKColor.blackColor()
        scoreLabel.position = CGPoint(x: 12, y: scene!.size.height - 12)
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Top
        scoreLabel.zPosition = 7
        scene?.addChild(scoreLabel)
        updateScore()
    }
    
    func updateScore(score: Int = 0) {
        let scoreString = String(score)
        let numLeadingZeros = 6 - scoreString.characters.count
        var leadingZeros = ""
        for _ in 1...numLeadingZeros {
            leadingZeros = leadingZeros + "0"
        }
        scoreLabel.text = leadingZeros + scoreString
    }
}