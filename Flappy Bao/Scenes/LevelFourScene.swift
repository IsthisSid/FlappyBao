//
//  LevelFourScene.swift
//  Flappy Bao
//
//  Created by Sidany Walker on 10/6/20.
//

import UIKit
import SpriteKit
import AVFoundation

class LevelFourScene: SKScene, SKPhysicsContactDelegate {
    
    let coinSound = SKAction.playSoundFileNamed("CoinSound.mp3", waitForCompletion: false)
    
    var isGameStarted = Bool(false)
    var isDied = Bool(false)
    
    var scoreFour = Int(0)
    var scoreLblFour = SKLabelNode()
    var highscoreLblFour = SKLabelNode()
    var taptoplayLbl = SKLabelNode()
    
    var restartBtn = SKSpriteNode()
    var pauseBtn = SKSpriteNode()
    
    var wallPair = SKNode()
    var moveAndRemove = SKAction()
    var Ground = SKSpriteNode()
    
    let birdAtlas = SKTextureAtlas(named:"player")
    var birdSprites = Array<Any>()
    var bird = SKSpriteNode()
    var repeatActionBird = SKAction()
    
    override func didMove(to view: SKView) {
        createScene()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameStarted == false{
            isGameStarted =  true
            bird.physicsBody?.affectedByGravity = true
            createPauseBtn()
            taptoplayLbl.removeFromParent()
            
            self.bird.run(repeatActionBird)
            
            let spawn = SKAction.run({
                () in
                self.wallPair = self.createWalls()
                self.addChild(self.wallPair)
            })
            
            let delay = SKAction.wait(forDuration: 1.0) // time between each pillarspawn
            let SpawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
            self.run(spawnDelayForever)
            
            let distance = CGFloat(self.frame.width + wallPair.frame.width)
            let movePillars = SKAction.moveBy(x: -distance - 120, y: 30, duration: TimeInterval(0.005 * distance))
            //first part is moving out of the screen, second part of this is speed of pillars' path
            let removePillars = SKAction.removeFromParent()
            
            moveAndRemove = SKAction.sequence([movePillars, removePillars])
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
            
        } else {
            if isDied == false {
                bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
            }
        }
        
        for touch in touches{
            let location = touch.location(in: self)
            //1
            if isDied == true{
                if restartBtn.contains(location){
                    if UserDefaults.standard.object(forKey: "highestScoreFour") != nil {
                        let hscoreFour = UserDefaults.standard.integer(forKey: "highestScoreFour")
                        if hscoreFour < Int(scoreLblFour.text!)!{
                            UserDefaults.standard.set(scoreLblFour.text, forKey: "highestScoreFour")
                        }
                    } else {
                        UserDefaults.standard.set(0, forKey: "highestScoreFour")
                    }
                    restartScene()
                }
            } else {
                //2
                if pauseBtn.contains(location){
                    if self.isPaused == false{
                        self.isPaused = true
                        pauseBtn.texture = SKTexture(imageNamed: "play")
                    } else {
                        self.isPaused = false
                        pauseBtn.texture = SKTexture(imageNamed: "pause")
                    }
                }
            }
        }
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if touchedNode.name == "backToChooseMenuLbl" {
                // Call the function here.
                let gameScene = ChooseLevelScene(size: view!.bounds.size)
                view!.presentScene(gameScene)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if isGameStarted == true{
            if isDied == false{
                enumerateChildNodes(withName: "background", using: ({
                    (node, error) in
                    let bg = node as! SKSpriteNode
                    bg.position = CGPoint(x: bg.position.x - 2, y: bg.position.y)
                    if bg.position.x <= -bg.size.width {
                        bg.position = CGPoint(x:bg.position.x + bg.size.width * 2, y:bg.position.y)
                    }
                }))
            }
        }
    }
    
    func createScene(){
        Ground = SKSpriteNode(imageNamed: "groundSauce")
        Ground.size = CGSize(width: 320, height: 100)
        
        Ground.position = CGPoint(x: self.frame.width / 2, y: self.frame.width - 270)
        Ground.physicsBody = SKPhysicsBody(rectangleOf: Ground.size)
        Ground.physicsBody?.categoryBitMask = PhysicsBodyCategory.Ground
        Ground.physicsBody?.collisionBitMask = PhysicsBodyCategory.birdCategory
        Ground.physicsBody?.contactTestBitMask = PhysicsBodyCategory.birdCategory
        Ground.physicsBody?.affectedByGravity = false
        Ground.physicsBody?.isDynamic = false
        
        Ground.zPosition = 3
        
        self.addChild(Ground)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = PhysicsBodyCategory.Ground
        self.physicsBody?.collisionBitMask = PhysicsBodyCategory.birdCategory
        self.physicsBody?.contactTestBitMask = PhysicsBodyCategory.birdCategory
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = SKColor(red: 80.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        for i in 0..<2
        {
            let background = SKSpriteNode(imageNamed: "saucyBg")
            background.anchorPoint = CGPoint.init(x: 0, y: 0)
            background.position = CGPoint(x:CGFloat(i) * self.frame.width, y:0)
            background.name = "background"
            background.size = (self.view?.bounds.size)!
            self.addChild(background)
        }
        
        birdSprites.append(birdAtlas.textureNamed("bird1"))
        birdSprites.append(birdAtlas.textureNamed("bird2"))
        birdSprites.append(birdAtlas.textureNamed("bird3"))
        birdSprites.append(birdAtlas.textureNamed("bird4"))
        
        self.bird = createBird()
        self.addChild(bird)
        
        let animateBird = SKAction.animate(with: self.birdSprites as! [SKTexture], timePerFrame: 0.1)
        self.repeatActionBird = SKAction.repeatForever(animateBird)
        
        scoreLblFour = createScoreLabelFour()
        self.addChild(scoreLblFour)
        
        backToChooseMenu()
        
        highscoreLblFour = createHighscoreLabelFour()
        self.addChild(highscoreLblFour)
        
        taptoplayLbl = createTaptoplayLabel()
        self.addChild(taptoplayLbl)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.Wall || firstBody.categoryBitMask == CollisionBitMask.Wall && secondBody.categoryBitMask == CollisionBitMask.birdCategory || firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.Ground || firstBody.categoryBitMask == CollisionBitMask.Ground && secondBody.categoryBitMask == CollisionBitMask.birdCategory {
            
            enumerateChildNodes(withName: "wallPair", using: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
            
            if isDied == false{
                isDied = true
                createRestartBtn()
                pauseBtn.removeFromParent()
                self.bird.removeAllActions()
            }
            
        } else if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.sushiCategory {
            run(coinSound)
            scoreFour += 1
            scoreLblFour.text = "\(scoreFour)"
            secondBody.node?.removeFromParent()
            
        } else if firstBody.categoryBitMask == CollisionBitMask.sushiCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory {
            run(coinSound)
            scoreFour += 1
            scoreLblFour.text = "\(scoreFour)"
            firstBody.node?.removeFromParent()
        }
    }
}

