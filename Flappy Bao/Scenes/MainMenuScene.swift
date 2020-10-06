//
//  MainMenuScene.swift
//  Flappy Bao
//
//  Created by Sidany Walker on 10/6/20.
//
import UIKit
import SpriteKit
import GameplayKit

class MainMenuScene: SKScene {
    //These buttons inherit properties from the ButtonElements class blueprint.

    lazy var playButton: ButtonElements = {
        var buttonPlay = ButtonElements(imageNamed: "play") {
            let levelOneScene = LevelOneScene(size: (self.view!.bounds.size))
            self.view!.presentScene(levelOneScene)
        }
        buttonPlay.zPosition = 0
        return buttonPlay
    }()
    
//Will later add this if needed.
//    lazy var noadsButton: ButtonElements = {
//        var buttonAds = ButtonElements(imageNamed: "noAdsButton") {
//            insert code for in-app purchases non-consumable
//        }
//        buttonAds.zPosition = 0
//        return buttonAds
//    }()
    
    lazy var levelsButton: ButtonElements = {
        var buttonLevels = ButtonElements(imageNamed: "chooseLevels") {
            let levelsScene = ChooseLevelScene(size: (self.view!.bounds.size))
            self.view!.presentScene(levelsScene)
        }
        buttonLevels.zPosition = 0
        return buttonLevels
    }()
    
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
    
    //In order for these buttons and functions to appear on the screen, they must be called here () or 'addChild()' and the positions can be specified.
    override func didMove(to view: SKView) {
        mainBackground()
        flyBird()
        
        playButton.position = CGPoint(x: self.frame.size.width/2 - 50, y: self.frame.size.height/2 - 110)
        addChild(playButton)
        
//        noadsButton.position = CGPoint(x: self.frame.size.width/2 - 70, y: self.frame.size.height/2 - 150)
//        addChild(noadsButton)
        
        levelsButton.position = CGPoint(x: self.frame.size.width/2 + 70, y: self.frame.size.height/2 - 150)
        addChild(levelsButton)
        
    }
       
}



