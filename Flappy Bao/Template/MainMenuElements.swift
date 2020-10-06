//
//  MainMenuElements.swift
//  Flappy Bao
//
//  Created by Sidany Walker on 10/6/20.
//

import SpriteKit
import GameplayKit

extension MainMenuScene {
    
    func flyBird() {
        let texture = self.birdFrames![0]
        let bird = SKSpriteNode(texture: texture)
        bird.size = CGSize(width: 50, height: 50)
        bird.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2 + 30)
        bird.zPosition = 2
        let moveUp = SKAction.moveBy(x: 0, y: 20, duration: 0.5)
        
        let sequence = SKAction.sequence([moveUp, moveUp.reversed()])
        
        bird.run(SKAction.repeatForever(sequence), withKey:  "moving")
        addChild(bird)
    }
    
    func mainBackground() {
        let background = SKSpriteNode(imageNamed: "flappyBg")
        background.anchorPoint = CGPoint.init(x: 0, y: 0)
        background.name = "background"
        background.size = (self.view?.bounds.size)!
        background.zPosition = -1
        self.addChild(background)    }

}



