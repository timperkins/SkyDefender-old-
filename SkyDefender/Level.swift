import SpriteKit
class Level {
    var background: SKSpriteNode?
    var title: String
    
    init(background: SKSpriteNode, title: String) {
        self.background = background
        self.title = title
    }
}