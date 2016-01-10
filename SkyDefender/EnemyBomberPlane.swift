import UIKit
import SpriteKit

class EnemyBomberPlane: Plane {
    init() {
        let theTexture = SKTexture(imageNamed: "enemy-bomber-plane")
        let movingSpeed:CGFloat = 60
        let points = 350
        super.init(theTexture: theTexture, movingSpeed: movingSpeed, points: points)
        
        initDropBombs()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initDropBombs() {
        dropNextBomb()
    }
    
    func dropNextBomb() {
        let delay = Double((Double(arc4random_uniform(10)) * 0.1) + 1)
        let doWait = SKAction.waitForDuration(delay)
        let doDrop = SKAction.runBlock({
            let initialDirection = self.movingSpeed > 0 ? 0 : CGFloat(M_PI)
            let bomb = Bomb(position: self.position, initialDirection: initialDirection)
            self.parent?.addChild(bomb)
            self.dropNextBomb()
        })
        let doSequence = SKAction.sequence([doWait, doDrop])
        runAction(doSequence)
    }
}
