import UIKit
import SpriteKit

class LevelPlane {
    var plane: Plane?
    var delay: Int?
    init(plane: Plane, delay: Int, position: CGPoint) {
        self.plane = plane
        self.delay = delay
        
        let planeXPosition: CGFloat = position.x < 0 ? -Util.backgroundLength/2 + 50 : Util.backgroundLength/2 - 50
        let planeYPosition: CGFloat = position.y * Util.backgroundLength/2
        self.plane!.position = CGPoint(x: planeXPosition, y: planeYPosition)
        if planeXPosition > 0 {
            self.plane!.flip()
        }
    }
}
