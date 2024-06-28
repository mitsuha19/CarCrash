//
//  GameScane.swift
//  Car
//
//  Created by Foundation-022 on 27/06/24.
//

import SpriteKit

class GameScane: SKScene, SKPhysicsContactDelegate {
    
    var cone: SKSpriteNode?
    var car: SKSpriteNode?
    let xPositions = [-90,90]
    var hpLabel: SKLabelNode?
    var carPosition = 1
    
    var hp = "❤️❤️❤️"
    
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        // Register swipe gesture
        let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        cone = self.childNode(withName: "//cone") as? SKSpriteNode
        
        car = self.childNode(withName: "//mobil") as? SKSpriteNode
        car?.physicsBody = SKPhysicsBody(rectangleOf: car?.size ?? .zero)
        car?.physicsBody?.affectedByGravity = false
        car?.physicsBody?.allowsRotation = false
        car?.physicsBody?.contactTestBitMask = car?.physicsBody?.collisionBitMask ?? 0
        
       // programatically setup Label HP
        hpLabel = SKLabelNode(text: "\(hp)")
        hpLabel?.position = CGPoint(x: -200, y: size.height/2 - 50)
        addChild(hpLabel!)
        
        repeatedlySpawCone()
        
    }
    
    func repeatedlySpawCone() {
        let spawnAction = SKAction.run {
            self.spawnCone()
        }
        
        let waitAction = SKAction.wait(forDuration: 1.2)
        
        let spawnAndWaitAction = SKAction.sequence([spawnAction,waitAction])
        
        run(SKAction.repeatForever(spawnAndWaitAction))
    }
    
    func spawnCone(){
        let newCone = cone?.copy() as! SKSpriteNode
        newCone.physicsBody = SKPhysicsBody(rectangleOf: newCone.size)
        newCone.physicsBody?.isDynamic = false
        
        newCone.position = CGPoint(x: xPositions[Int.random(in: 0...1)], y: 700)
        addChild(newCone)
        
        moveCone(node: newCone)
    }
    
    func moveCone(node: SKNode) {
        let moveDownAction = SKAction.moveTo(y: -700, duration: 4)
        let removeNodeAction = SKAction.removeFromParent()
        
        node.run(SKAction.sequence([moveDownAction,removeNodeAction]))
        
    }
    
    func updateCarPosition() {
//        if carPosition == 1 {
//            carPosition = 2
//        } else {
//            carPosition = 1
//        }
        
        car?.run(SKAction.moveTo(x: (carPosition == 1) ? -80 :
                                    80, duration: 0.1))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // update car position
            
       // updateCarPosition()
    }
    
    @objc func swipeRight() {
        carPosition = 2
        updateCarPosition()
    }
    
    @objc func swipeLeft() {
        carPosition = 1
        updateCarPosition()
    }
    
    // function menghandle kontak 2 node
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else {
            return
        }
        guard let nodeB = contact.bodyB.node else {
            return
        }
        
        // handle collision only between car and cone
        if nodeA.name == "mobil" && nodeB.name == "cone" {
            nodeB.removeFromParent()
            
            if hp.count > 0 {
                hp.removeLast()
            }
            
            // update hpLabel taxt
            hpLabel?.text = "\(hp)"
            
            if hp.count == 0 {
                gameOver()
            }
        }
    }
    
    func gameOver() {
        // transition to GameOverScane
        
        if let gameOverScane = SKScene(fileNamed: "GameOverScane") {
            gameOverScane.scaleMode = .aspectFill
            gameOverScane.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            
            let transition = SKTransition.reveal(with: .down, duration: 1)
            
            view?.presentScene(gameOverScane, transition: transition)
        }
        
        
        
    }
}
