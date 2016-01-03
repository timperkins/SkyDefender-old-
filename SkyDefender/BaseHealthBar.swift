import UIKit
import SpriteKit

class BaseHealthBar: NSObject {
    var scene: LevelScene?
    var base: Base?
    var healthBarContainer: SKShapeNode?
    var healthBar: SKShapeNode?
    
    init(scene: LevelScene, base: Base) {
        super.init()
        self.scene = scene
        self.base = base
        self.base!.addObserver(self, forKeyPath: "health", options: .New, context: &Util.healthContext)
        setupHealthBar()
    }
    
    deinit {
        healthBarContainer?.removeFromParent()
        healthBar?.removeFromParent()
        self.base!.removeObserver(self, forKeyPath: "health", context: &Util.healthContext)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &Util.healthContext {
            if let newValue = change?[NSKeyValueChangeNewKey] {
                updateHealthBar(CGFloat(newValue as! NSNumber))
            }
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    func setupHealthBar() {
        let barWidth = abs(scene!.size.width)
        healthBarContainer = SKShapeNode(rect: CGRect(x: 0, y: 0, width: barWidth, height: 3), cornerRadius: 1)
        healthBarContainer?.zPosition = 6
        healthBarContainer?.lineWidth = 0
        healthBarContainer?.position = CGPoint(x: 0, y: 0)
        healthBarContainer?.fillColor = SKColor(red: 1, green: 1, blue: 1, alpha: 1)
        scene!.addChild(healthBarContainer!)
        
        let healthBarWidth = Int(barWidth * CGFloat(base!.health) / 100)
        healthBar = SKShapeNode(rect: CGRect(x: 0, y: 0, width: healthBarWidth, height: 3), cornerRadius: 1)
        healthBar?.zPosition = 7
        healthBar?.lineWidth = 0
        healthBar?.position = CGPoint(x: 0, y: 0)
        healthBarContainer?.addChild(healthBar!)
        
        updateHealthBar(CGFloat(healthBarWidth))
    }
    
    func updateHealthBar(health: CGFloat) {
        let healthBarWidth = health / 100
        healthBar?.xScale = healthBarWidth
        if health < 70 {
            if health < 35 {
                healthBar?.fillColor = Util.redColor
            } else {
                healthBar?.fillColor = Util.yellowColor
            }
        } else {
            healthBar?.fillColor = Util.greenColor
        }
    }
}