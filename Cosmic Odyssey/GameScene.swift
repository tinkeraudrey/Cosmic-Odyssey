import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var achievementsButton: SKLabelNode!
    var achievements: [GameAchievement] = []
    
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
    var totalPoints: Int = UserDefaults.standard.integer(forKey: "totalPoints")
    
    let pointsLabel = SKLabelNode(fontNamed: "Helvetica")
    let highScoreLabel = SKLabelNode(fontNamed: "Helvetica")
    let gameOverLabel = SKLabelNode(fontNamed: "Helvetica")
    let continueButton = SKLabelNode(fontNamed: "Helvetica")
    
    var isGameOver = false
    var collectibleTouched = false // Flag to track if collectible was touched
    
    override func didMove(to view: SKView) {
        achievements = loadAchievements() // Load saved achievements
        
        physicsWorld.contactDelegate = self
        
        lockBase.addChild(labelBg)
        lockBase.addChild(player)
        lockBase.addChild(collectible)
        
        addChild(lockTop)
        addChild(lockBase)
        
        setupLabels()
        setupGameOverScreen()
        setupAchievementsButton()
    }
    
    func setupAchievementsButton() {
        achievementsButton = SKLabelNode(fontNamed: "Helvetica")
        achievementsButton.fontSize = 30
        achievementsButton.fontColor = SKColor.white
        achievementsButton.position = CGPoint(x: frame.midX, y: frame.maxY - 300)
        achievementsButton.zPosition = 100
        achievementsButton.text = "Achievements"
        addChild(achievementsButton)
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
    
    func updatePoints() {
        points += 1
        totalPoints += 1
        pointsLabel.text = "Points: \(points)"
        UserDefaults.standard.set(totalPoints, forKey: "totalPoints")
        print("Points updated to: \(points)")
        
        if points > highScore {
            highScore = points
            highScoreLabel.text = "High Score: \(highScore)"
            UserDefaults.standard.set(highScore, forKey: "highScore")
            print("New high score: \(highScore)")
        }
        
        player.rotationSpeed += 0.008
        print("Player rotation speed increased to: \(player.rotationSpeed)")
        
        // Check for achievement unlock
        for achievement in achievements {
            if !achievement.isUnlocked && totalPoints >= achievement.goal {
                achievement.isUnlocked = true
                print("Achievement Unlocked: \(achievement.title)")
            }
            achievement.progress = totalPoints
        }
        
        saveAchievements()
    }
    
    func spawnCollectible() {
        let newCollectible = Collectible()
        lockBase.addChild(newCollectible)
        collectible = newCollectible
        updatePoints()
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if player.ready {
            collectibleTouched = true
            clearPin()
        } else {
            collectibleTouched = false
        }
    }
    
    func showAchievements() {
        let achievementsViewController = AchievementsViewController()
        achievementsViewController.achievements = achievements
        view?.window?.rootViewController?.present(achievementsViewController, animated: true, completion: nil)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if achievementsButton.contains(location) {
                showAchievements()
                return
            }
            
            if isGameOver {
                if continueButton.contains(location) {
                    resetGame()
                }
            } else {
                collectibleTouched = false
                touchDown(atPoint: location)
                
                if !collectibleTouched {
                    gameOver()
                }
            }
        }
    }

    func setupAchievements() -> [GameAchievement] {
        var achievements: [GameAchievement] = []

        achievements.append(GameAchievement(title: "Novice Collector", description: "Stellar Fragments collected", isUnlocked: totalPoints >= 10, progress: totalPoints, goal: 10))
        achievements.append(GameAchievement(title: "Star Collector", description: "Stellar Fragments collected", isUnlocked: totalPoints >= 25, progress: totalPoints, goal: 25))
        achievements.append(GameAchievement(title: "Galactic Hoarder", description: "Stellar Fragments collected", isUnlocked: totalPoints >= 50, progress: totalPoints, goal: 50))
        achievements.append(GameAchievement(title: "Cosmic Gatherer", description: "Stellar Fragments collected", isUnlocked: totalPoints >= 75, progress: totalPoints, goal: 75))
        achievements.append(GameAchievement(title: "Interstellar Collector", description: "Stellar Fragments collected", isUnlocked: totalPoints >= 100, progress: totalPoints, goal: 100))
        achievements.append(GameAchievement(title: "Universal Archivist", description: "Stellar Fragments collected", isUnlocked: totalPoints >= 200, progress: totalPoints, goal: 200))
        
        return achievements
    }

    func saveAchievements() {
        if let encodedAchievements = try? JSONEncoder().encode(achievements) {
            UserDefaults.standard.set(encodedAchievements, forKey: "achievements")
        }
    }
    
    func loadAchievements() -> [GameAchievement] {
        if let savedAchievements = UserDefaults.standard.data(forKey: "achievements") {
            if let decodedAchievements = try? JSONDecoder().decode([GameAchievement].self, from: savedAchievements) {
                return decodedAchievements
            }
        }
        return setupAchievements()
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
        collectible.removeFromParent()
        points = 0
        pointsLabel.text = "Points: \(points)"
        remainingCollectibles = 1
        player.velocity = 1
        player.rotationSpeed = 0.03
        player.ready = false
        spawnCollectible()
    }
}

