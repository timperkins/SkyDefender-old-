import UIKit
import SpriteKit

class LevelPlane {
    var plane: Plane?
    var delay: Int?
    var position: CGPoint?
    
    init(plane: Plane, delay: Int, position: CGPoint) {
        self.plane = plane
        self.delay = delay
        self.position = position
    }
}
