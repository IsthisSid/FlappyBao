//
//  GameScene.swift
//  HelloWorld
//
//  Created by Sidany Walker on 9/30/20.
//
import UIKit
import SpriteKit
import GameplayKit

class MainMenuScene: SKScene {
    var highscoreLbl = SKLabelNode()
    var birdFrames: [SKTexture]?
    required init?(coder aDecoder:NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size:size)
        self.backgroundColor = UIColor.white
        var frames:[SKTexture] = []
        
        let birdAtlas = SKTextureAtlas(named: "player")
        for index in 1 ... 4 {
            let textureName = "bird\(index)"
            let texture = birdAtlas.textureNamed(textureName)
            frames.append(texture)
        }
        self.birdFrames = frames
    }
    
    func flyBird() {
        let texture = self.birdFrames![0]
        let bird = SKSpriteNode(texture: texture)
        bird.size = CGSize(width: 50, height: 50)
        
        let randomBirdYPostionGenerator = GKRandomDistribution(lowestValue:50, highestValue: Int(self.frame.size.height))
        let yPosition = CGFloat(randomBirdYPostionGenerator.nextInt())
        
        let rightToLeft = arc4random() % 2 == 0
        
        let xPosition = rightToLeft ? self.frame.size.width + bird.size.width / 2 : -bird.size.width / 2
        bird.position = CGPoint(x: xPosition, y: yPosition)
        
        if rightToLeft {
            bird.xScale = -1
            
        }
        self.addChild(bird)
        bird.run(SKAction.repeatForever(SKAction.animate(with: self.birdFrames!, timePerFrame: 0.05, resize: false, restore: true)))
        var distanceToCover = self.frame.size.width + bird.size.width
        
        if rightToLeft {
            distanceToCover *= -1
        }
        let time = TimeInterval(abs(distanceToCover / 40))
        let moveAction = SKAction.moveBy(x: distanceToCover, y: 0, duration: time)
        let removeAction = SKAction.run {
            bird.removeAllActions()
        }
        let allActions = SKAction.sequence([moveAction, removeAction])
        bird.run(allActions)
    }
    override func didMove(to view: SKView) {
        for i in 0..<2
        {
        let background = SKSpriteNode(imageNamed: "bg")
        background.anchorPoint = CGPoint.init(x: 0, y: 0)
        background.position = CGPoint(x:CGFloat(i) * self.frame.width, y:0)
        background.name = "background"
        background.size = (self.view?.bounds.size)!
        self.addChild(background)
        }
        self.backgroundColor = SKColor.green
        let button = SKSpriteNode(imageNamed: "play")
            button.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
            button.name = "nextButton"
        flyBird()
        self.addChild(button)
        addLogo()
        addLabels()
//        addPlayButton()
        highscoreLbl = createHighscoreLabel()
        self.addChild(highscoreLbl)
    }
    func addLogo() {
        let logo = SKSpriteNode(imageNamed: "logo")
        logo.size = CGSize(width: 300, height: 150)
        logo.position = CGPoint(x: frame.midX, y: frame.midY + frame.size.height/4)
        addChild(logo)
    }
    func addLabels() {
        let playLabel = SKLabelNode(text: "Tap Me to Play!")
        playLabel.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2 - 60)
        playLabel.fontName = "AvenirNext-Bold"
        playLabel.fontSize = 10.0
        playLabel.fontColor = UIColor.white
        addChild(playLabel)
        
    }
        
   
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let nodesarray = nodes(at: location)
               
            for node in nodesarray {
                if node.name == "nextButton" {
                    let gameScene = GameScene(size: view!.bounds.size)
                    view!.presentScene(gameScene)
                }
            }
        }
    }
        

            
        }
    


//        let gameSceneTemp = GameScene(fileNamed: "GameScene")
//        gameSceneTemp?.scaleMode = .aspectFill
//        self.view?.presentScene(gameSceneTemp!, transition: SKTransition.doorsCloseHorizontal(withDuration: 1.0))
        
//        enumerateChildNodes(withName: "//*") { (node, stop) in
//
//            }
        
        
    
//    func addPlayButton() {
//        let playButton = SKSpriteNode(imageNamed: "play")
//        playButton.name = "playButton"
//        playButton.position = CGPoint.zero
//        addChild(playButton)
    
    
    

//    override func update(_ currentTime: TimeInterval) {
//        // Called before each frame is rendered
//    }

