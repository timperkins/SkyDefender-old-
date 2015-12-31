import SpriteKit

protocol MovingBodyTrait {
    var angle: CGFloat { get set }
    var movingSpeed: CGFloat { get set }
    func updateVelocity(angle: CGFloat)
}