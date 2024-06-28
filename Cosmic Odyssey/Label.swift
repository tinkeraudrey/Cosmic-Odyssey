//
//
//
// Created by Swift Goose.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import SpriteKit



class LabelBackground: SKNode {
    
    let bg: SKSpriteNode
    
    override init() {
                
        let moonTexture = SKTexture(imageNamed: "moon")
        bg = SKSpriteNode(texture: moonTexture)
        bg.size = CGSize(width: 200, height: 200)  // Adjust size as needed
        bg.zPosition = 1
        

        
        super.init()
        
        addChild(bg)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
