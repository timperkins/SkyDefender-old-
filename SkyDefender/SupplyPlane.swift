import UIKit
import SpriteKit

class SupplyPlane: Plane {
    init() {
        let theTexture = SKTexture(imageNamed: "supply-plane")
        let movingSpeed:CGFloat = 20
        let points = -500
        super.init(theTexture: theTexture, movingSpeed: movingSpeed, points: points)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
