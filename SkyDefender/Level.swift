import SpriteKit
class Level {
    var background: SKSpriteNode?
    var title: String
    var levelPlanes = [LevelPlane]()
    
    init(background: SKSpriteNode, title: String, levelPlanes: [LevelPlane]) {
        self.background = background
        self.title = title
        self.levelPlanes = levelPlanes
    }
}