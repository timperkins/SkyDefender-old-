import Foundation

class LevelStats: NSObject {
    dynamic var score: Int = 0
    dynamic var gameOver = false
    var gameOverReason = ""
    var didLose = false
    var didWin = false
    
    func lostLevel(reason: String) {
        gameOverReason = reason
        didLose = true
        gameOver = true
    }
}
var levelStats: LevelStats! = LevelStats()