//
//  ChooseLevelScene.swift
//  Flappy Bao
//
//  Created by Sidany Walker on 10/6/20.
//

import SpriteKit
import GameplayKit

//These buttons inherit properties from the ButtonElements class blueprint.
class ChooseLevelScene: SKScene {
    
    lazy var chooseLevelOne: ButtonElements = {
        var buttonOne = ButtonElements(imageNamed: "levelOneButton") {
            let gameScene = LevelOneScene(size: (self.view!.bounds.size))
            self.view!.presentScene(gameScene)
        }
        buttonOne.zPosition = 1
        return buttonOne
    }()
    
    lazy var chooseLevelTwo: ButtonElements = {
        var buttonTwo = ButtonElements(imageNamed: "levelTwoButton") {
            let gameScene = LevelTwoScene(size: (self.view!.bounds.size))
            self.view!.presentScene(gameScene)
        }
        buttonTwo.zPosition = 1
        return buttonTwo
    }()
    
    lazy var chooseLevelThree: ButtonElements = {
        var buttonThree = ButtonElements(imageNamed: "levelThreeButton") {
            let gameScene = LevelThreeScene(size: (self.view!.bounds.size))
            self.view!.presentScene(gameScene)
        }
        buttonThree.zPosition = 1
        return buttonThree
    }()
    
    lazy var chooseLevelFour: ButtonElements = {
        var buttonFour = ButtonElements(imageNamed: "levelFourButton") {
            let gameScene = LevelFourScene(size: (self.view!.bounds.size))
            self.view!.presentScene(gameScene)
        }
        buttonFour.zPosition = 1
        return buttonFour
    }()
    
    lazy var backButton: ButtonElements = {
        var backToMain = ButtonElements(imageNamed: "backButton") {
            let mainMenu = MainMenuScene(size: (self.view!.bounds.size))
            self.view!.presentScene(mainMenu)
        }
        backToMain.zPosition = 0
        return backToMain
    }()
    //Adding a background to the scene.
    func blueishBackground() {
        let background = SKSpriteNode(imageNamed: "levelBg")
        background.anchorPoint = CGPoint.init(x: 0, y: 0)
        background.name = "background"
        background.size = (self.view?.bounds.size)!
        background.zPosition = -1
        self.addChild(background)    }
    
    //In order for these buttons and functions to appear on the screen, they must be called here () or 'addChild()' and the positions can be specified.
    override func didMove(to view: SKView) {
        blueishBackground()
        
        chooseLevelOne.position = CGPoint(x: self.frame.size.width - 230, y: self.frame.size.height/2 + 100)
        addChild(chooseLevelOne)
        
        chooseLevelTwo.position = CGPoint(x: self.frame.size.width - 100, y: self.frame.size.height/2 + 100)
        addChild(chooseLevelTwo)
        
        chooseLevelThree.position = CGPoint(x: self.frame.size.width - 230, y: self.frame.size.height/2)
        addChild(chooseLevelThree)
        
        chooseLevelFour.position = CGPoint(x: self.frame.size.width - 100, y: self.frame.size.height/2)
        addChild(chooseLevelFour)
        
        backButton.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2 - 100)
        addChild(backButton)
    }
    
}


