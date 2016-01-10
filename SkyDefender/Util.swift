import Foundation
import SpriteKit

class Util {
    static let darkBlue = SKColor(red: 66/255, green: 77/255, blue: 89/255, alpha: 1)
    
    static let deviceSize = UIScreen.mainScreen().bounds.size
    static let levels = [Level(
        background: SKSpriteNode(imageNamed: "dark-forest"),
        title: "Level 1",
        levelPlanes: [
            LevelPlane(plane: Plane(), delay: 0, position: CGPoint(x: -1, y: 0.5)),
            LevelPlane(plane: Plane(), delay: 2, position: CGPoint(x: 1, y: 0.4)),
            LevelPlane(plane: Plane(), delay: 2, position: CGPoint(x: 1, y: 0.3)),
            LevelPlane(plane: Plane(), delay: 2, position: CGPoint(x: 1, y: 0.7)),
            LevelPlane(plane: Plane(), delay: 0, position: CGPoint(x: -1, y: 0.6)),
            LevelPlane(plane: Plane(), delay: 0, position: CGPoint(x: -1, y: 0.2))
        ]
    )]
    
    static let backgroundAnchorHeight: CGFloat = 80.0
    static let backgroundLength: CGFloat = (Util.deviceSize.height * 2) + 50
    
    static var healthContext = 0
    static var scoreContext = 1
    
    static let redColor = SKColor(red: 1, green: 0, blue: 0, alpha: 1)
    static let yellowColor = SKColor(red: 1, green: 206/255, blue: 0, alpha: 1)
    static let greenColor = SKColor(red: 0, green: 137/255, blue: 23/255, alpha: 1)
    
    static var movingBodies = [SKNode]()
    
    static let background = "background"
    static let closeModalButton = "closeModalButton"
    static let fontLight = "HelveticaNeue-UltraLight"
    static let fontFat = "AvenirNext-Heavy"
    static let listButton = "listButton"
    static let missleRepeat = "missleRepeat"
    static let offTouch = "offTouch"
    static let onBaseHealthChange = "onBaseHealthChange"
    static let onTouch = "onTouch"
    static let pauseButton = "pauseButton"
    static let pauseModal = "pauseModal"
    static let restartButton = "restartButton"
    static let resumeFlipping = "resumeFlipping"
    static let shootMissle = "shootMissle"
}

extension Array where Element : Equatable {
    mutating func removeObject(object : Generator.Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
}