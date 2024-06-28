//
//  GameOverSince.swift
//  Car
//
//  Created by Foundation-022 on 28/06/24.
//

import UIKit
import SpriteKit

class GameOverSince: SKScene {
    var restartLabel: SKLabelNode!
    var gameOverLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        
        restartLabel = self.childNode(withName: "//restartLabel") as? SKLabelNode
        
        gameOverLabel = SKLabelNode(text: "GAME OVER")
        gameOverLabel.fontSize = 50
        gameOverLabel.position = .zero
        
        addChild(gameOverLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // chech with node it touchesd
        
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        
        if self.atPoint(location) == restartLabel {
            restartGame()
        }
    }
    
    func restartGame() {
        if let scane = SKScene(fileNamed: "GameScane") {
            scane.scaleMode = .aspectFit
            
            let transition = SKTransition.doorway(withDuration: 1)
            view?.presentScene(scane, transition: transition)
            
        }
    }
}
