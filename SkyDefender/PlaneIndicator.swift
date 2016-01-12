import UIKit
import SpriteKit

class PlaneIndicator: SKShapeNode {
    var plane: Plane!
    init(plane: Plane) {
        super.init()
        
        self.plane = plane

        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, 0);
        let radius: CGFloat = 2.5
        CGPathAddArc(path, nil, 0, 0, radius, CGFloat(-M_PI_2), CGFloat(M_PI_2*3), false);
        self.path = path
        
        lineWidth = 0
        fillColor = plane.color
        zPosition = 7
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
