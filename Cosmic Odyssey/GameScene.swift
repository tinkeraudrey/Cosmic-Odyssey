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
    var player: Player!
    var collectible: Collectible!
    
    let victory = SKLabelNode(text: "VICTORY ACHIEVED")
    
    var points: Int = 0
    var highScore: Int = UserDefaults.standard.integer(forKey: "highScore")
    
    let pointsLabel = SKLabelNode(fontNamed: "Helvetica")
    let highScoreLabel = SKLabelNode(fontNamed: "Helvetica")
    let gameOverLabel = SKLabelNode(fontNamed: "Helvetica")
    let continueButton = SKLabelNode(fontNamed: "Helvetica")
    let achievementsButton = SKLabelNode(fontNamed: "Helvetica")
    
    var isGameOver = false
    var collectibleTouched = false // Flag to track if collectible was touched
    
    override func didMove(to view: SKView) {
        GameAchievements.loadAchievements()
        physicsWorld.contactDelegate = self
        
        lockBase.addChild(labelBg)
        setupPlayer()
        setupCollectible()
        
        addChild(lockTop)
        addChild(lockBase)
        
        setupLabels()
        setupGameOverScreen()
        setupAchievementsButton()
    }
    
    func setupPlayer() {
        player = Player()
        lockBase.addChild(player)
    }
    
    func setupCollectible() {
        collectible = Collectible()
        lockBase.addChild(collectible)
    }
    
    func setupLabels() {
        pointsLabel.fontSize = 40
        pointsLabel.fontColor = SKColor.white
        pointsLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 200)
        pointsLabel.zPosition = 100
        pointsLabel.text = "Points: \(points)"
        addChild(pointsLabel)
        
        highScoreLabel.fontSize = 30
        highScoreLabel.fontColor = SKColor(red: 254/255, green: 163/255, blue: 207/255, alpha: 1)
        highScoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 250)
        highScoreLabel.zPosition = 100
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
        continueButton.fontColor = SKColor(red: 254/255, green: 163/255, blue: 207/255, alpha: 1)
        continueButton.position = CGPoint(x: frame.midX, y: frame.maxY - 550)
        continueButton.zPosition = 100
        continueButton.text = "Continue"
        continueButton.isHidden = true
        addChild(continueButton)
        
        print("Game Over screen and Continue button added to the scene")
    }
    
    func setupAchievementsButton() {
        achievementsButton.fontSize = 30
        achievementsButton.fontColor = SKColor.white
        achievementsButton.position = CGPoint(x: frame.midX, y: frame.minY + 100)
        achievementsButton.zPosition = 100
        achievementsButton.text = "Achievements"
        addChild(achievementsButton)
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

        GameAchievements.checkAchievements(points: points, collectibles: points)
    }
    
    func spawnCollectible() {
        let newCollectible = Collectible()
        lockBase.addChild(newCollectible)
        collectible = newCollectible
        updatePoints()
        GameAchievements.checkAchievements(points: points, collectibles: points)
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
        
        for t in touches {
            let location = t.location(in: self)
            if achievementsButton.contains(location) {
                goToAchievementsScene()
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isGameOver { return }
        
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
    
    func goToAchievementsScene() {
        let transition = SKTransition.crossFade(withDuration: 1.0)
        let achievementsScene = AchievementsScene(size: self.size)
        achievementsScene.scaleMode = .aspectFill
        self.view?.presentScene(achievementsScene, transition: transition)
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
        remainingCollectibles -= 1
        
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
        
        points = 0
        pointsLabel.text = "Points: \(points)"
        remainingCollectibles = 1
        player.velocity = 1
        player.ready = false
        
        spawnCollectible()
    }
}
