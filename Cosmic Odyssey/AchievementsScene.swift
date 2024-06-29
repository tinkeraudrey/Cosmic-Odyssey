import SpriteKit

class AchievementsScene: SKScene {
    var achievementsLabels: [SKLabelNode] = []
    var backButton: SKLabelNode!
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        
        setupAchievementsLabels()
        setupBackButton()
    }
    
    func setupAchievementsLabels() {
        for (index, achievement) in GameAchievements.achievements.enumerated() {
            let label = SKLabelNode(fontNamed: "Helvetica")
            label.fontSize = 30
            label.fontColor = SKColor.white
            label.position = CGPoint(x: frame.midX, y: frame.maxY - CGFloat(100 + (index * 50)))
            label.zPosition = 100
            label.text = "\(achievement.name): \(achievement.progress)/\(achievement.target)"
            addChild(label)
            achievementsLabels.append(label)
        }
    }
    
    func setupBackButton() {
        backButton = SKLabelNode(fontNamed: "Helvetica")
        backButton.fontSize = 30
        backButton.fontColor = SKColor.white
        backButton.position = CGPoint(x: frame.minX + 100, y: frame.maxY - 50)
        backButton.zPosition = 100
        backButton.text = "Back"
        addChild(backButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if backButton.contains(location) {
            goBackToGameScene()
        }
    }
    
    func goBackToGameScene() {
        let transition = SKTransition.crossFade(withDuration: 1.0)
        if let gameScene = GameScene(fileNamed: "GameScene") {
            gameScene.scaleMode = .aspectFill
            view?.presentScene(gameScene, transition: transition)
        }
    }
}
