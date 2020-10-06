//
//  GameElements.swift
//  Flappy Bao
//
//  Created by Sidany Walker on 9/26/20.
//

import Foundation
import SpriteKit
//
struct CollisionBitMask {
    static let birdCategory : UInt32 = 0x1 << 0
    static let Wall : UInt32 = 0x1 << 1
    static let sushiCategory: UInt32 = 0x1 << 2
    static let Ground : UInt32 = 0x1 << 3
    
}
//Extension of the scene in which we will call these functions we will be making
extension LevelOneScene {
    
    func createBird() -> SKSpriteNode {
        //1
        let bird = SKSpriteNode(texture: SKTextureAtlas(named:"player").textureNamed("bird1"))
        bird.size = CGSize(width: 50, height: 50)
        bird.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        bird.zPosition = 3
        //2
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.width / 2)
        bird.physicsBody?.linearDamping = 1.1
        bird.physicsBody?.restitution = 0
        //3
        bird.physicsBody?.categoryBitMask = CollisionBitMask.birdCategory
        bird.physicsBody?.collisionBitMask = CollisionBitMask.Wall | CollisionBitMask.Ground
        bird.physicsBody?.contactTestBitMask = CollisionBitMask.Wall |  CollisionBitMask.Ground
        //4
        bird.physicsBody?.affectedByGravity = false
        bird.physicsBody?.isDynamic = true
        
        return bird
    }
    
    func createRestartBtn() {
        restartBtn = SKSpriteNode(imageNamed: "restart")
        restartBtn.size = CGSize(width:100, height:100)
        restartBtn.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        restartBtn.zPosition = 6
        restartBtn.setScale(0)
        self.addChild(restartBtn)
        restartBtn.run(SKAction.scale(to: 1.0, duration: 0.3))
    }

    func createPauseBtn() {
        pauseBtn = SKSpriteNode(imageNamed: "pause")
        pauseBtn.size = CGSize(width:40, height:40)
        pauseBtn.position = CGPoint(x: self.frame.width - 30, y: 30)
        pauseBtn.zPosition = 6
        self.addChild(pauseBtn)
    }

    func createScoreLabel() -> SKLabelNode {
        let scoreLbl = SKLabelNode()
        scoreLbl.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.6)
        scoreLbl.text = "\(score)"
        scoreLbl.zPosition = 5
        scoreLbl.fontSize = 50
        scoreLbl.fontName = "HelveticaNeue-Bold"
        
        let scoreBg = SKShapeNode()
        scoreBg.position = CGPoint(x: 0, y: 0)
        scoreBg.path = CGPath(roundedRect: CGRect(x: CGFloat(-50), y: CGFloat(-30), width: CGFloat(100), height: CGFloat(100)), cornerWidth: 50, cornerHeight: 50, transform: nil)
        let scoreBgColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(0.0 / 255.0), blue: CGFloat(0.0 / 255.0), alpha: CGFloat(0.2))
        scoreBg.strokeColor = UIColor.clear
        scoreBg.fillColor = scoreBgColor
        scoreBg.zPosition = -1
        scoreLbl.addChild(scoreBg)
        return scoreLbl
    }

    func createHighscoreLabel() -> SKLabelNode {
        let highscoreLbl = SKLabelNode()
        highscoreLbl.position = CGPoint(x: self.frame.width - 80, y: self.frame.height - 22)
        if let highestScore = UserDefaults.standard.object(forKey: "highestScore"){
            highscoreLbl.text = "Highest Score: \(highestScore)"
        } else {
            highscoreLbl.text = "Highest Score: 0"
        }
        highscoreLbl.zPosition = 5
        highscoreLbl.fontSize = 15
        highscoreLbl.fontColor = UIColor(red: 0.36, green: 0.88, blue: 0.90, alpha: 1.00)
        highscoreLbl.fontName = "Helvetica-Bold"
        return highscoreLbl
    }

    func createTaptoplayLabel() -> SKLabelNode {
        let taptoplayLbl = SKLabelNode()
        taptoplayLbl.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 100)
        taptoplayLbl.text = "Tap anywhere to start"
        taptoplayLbl.fontColor = UIColor(red: 0.36, green: 0.88, blue: 0.90, alpha: 1.00)
        taptoplayLbl.zPosition = 5
        taptoplayLbl.fontSize = 15
        taptoplayLbl.fontName = "HelveticaNeue"
        return taptoplayLbl
    }
    //This will be the wallPair obstacle we will create. Added the sushiNode here because they appear in the middle of each wallPair.
    func createWalls() -> SKNode  {
        
        let sushiNode = SKSpriteNode(imageNamed: "sushi")
        sushiNode.size = CGSize(width: 40, height: 40)
        sushiNode.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2)
        sushiNode.physicsBody = SKPhysicsBody(rectangleOf: sushiNode.size)
        sushiNode.physicsBody?.affectedByGravity = false
        sushiNode.physicsBody?.isDynamic = false
        sushiNode.physicsBody?.categoryBitMask = CollisionBitMask.sushiCategory
        sushiNode.physicsBody?.collisionBitMask = 0
        sushiNode.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        sushiNode.color = SKColor.blue
        
        wallPair = SKNode()
        wallPair.name = "wallPair"
        
        let topWall = SKSpriteNode(imageNamed: "SpoonFork")
        let btmWall = SKSpriteNode(imageNamed: "chopSticksTwo")
        
        topWall.size = CGSize(width: 250, height: 350)
        topWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 + 200)
        btmWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 - 180)
        
        topWall.setScale(0.5)
        btmWall.setScale(0.5)
        
        topWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: topWall.size.width / 1.25,
                                                                height: topWall.size.height / 1.25))
        topWall.physicsBody?.categoryBitMask = CollisionBitMask.Wall
        topWall.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        topWall.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        topWall.physicsBody?.isDynamic = false
        topWall.physicsBody?.affectedByGravity = false
        
        btmWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: btmWall.size.width / 1.08,
                                                                height: btmWall.size.height / 1.08))
        btmWall.physicsBody?.categoryBitMask = CollisionBitMask.Wall
        btmWall.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        btmWall.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        btmWall.physicsBody?.isDynamic = false
        btmWall.physicsBody?.affectedByGravity = false
        
        wallPair.addChild(topWall)
        wallPair.addChild(btmWall)
        
        wallPair.zPosition = 1
        
        // Y position with min and max in which the wallPair will randomly be positioned as they first appear.
        let randomPosition = random(min: -50, max: 50)
        wallPair.position.y = wallPair.position.y +  randomPosition
        wallPair.addChild(sushiNode)
        
        wallPair.run(moveAndRemove)
        
        return wallPair
    }
    //random functions here called for randomPosition constant as seen above
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / Float(0xFFFFFFFF))
    }
    
    func random(min : CGFloat, max : CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
    
    func restartScene(){
        self.removeAllChildren()
        self.removeAllActions()
        isDied = false
        isGameStarted = false
        score = 0
        createScene()
    }
    
    func backToMainMenu() {
        let backToMainMenuLbl = SKLabelNode(text: "<")
        backToMainMenuLbl.position = CGPoint(x: self.frame.width - 300, y: self.frame.height - 35)
        
        backToMainMenuLbl.fontColor = UIColor(red: 0.36, green: 0.88, blue: 0.90, alpha: 1.00)
        backToMainMenuLbl.fontName = "HelveticaNeue"
        backToMainMenuLbl.zPosition = 7
        backToMainMenuLbl.fontSize = 40
        backToMainMenuLbl.name = "backToMainMenuLbl"
        self.addChild(backToMainMenuLbl)
    }

}
