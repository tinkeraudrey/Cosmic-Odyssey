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
    var highScore: Int = UserDefaults.standard.integer(forKey: "highScore")
    
    let pointsLabel = SKLabelNode(fontNamed: "Helvetica")
    let highScoreLabel = SKLabelNode(fontNamed: "Helvetica")
    let gameOverLabel = SKLabelNode(fontNamed: "Helvetica")
    let continueButton = SKLabelNode(fontNamed: "Helvetica")
    
    var isGameOver = false
    var collectibleTouched = false // Flag to track if collectible was touched
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        lockBase.addChild(labelBg)
        lockBase.addChild(player)
        lockBase.addChild(collectible)
        
        addChild(lockTop)
        addChild(lockBase)
        
        setupLabels()
        setupGameOverScreen()
    }
    
    func setupLabels() {
        pointsLabel.fontSize = 40
        pointsLabel.fontColor = SKColor.white // Set font color to white for visibility against black background
        pointsLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 200) // Position at the top center of the screen
        pointsLabel.zPosition = 100  // Ensure the label is on top of other nodes
        pointsLabel.text = "Points: \(points)"
        addChild(pointsLabel)
        
        highScoreLabel.fontSize = 30
        highScoreLabel.fontColor = SKColor(red: 254/255, green: 163/255, blue: 207/255, alpha: 1) // Set font color to #FEA3CF for high score
        highScoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 250) // Position below the points label
        highScoreLabel.zPosition = 100  // Ensure the label is on top of other nodes
        highScoreLabel.text = "High Score: \(highScore)"
        addChild(highScoreLabel)
        
        print("Points and High Score labels added to the scene")
    }
    
    func setupGameOverScreen() {
        gameOverLabel.fontSize = 70
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 450)
        gameOverLabel.zPosition = 100
        gameOverLabel.text = "Game Over"
        gameOverLabel.isHidden = true
        addChild(gameOverLabel)
        
        continueButton.fontSize = 50
        continueButton.fontColor = SKColor(red: 254/255, green: 163/255, blue: 207/255, alpha: 1) // Set font color to #FEA3CF for continue button
        continueButton.position = CGPoint(x: frame.midX, y: frame.maxY - 550)
        continueButton.zPosition = 100
        continueButton.text = "Continue"
        continueButton.isHidden = true
        addChild(continueButton)
        
        print("Game Over screen and Continue button added to the scene")
    }
    
    func updatePoints() {
        points += 1
        pointsLabel.text = "Points: \(points)"
        print("Points updated to: \(points)")
        
        if points > highScore {
            highScore = points
            highScoreLabel.text = "High Score: \(highScore)"
            UserDefaults.standard.set(highScore, forKey: "highScore")
            print("New high score: \(highScore)")
        }
        
        player.rotationSpeed += 0.01 // Increase player rotation speed slightly
        print("Player rotation speed increased to: \(player.rotationSpeed)")
    }
    
    func spawnCollectible() {
        let newCollectible = Collectible()
        lockBase.addChild(newCollectible)
        collectible = newCollectible
        updatePoints()
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if player.ready {
            collectibleTouched = true // Set the flag to true if the collectible was touched
            clearPin()
        } else {
            collectibleTouched = false // Set the flag to false if the collectible was not touched
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameOver {
            for t in touches {
                let location = t.location(in: self)
                if continueButton.contains(location) {
                    resetGame()
                }
            }
        } else {
            collectibleTouched = false // Reset the flag for each new touch
            for t in touches { self.touchDown(atPoint: t.location(in: self)) }
            
            // If the collectible was not touched, end the game
            if !collectibleTouched {
                gameOver()
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isGameOver { return }
        
        player.zRotation += player.rotationSpeed * player.velocity
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if isGameOver { return }
        
        player.ready = true
        
        startingTime = Date.now
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        if isGameOver { return }
        
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
    
    func gameOver() {
        isGameOver = true
        gameOverLabel.isHidden = false
        continueButton.isHidden = false
        player.isHidden = true
        collectible.isHidden = true
    }
    
    func resetGame() {
        isGameOver = false
        gameOverLabel.isHidden = true
        continueButton.isHidden = true
        player.isHidden = false
        
        // Remove the old collectible if it exists
        collectible.removeFromParent()
        
        points = 0
        pointsLabel.text = "Points: \(points)"
        remainingCollectibles = 1
        player.velocity = 1
        player.rotationSpeed = 0.03 // Reset player rotation speed to initial value
        player.ready = false
        
        spawnCollectible()
    }
}
