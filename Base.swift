import UIKit
import SpriteKit

class Base: SKSpriteNode {
    let theTexture = SKTexture(imageNamed: "base")
    init(position: CGPoint) {
        super.init(texture: theTexture, color: SKColor.clearColor(), size: theTexture.size())
        self.position = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
