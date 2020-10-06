//
//  LevelTwoScene.swift
//  Flappy Bao
//
//  Created by Sidany Walker on 10/6/20.
//

import UIKit
import SpriteKit
import AVFoundation



class LevelTwoScene: SKScene, SKPhysicsContactDelegate {
    
    let coinSound = SKAction.playSoundFileNamed("CoinSound.mp3", waitForCompletion: false)
    
    var isGameStarted = Bool(false)
    var isDied = Bool(false)
    
    var scoreTwo = Int(0)
    var scoreLblTwo = SKLabelNode()
    
    var highscoreLblTwo = SKLabelNode()
    var taptoplayLbl = SKLabelNode()
    var restartBtn = SKSpriteNode()
    var pauseBtn = SKSpriteNode()
    //    var logoImg = SKSpriteNode()
    var wallPair = SKNode()
    var moveAndRemove = SKAction()
    var Ground = SKSpriteNode()
    
    //CREATE THE BIRD ATLAS FOR ANIMATION
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
            
            let delay = SKAction.wait(forDuration: 1.5)
            let SpawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
            self.run(spawnDelayForever)
            
            let distance = CGFloat(self.frame.width + wallPair.frame.width)
            let movePillars = SKAction.moveBy(x: -distance - 80, y: -30, duration: TimeInterval(0.008 * distance))
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
                    if UserDefaults.standard.object(forKey: "highestScoreTwo") != nil {
                        let hscoreTwo = UserDefaults.standard.integer(forKey: "highestScoreTwo")
                        if hscoreTwo < Int(scoreLblTwo.text!)!{
                            UserDefaults.standard.set(scoreLblTwo.text, forKey: "highestScoreTwo")
                        }
                    } else {
                        UserDefaults.standard.set(0, forKey: "highestScoreTwo")
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
        Ground = SKSpriteNode(imageNamed: "groundTable")
        Ground.size = CGSize(width: 320, height: 100)
        
        Ground.position = CGPoint(x: self.frame.width / 2, y: self.frame.width - 270)
        Ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: Ground.size.width / 1.10,
                                                               height: Ground.size.height / 1.10))
        Ground.physicsBody?.categoryBitMask = CollisionBitMask.Ground
        Ground.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        Ground.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        Ground.physicsBody?.affectedByGravity = false
        Ground.physicsBody?.isDynamic = false
        
        Ground.zPosition = 3
        
        self.addChild(Ground)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = CollisionBitMask.Ground
        self.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        self.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = SKColor(red: 80.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        for i in 0..<2
        {
            let background = SKSpriteNode(imageNamed: "bambooBg")
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
        
        scoreLblTwo = createScoreLabelTwo()
        self.addChild(scoreLblTwo)
        
        backToChooseMenu()
        
        highscoreLblTwo = createHighscoreLabelTwo()
        self.addChild(highscoreLblTwo)
        
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
            scoreTwo += 1
            scoreLblTwo.text = "\(scoreTwo)"
            secondBody.node?.removeFromParent()
            
        } else if firstBody.categoryBitMask == CollisionBitMask.sushiCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory {
            run(coinSound)
            scoreTwo += 1
            scoreLblTwo.text = "\(scoreTwo)"
            firstBody.node?.removeFromParent()
        }
    }
}

