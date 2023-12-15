//
//  GameScene.swift
//  Turtluge
//
//  Created by Alessandro Ricci on 12/12/23.
//

import Foundation
import SpriteKit
import SwiftUI

class GameScene: SKScene, ObservableObject, SKPhysicsContactDelegate{
    
    let player = SKSpriteNode(imageNamed: "walkingBlue0")
    
    var playerAnimationWalking = [SKTexture]()
    
    var playerAnimationRotate = [SKTexture]()
    
    var playerAnimationUnderGround = [SKTexture]()
    
    var redCanDestruction = [SKTexture]()
    
    var yellowCanDestruction = [SKTexture]()
    
    var blueCanDestruction = [SKTexture]()
    
    var touchesBegan = false
    
    var isRolling = false
    
    var collision = false
    
    let pauseButton = SKSpriteNode(imageNamed: "pauseButton")
    
    var scoreLabel: SKLabelNode!
    
    var livesLabel: SKLabelNode!
    
    var score = 0
    
    var lives: Int = 3
    
    var obstacles: [SKSpriteNode] = []
    
    var gameSpeed: CGFloat = 1.4 // Easy mode by default
    
    @Published var isGameOver = false
    
    
    
    struct PhysicsCategory {
        
    }
    
    
    override func didMove(to view: SKView) {
        view.showsPhysics = true
        self.size = CGSize(width: 844, height: 390)
        scene?.scaleMode = .fill
        
        anchorPoint = .zero
        physicsWorld.gravity = CGVector(dx: 0, dy: -3)
        physicsWorld.contactDelegate = self
        
        player.position = CGPoint(x: 0 + player.size.width / 3, y: size.height - player.size.height / 1 )
        player.setScale(0.35)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.collisionBitMask = 8
        player.physicsBody?.categoryBitMask = 5
        player.zPosition = 3
        
        self.lives = 3
        
        player.name = "player"
        
        addChild(player)
        
        pauseButton.position = CGPoint(x: 800, y: frame.size.height - 50)
        pauseButton.setScale(0.05)
        
        pauseButton.zPosition = 3
        addChild(pauseButton)
        
        //Animations
        
        //Walking
        let textureWalking = SKTextureAtlas(named: "Walking")
        for i in 1..<textureWalking.textureNames.count {
            
            let name = "walkingBlue" + String(i)
            playerAnimationWalking.append(textureWalking.textureNamed(name))
        }
        
        //Rotate
        
        let textureRotate = SKTextureAtlas(named: "Rotate")
        for i in 1..<textureRotate.textureNames.count {
            
            let name = "closingBlue" + String(i)
            playerAnimationRotate.append(textureRotate.textureNamed(name))
        }
        
        //UnderGround
        
        let textureUnderGround = SKTextureAtlas(named: "UnderGround")
        for i in 1..<textureUnderGround.textureNames.count {
            
            let name = "undergroundTurtleLv" + String(i)
            playerAnimationUnderGround.append(textureUnderGround.textureNamed(name))
        }
        
        //redCanDestruction
        
        let textureRedCanDestruction = SKTextureAtlas(named: "redCanDestruction")
        for i in 1..<textureRedCanDestruction.textureNames.count {
            
            let name = "redExplodingCan" + String(i)
            redCanDestruction.append(textureRedCanDestruction.textureNamed(name))
        }
        
        
        moveBackGround(image: "sky1", y: 0, z: -5, duration: 90000, needPhysics: false, size: self.size)
        
        moveBackGround(image: "sea1", y: 0, z:-2, duration: 3, needPhysics: false, size: CGSize(width: self.size.width, height: 120))
        
        moveBackGround(image: "beach1", y: 0, z:-2, duration: 3, needPhysics: true, size: CGSize(width: self.size.width, height: 50))
        
        moveBackGround(image: "beach1", y: 0, z:-2, duration: 3, needPhysics: false, size: CGSize(width: self.size.width, height: 100))
        
        
        player.run(SKAction.repeatForever(SKAction.animate(with: playerAnimationWalking, timePerFrame: 0.10)))
        
        
        spawnRedCanObstacles()
        
        setupScoreLabel()
        
        setupLivesLabel()
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        if touchLocation.y < frame.size.height / 2 {
            // Tap on the bottom half of the screen to go underground
            goUnderground()
        } else {
            // Tap on the top half of the screen to rotate
            startRotationAnimation()
            player.zPosition = 3
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.isRolling = false
    }
    
    func goUnderground() {
        player.removeAllActions()
        player.run(SKAction.sequence([
            SKAction.group([
            
            SKAction.animate(with: playerAnimationUnderGround, timePerFrame: 0.1),
            SKAction.wait(forDuration: 1.0),
            SKAction.scale(to: 0.25, duration: 0.0),
            SKAction.scaleX(by: 1, y: 0.90, duration: 0.0)
            ]),
            SKAction.scale(to: 0.35, duration: 0.0),
        /*    SKAction.animate(with: playerAnimationUnderGround/*.reversed()*/, timePerFrame: 0.1)*/
            SKAction.repeatForever(SKAction.animate(with: playerAnimationWalking, timePerFrame: 0.10))
        ]))
        
        
    }
    
    func startRotationAnimation() {
        self.isRolling = true
        player.removeAllActions()
        
        player.run(SKAction.sequence([
            SKAction.group([
                SKAction.animate(with: playerAnimationRotate, timePerFrame: 0.05),
                SKAction.scale(to: 0.23, duration: 0.0)
            ]),
            SKAction.scale(to: 0.35, duration: 0.0),
            SKAction.repeatForever(SKAction.animate(with: playerAnimationWalking, timePerFrame: 0.10))
        ]))
        
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else {return}
        
        print("Contact detected between \(nodeA.name ?? "unknown") and \(nodeB.name ?? "unknown")")
        if (nodeA == player && nodeB.name == "redCan") || (nodeB == player && nodeA.name == "redCan") {
                // Check if either nodeA or nodeB is the player, and the other is a redCan
            if self.isRolling {
                nodeB.run(SKAction.sequence([
                    SKAction.group([
                        SKAction.animate(with: redCanDestruction, timePerFrame: 0.25),
                        SKAction.wait(forDuration: 1.0),
                        SKAction.scale(to: 0.85, duration: 0.05),
                        SKAction.scaleX(by: 1, y: 0.90, duration: 0.0)
                    ])
                ]))
            }
            else {
            
                if nodeA.action(forKey: "Rotate") == nil {
                    
                    
                    self.lives -= 1
                    livesLabel.text = "Lives: \(self.lives)"
                    if lives <= 0 {
                        print("GAMEOVER")
                        
                        gameOver()
                    }
                    
                    print("RedCan hit player. Remaining Lives: \(lives)")
                }
            }
                playerHit(node: nodeB)
            }
        
        
        if nodeB == player {
            
            print("lolB")
            
            playerHit(node: nodeA)
            
        }
    }
    
    
    func moveBackGround (image: String, y: CGFloat, z: CGFloat,duration: Double, needPhysics:Bool, size:CGSize) {
        for i in 0...1 {
            
            let node = SKSpriteNode(imageNamed: image)
            
            node.anchorPoint = .zero
            node.position = CGPoint(x: size.width * CGFloat(i), y: y)
            node.size = size
            node.zPosition = z
            
            if needPhysics{
                node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
                node.physicsBody?.isDynamic = false
                node.physicsBody?.contactTestBitMask = 8
                node.name = ""
            }
            
            let move = SKAction.moveBy(x: -node.size.width, y: 0, duration: duration)
            
            let wrap = SKAction.moveBy(x: node.size.width, y: 0, duration: 0)
            
            let sequence = SKAction.sequence([move,wrap])
            let imer = SKAction.repeatForever(sequence)
            
            node.run(imer)
            addChild(node)
        }
    }
    
    func setupScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: \(score)"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 20, y: frame.size.height - 60)
        scoreLabel.zPosition = 3
        addChild(scoreLabel)
    }
    
    func setupLivesLabel() {
        
        livesLabel = SKLabelNode(fontNamed: "Chalkduster")
        livesLabel.text = "Lives: \(lives)"
        livesLabel.horizontalAlignmentMode = .right
        livesLabel.position = CGPoint(x: 750, y: frame.size.height - 60)
        livesLabel.zPosition = 3
        addChild(livesLabel)
    }
    

//    let obstacleTypes = ["cig1", "blueCan", "redCan", "yellowCan", "plasticBag1"]
   
    // RedCanSpawn
     func spawnRedCanObstacles() {
        // Logica per generare ostacoli a intervalli regolari
        let obstacleRedCanTypes = ["redCan"]
        let obstacleRedCan = SKSpriteNode(imageNamed: obstacleRedCanTypes.randomElement()!)
        obstacleRedCan.position = CGPoint(x: frame.maxX, y: 150)
        obstacleRedCan.physicsBody?.affectedByGravity = false
        obstacleRedCan.physicsBody = SKPhysicsBody(rectangleOf: obstacleRedCan.size)
        obstacleRedCan.physicsBody?.isDynamic = false
         obstacleRedCan.physicsBody?.categoryBitMask = 2
        obstacleRedCan.physicsBody?.contactTestBitMask = 1
//        obstacleRedCan.physicsBody = SKPhysicsBody(texture: obstacleRedCan.texture!,size: obstacleRedCan.texture!.size())
        
        obstacleRedCan.name = "redCan"
//         obstacles.append(obstacleRedCan)
        
        obstacleRedCan.zPosition = 3
        
        obstacleRedCan.setScale(0.30)
        
        
        addChild(obstacleRedCan)
        
        let moveAction = SKAction.moveBy(x: -frame.size.width, y: 0, duration: TimeInterval(4.2 / gameSpeed))
        let removeAction = SKAction.removeFromParent()
        obstacleRedCan.run(SKAction.sequence([moveAction, removeAction]))
        
        //Animation
        
        //redCanDestruction
        
        let textureRedCanDestruction = SKTextureAtlas(named: "redCanDestruction")
        for i in 1..<textureRedCanDestruction.textureNames.count {
            
            let name = "redExplodingCan" + String(i)
            redCanDestruction.append(textureRedCanDestruction.textureNamed(name))
        }
        
        if player.frame.intersects(obstacleRedCan.frame){
            obstacleRedCan.run(SKAction.sequence([
                SKAction.group([
                    
                    SKAction.animate(with: redCanDestruction, timePerFrame: 0.1),
                    SKAction.wait(forDuration: 0.000001),
                    SKAction.scale(to: 0.45, duration: 0.0),
                    SKAction.scaleX(by: 1, y: 0.90, duration: 0.5)
                ])
            ]))
        }
        
        
        //Spawn Delay
        let spawnDelay = SKAction.wait(forDuration: TimeInterval.random(in: 2...6))
        run(spawnDelay) {
            self.spawnRedCanObstacles()
        }
    }
    
    func playerHit(node: SKNode){
        print("Player hit something with name: \(node.name ?? "unknown")")
        if node.name == "redCan" {
            
            for obstacleRedCan in obstacles {
                if player.frame.intersects(obstacleRedCan.frame) {
                    if player.action(forKey: "Rotate") == nil { // La tartaruga non è in rotazione
                        lives -= 1
                        print("Player lost a life. HIIITRemaining Lives: \(lives)")
                        if lives <= 0 {
                                         gameOver()
                                    }
                        
                    }
                    
                   node.removeFromParent()
                    
                }
            }
            
//            player.removeFromParent()
//            gameOver()
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
    
        for obstacleRedCan in obstacles {
            if player.frame.intersects(obstacleRedCan.frame) {
                if player.action(forKey: "Rotate") == nil { // La tartaruga non è sottoterra
                    lives -= 1
                    if lives <= 0 {
//                        gameOver()
                    }
                }
                obstacleRedCan.removeFromParent()
            }
        }
    }
    
    func gameOver() {
        // Visualizza la schermata di Game Over con il punteggio e le opzioni di riavvio
        
        let gameOverScene = GameOverScene(size: self.size, score: score)
        self.view?.presentScene(gameOverScene, transition: SKTransition.flipHorizontal(withDuration: 0.5))
        
        
        let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 32
        gameOverLabel.fontColor = .red
        gameOverLabel.zPosition = 10
        gameOverLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        
        isGameOver = true
        
        
        print("gameover")
        
        
    }
}


class GameOverScene: SKScene {
    init(size: CGSize, score: Int) {
        super.init(size: size)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
