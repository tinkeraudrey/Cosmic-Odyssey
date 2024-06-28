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
    
    var points: Int = 0
    let pointsLabel = SKLabelNode(fontNamed: "Helvetica")

    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        lockBase.addChild(labelBg)
        lockBase.addChild(player)
        lockBase.addChild(collectible)
        
        addChild(lockTop)
        addChild(lockBase)
        
        setupPointsLabel()
    }
    
    func setupPointsLabel() {
        pointsLabel.fontSize = 40
        pointsLabel.fontColor = SKColor.white // Set font color to white for visibility against black background
        pointsLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 200) // Position at the top center of the screen
        pointsLabel.zPosition = 100  // Ensure the label is on top of other nodes
        pointsLabel.text = "Points: \(points)"
        addChild(pointsLabel)
        print("Points label added to the scene at position: \(pointsLabel.position)")
    }
    
    func updatePoints() {
        points += 1
        pointsLabel.text = "Points: \(points)"
        print("Points updated to: \(points)")
    }
    
    func spawnCollectible() {
        let newCollectible = Collectible()
        lockBase.addChild(newCollectible)
        collectible = newCollectible
        updatePoints()
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

