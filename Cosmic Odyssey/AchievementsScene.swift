import SpriteKit

class AchievementsScene: SKScene {
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        let titleLabel = SKLabelNode(fontNamed: "Helvetica")
        titleLabel.text = "Achievements"
        titleLabel.fontSize = 50
        titleLabel.fontColor = SKColor.white
        titleLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 100)
        addChild(titleLabel)
        
        setupAchievements()
        setupBackButton()
    }
    
    func setupAchievements() {
        for (index, achievement) in GameAchievements.achievements.enumerated() {
            let achievementLabel = SKLabelNode(fontNamed: "Helvetica")
            achievementLabel.text = "\(achievement.name): \(achievement.description)"
            achievementLabel.fontSize = 30
            achievementLabel.fontColor = achievement.isUnlocked ? SKColor.green : SKColor.red
            achievementLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 150 - CGFloat(index * 50))
            addChild(achievementLabel)
        }
    }
    
    func setupBackButton() {
        let backButton = SKLabelNode(fontNamed: "Helvetica")
        backButton.text = "Back"
        backButton.fontSize = 40
        backButton.fontColor = SKColor.white
        backButton.position = CGPoint(x: frame.midX, y: frame.minY + 100)
        backButton.name = "backButton"
        addChild(backButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            let node = self.atPoint(location)
            
            if node.name == "backButton" {
                let transition = SKTransition.fade(withDuration: 0.5)
                if let gameScene = GameScene(fileNamed: "GameScene") {
                    gameScene.scaleMode = .aspectFill
                    view?.presentScene(gameScene, transition: transition)
                }
            }
        }
    }
}
