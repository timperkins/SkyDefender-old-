import Foundation
import SpriteKit

class Util {
    static let darkBlue = SKColor(red: 66/255, green: 77/255, blue: 89/255, alpha: 1)
    
    static let deviceSize = UIScreen.mainScreen().bounds.size
    static let levels = [Level(
        background: SKSpriteNode(imageNamed: "dark-forest"),
        title: "Level 1"
    )]
    
    static let backgroundAnchorHeight: CGFloat = 80.0
    static let backgroundLength: CGFloat = (Util.deviceSize.height * 2) + 50
    
    static var movingBodies = [SKNode]()
    
    static let background = "background"
    static let closeModalButton = "closeModalButton"
    static let fontLight = "HelveticaNeue-UltraLight"
    static let listButton = "listButton"
    static let missleRepeat = "missleRepeat"
    static let offTouch = "offTouch"
    static let onTouch = "onTouch"
    static let pauseButton = "pauseButton"
    static let pauseModal = "pauseModal"
    static let shootMissle = "shootMissle"
}