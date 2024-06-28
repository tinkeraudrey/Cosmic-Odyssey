import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var currentLevel: Int = 1
    var remainingCollectibles: Int = 1
    
    var startingTime = Date.now
    var endingTime = Date.now
    
    var lastEndContact = Date.now
    var lastEndContactTime: Double = 0.0
    
    let lockTop = LockTop()
    let lockBase = LockBase()
    let labelBg = LabelBackground()
    let player = Player()
    var collectible = Collectible()
    
    let victory = SKLabelNode(text: "VICTORY ACHIEVED")
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        lockBase.addChild(labelBg)
        lockBase.addChild(player)
        lockBase.addChild(collectible)
        
        addChild(lockTop)
        addChild(lockBase)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if player.ready {
            clearPin()
        } else {

        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        switch currentLevel {
        case 1...4:
            player.zRotation += 0.03 * player.velocity
            
        case 5...9:
            player.zRotation += 0.04 * player.velocity
            
        case 10...14:
            player.zRotation += 0.05 * player.velocity
            
        case 15...20:
            player.zRotation += 0.06 * player.velocity
            
        default:
            player.zRotation += 0.03 * player.velocity
        }
    }
    
    func spawnCollectible() {
        let newCollectible = Collectible()
        lockBase.addChild(newCollectible)
        collectible = newCollectible
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        player.ready = true
        
        startingTime = Date.now
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        lastEndContactTime = Date.now.timeIntervalSince(lastEndContact)
        
        if lastEndContactTime < 1 { return }
        
        player.ready = false
        
        endingTime = Date.now
        
        lastEndContact = Date.now
    }
}

extension GameScene {
    func clearPin() {
        
        player.ready = false
        player.velocity *= -1
        print("remBef: \(remainingCollectibles)")
        remainingCollectibles -= 1
        print("rem: \(remainingCollectibles)")
        
        collectible.run(.sequence([
            .scale(to: 0, duration: 0.1),
            .playSoundFileNamed("pop.m4a", waitForCompletion: false),
            .fadeAlpha(to: 0, duration: 0.1)
        ]), completion: {
            self.collectible.removeFromParent()
            self.spawnCollectible()
        })
    }
}
