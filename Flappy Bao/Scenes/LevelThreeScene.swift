//
//  LevelThreeScene.swift
//  Flappy Bao
//
//  Created by Sidany Walker on 10/6/20.
//

import SpriteKit
import GameplayKit
import AVFoundation

class LevelThreeScene: SKScene, SKPhysicsContactDelegate {
    
    let coinSound = SKAction.playSoundFileNamed("CoinSound.mp3", waitForCompletion: false)
    
    var isGameStarted = Bool(false)
    var isDied = Bool(false)
    
    var scoreThree = Int(0)
    var scoreLblThree = SKLabelNode()
    var highscoreLblThree = SKLabelNode()
    var taptoplayLbl = SKLabelNode()
    
    var restartBtn = SKSpriteNode()
    var pauseBtn = SKSpriteNode()
    
    var wallPair = SKNode()
    var moveAndRemove = SKAction()
    
    let birdAtlas = SKTextureAtlas(named:"player")
    var birdSprites = Array<Any>()
    var bird = SKSpriteNode()
    var repeatActionBird = SKAction()
    
    var Ground = SKSpriteNode()
    var gameStarted = Bool()
    
    override func didMove(to view: SKView) {
        createScene()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameStarted == false{
            isGameStarted =  true
            bird.physicsBody?.affectedByGravity = true
            bird.physicsBody?.affectedByGravity = true
            createPauseBtn()
            
            taptoplayLbl.removeFromParent()
            
            self.bird.run(repeatActionBird)
            let spawn = SKAction.run({
                () in
                self.wallPair = self.createWalls()
                self.addChild(self.wallPair)
                
            })
            
            let delay = SKAction.wait(forDuration: 3.0)
            let SpawnDelay = SKAction.sequence([spawn, delay])
            let SpawnDelayForever = SKAction.repeatForever(SpawnDelay)
            self.run(SpawnDelayForever)
            
            let distance = CGFloat(self.frame.width + wallPair.frame.width)
            let movePaws = SKAction.move(to: CGPoint(x: -distance - 120, y: +90), duration: TimeInterval(0.012 * distance))
            
            let moveOtherPaws = SKAction.move(to: CGPoint(x: distance + 120, y: -90), duration: TimeInterval(0.024 * distance))
            moveAndRemove = SKAction.sequence([movePaws, moveOtherPaws])
            
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
        }
        else {
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
        }
        
        for touch in touches{
            let location = touch.location(in: self)
            if isDied == true{
                if restartBtn.contains(location){
                    if UserDefaults.standard.object(forKey: "highestScoreThree") != nil {
                        let hscoreThree = UserDefaults.standard.integer(forKey: "highestScoreThree")
                        if hscoreThree < Int(scoreLblThree.text!)!{
                            UserDefaults.standard.set(scoreLblThree.text, forKey: "highestScoreThree")
                        }
                        
                    } else {
                        UserDefaults.standard.set(0, forKey: "highestScoreThree")
                    }
                    restartScene()
                }
                
            } else {

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
        // Called before each frame is rendered and creates moving background. Using still background here so will not be including this code for this scene.
        //            if isGameStarted == true{
        //                if isDied == false{
        //                    enumerateChildNodes(withName: "background", using: ({
        //                        (node, error) in
        //                        let bg = node as! SKSpriteNode
        //                        bg.position = CGPoint(x: bg.position.x - 2, y: bg.position.y)
        //                        if bg.position.x <= -bg.size.width {
        //                            bg.position = CGPoint(x:bg.position.x + bg.size.width * 2, y:bg.position.y)
        //                        }
        //                    }))
        //                }
        //            }
    }
    
    func createScene(){
        
        Ground = SKSpriteNode(imageNamed: "kittyBowl")
        Ground.size = CGSize(width: 320, height: 100)
        
        Ground.position = CGPoint(x: self.frame.width / 2, y: self.frame.width - 270)
        Ground.physicsBody = SKPhysicsBody(rectangleOf: Ground.size)
        Ground.physicsBody?.categoryBitMask = PhysicsCategory.Ground
        Ground.physicsBody?.collisionBitMask = PhysicsCategory.birdCategory
        Ground.physicsBody?.contactTestBitMask = PhysicsCategory.birdCategory
        Ground.physicsBody?.affectedByGravity = false
        Ground.physicsBody?.isDynamic = false
        
        Ground.zPosition = 3
        
        self.addChild(Ground)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = PhysicsCategory.Ground
        self.physicsBody?.collisionBitMask = PhysicsCategory.birdCategory
        self.physicsBody?.contactTestBitMask = PhysicsCategory.birdCategory
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        
        self.physicsWorld.contactDelegate = self
        
        for i in 0..<2
        {
            let background = SKSpriteNode(imageNamed: "kittyPawBg")
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
        
        scoreLblThree = createScoreLabelThree()
        self.addChild(scoreLblThree)
        
        backToChooseMenu()
        
        highscoreLblThree = createHighscoreLabelThree()
        self.addChild(highscoreLblThree)
        
        taptoplayLbl = createTaptoplayLabel()
        self.addChild(taptoplayLbl)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == PhysicsCategory.birdCategory && secondBody.categoryBitMask == PhysicsCategory.Wall || firstBody.categoryBitMask == PhysicsCategory.Wall && secondBody.categoryBitMask == PhysicsCategory.birdCategory || firstBody.categoryBitMask == PhysicsCategory.birdCategory && secondBody.categoryBitMask == PhysicsCategory.Ground || firstBody.categoryBitMask == PhysicsCategory.Ground && secondBody.categoryBitMask == PhysicsCategory.birdCategory {
            
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
        } else if firstBody.categoryBitMask == PhysicsCategory.birdCategory && secondBody.categoryBitMask == PhysicsCategory.sushiCategory {
            run(coinSound)
            scoreThree += 1
            scoreLblThree.text = "\(scoreThree)"
            
            secondBody.node?.removeFromParent()
        } else if firstBody.categoryBitMask == PhysicsCategory.sushiCategory && secondBody.categoryBitMask == PhysicsCategory.birdCategory {
            run(coinSound)
            scoreThree += 1
            scoreLblThree.text = "\(scoreThree)"
            
            firstBody.node?.removeFromParent()
        }
    }
    func restartScene(){
        self.removeAllChildren()
        self.removeAllActions()
        isDied = false
        isGameStarted = false
        scoreThree = 0
        createScene()
    }
}
