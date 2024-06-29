import SpriteKit

class Player: SKNode {
    
    let ticker: SKSpriteNode!
    var ready = false
    var velocity = CGFloat(-1)
    
    override init() {
        let texture = SKTexture(imageNamed: "Lock_Player")
        ticker = SKSpriteNode(texture: texture, color: .white, size: texture.size())
        
        ticker.position = CGPoint(x: 0, y: 150)
        ticker.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        ticker.setScale(0.80)
        ticker.zPosition = 2
        
        ticker.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        ticker.physicsBody?.isDynamic = true
        ticker.physicsBody?.allowsRotation = false
        ticker.physicsBody?.affectedByGravity = false
    
        ticker.physicsBody?.collisionBitMask = 0

        super.init()
        
        addChild(ticker)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

