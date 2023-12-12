//
//  GameScene.swift
//  Turtluge
//
//  Created by Alessandro Ricci on 12/12/23.
//

//import Foundation
//import SpriteKit
//import SwiftUI
//
//class GameScene: SKScene, ObservableObject  {
//    var turtle: SKSpriteNode!
//    var scoreLabel: SKLabelNode!
//    var score = 0
//    var lives = 3
//    var gameSpeed: CGFloat = 1.0 // Easy mode by default
//    var obstacles: [SKSpriteNode] = []
//
//    var gameMode: String = "Easy"
//
//    let walkingFrames: [SKTexture] = [
//        SKTexture(imageNamed: "walkingBlue0"),
//        SKTexture(imageNamed: "walkingBlue1"),
//        SKTexture(imageNamed: "walkingBlue2"),
//        SKTexture(imageNamed: "walkingBlue3"),
//        SKTexture(imageNamed: "walkingBlue4"),
//        SKTexture(imageNamed: "walkingBlue5")
//    ]
//
//    let undergroundFrames: [SKTexture] = [
//        SKTexture(imageNamed: "undergroundTurtleLv1"),
//        SKTexture(imageNamed: "undergroundTurtleLv1")
//    ]
//
//    let rotationFrames: [SKTexture] = [
//        SKTexture(imageNamed: "closingBlue1"),
//        SKTexture(imageNamed: "closingBlue2"),
//        SKTexture(imageNamed: "closingBlue3")
//    ]
//
//    override func didMove(to view: SKView) {
//        setupBackground()
//        setupTurtle()
//        //        setupScoreLabel()
//        //        spawnObstacles()
//        //        startWalkingAnimation()
//    }
//
//    func setupBackground() {
//        let sky = SKSpriteNode(imageNamed: "sky1")
//        sky.position = CGPoint(x: frame.midX, y: frame.midY)
//        sky.zPosition = 0
//        addChild(sky)
//
//    }
//
//    func setupTurtle() {
//        turtle = SKSpriteNode(imageNamed: "walkingBlue0")
//        turtle.position = CGPoint(x: frame.midX, y: frame.midY)
//        turtle.zPosition = 2
//        addChild(turtle)
//
//    }
//}
//
//    func startWalkingAnimation() {
//        turtle.run(SKAction.repeatForever(
//            SKAction.animate(with: walkingFrames, timePerFrame: 0.1)
//        ))
//    }
//
//
//
//    func setupScoreLabel() {
//        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
//        scoreLabel.text = "Score: \(score)"
//        scoreLabel.horizontalAlignmentMode = .left
//        scoreLabel.position = CGPoint(x: 10, y: frame.size.height - 50)
//        scoreLabel.zPosition = 10
//        addChild(scoreLabel)
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        let touchLocation = touch.location(in: self)
//
//        if touchLocation.y < frame.size.height / 2 {
//            // Tap on the bottom half of the screen to go underground
//            goUnderground()
//        } else {
//            // Tap on the top half of the screen to rotate
//            startRotationAnimation()
//        }
//    }
//
//    func goUnderground() {
//        turtle.removeAllActions()
//        turtle.run(SKAction.sequence([
//            SKAction.animate(with: undergroundFrames, timePerFrame: 0.1),
//            SKAction.wait(forDuration: 1.0), // Adjust duration based on obstacle
//            SKAction.animate(with: undergroundFrames.reversed(), timePerFrame: 0.1),
//            SKAction.run(startWalkingAnimation)
//        ]))
//    }
//
//    func startRotationAnimation() {
//        turtle.removeAllActions()
//        turtle.run(SKAction.sequence([
//            SKAction.animate(with: rotationFrames, timePerFrame: 0.1),
//            SKAction.run(startWalkingAnimation)
//        ]))
//    }
//
//    func spawnObstacles() {
//        // Logica per generare ostacoli a intervalli regolari
//        let obstacleTypes = ["cig1", "blueCan", "redCan", "yellowCan", "plasticBag1"]
//        let obstacle = SKSpriteNode(imageNamed: obstacleTypes.randomElement()!)
//        obstacle.position = CGPoint(x: frame.maxX, y: frame.midY)
//        obstacle.zPosition = 2
//        addChild(obstacle)
//
//        let moveAction = SKAction.moveBy(x: -frame.size.width, y: 0, duration: TimeInterval(5.0 / gameSpeed))
//        let removeAction = SKAction.removeFromParent()
//        obstacle.run(SKAction.sequence([moveAction, removeAction]))
//
//        // Pianifica la generazione del prossimo ostacolo
//        let spawnDelay = SKAction.wait(forDuration: TimeInterval.random(in: 2...5))
//        run(spawnDelay) {
//            self.spawnObstacles()
//        }
//    }
//
//    override func update(_ currentTime: TimeInterval) {
//        // Aggiorna la logica del gioco, inclusa la gestione degli ostacoli e la verifica delle collisioni
//        for obstacle in obstacles {
//            if turtle.frame.intersects(obstacle.frame) {
//                if turtle.action(forKey: "underground") == nil { // La tartaruga non è sottoterra
//                    lives -= 1
//                    if lives <= 0 {
//                        gameOver()
//                    }
//                }
//                obstacle.removeFromParent()
//            }
//        }
//    }
//
//    func gameOver() {
//        // Visualizza la schermata di Game Over con il punteggio e le opzioni di riavvio
//        let gameOverScene = GameOverScene(size: self.size, score: score)
//        self.view?.presentScene(gameOverScene, transition: SKTransition.flipHorizontal(withDuration: 0.5))
//    }
//}
//
//class GameOverScene: SKScene {
//    init(size: CGSize, score: Int) {
//        super.init(size: size)
//        // Configura la schermata di Game Over
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}


import Foundation
import SpriteKit
import SwiftUI

class GameScene: SKScene, ObservableObject{
    
    let player = SKSpriteNode(imageNamed: "walkingBlue0")
    
    var playerAnimationWalking = [SKTexture]()
    
    var playerAnimationRotate = [SKTexture]()
    
    var playerAnimationUnderGround = [SKTexture]()
    
    var redCanDestruction = [SKTexture]()
    
    var yellowCanDestruction = [SKTexture]()
    
    var blueCanDestruction = [SKTexture]()
    
    var touchesBegan = false
    
    var collision = false
    
    let pauseButton = SKSpriteNode(imageNamed: "pauseButton")
    
    var scoreLabel: SKLabelNode!
    var livesLabel: SKLabelNode!
    var score = 0
    var lives = 3
    var obstacles: [SKSpriteNode] = []
    var gameSpeed: CGFloat = 1.4 // Easy mode by default
    
    override func didMove(to view: SKView) {
        
        self.size = CGSize(width: 844, height: 390)
        scene?.scaleMode = .fill
        
        anchorPoint = .zero
        physicsWorld.gravity = CGVector(dx: 0, dy: -3)
        
        player.position = CGPoint(x: 0 + player.size.width / 3, y: size.height - player.size.height / 1 )
        player.setScale(0.35)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.categoryBitMask = 1
        player.zPosition = 10
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
        
        spawnCanObstacles()
        
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
        }
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
    
    func redCanExploding() {
    
    
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
                node.physicsBody?.contactTestBitMask = 1
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
    func spawnCanObstacles() {
        // Logica per generare ostacoli a intervalli regolari
        let obstacleCanTypes = [ "blueCan", "redCan", "yellowCan"]
        let obstacle = SKSpriteNode(imageNamed: obstacleCanTypes.randomElement()!)
        obstacle.position = CGPoint(x: frame.maxX, y: 150)
        obstacle.physicsBody?.affectedByGravity = false
        obstacle.zPosition = 2
        
        obstacle.setScale(0.30)
        
        addChild(obstacle)
        
        let moveAction = SKAction.moveBy(x: -frame.size.width, y: 0, duration: TimeInterval(4.2 / gameSpeed))
        let removeAction = SKAction.removeFromParent()
        obstacle.run(SKAction.sequence([moveAction, removeAction]))
        
        //Spawn Delay
        let spawnDelay = SKAction.wait(forDuration: TimeInterval.random(in: 2...6))
        run(spawnDelay) {
            self.spawnCanObstacles()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        for obstacle in obstacles {
            if player.frame.intersects(obstacle.frame) {
                if player.action(forKey: "underground") == nil { // La tartaruga non è sottoterra
                    lives -= 1
                    if lives <= 0 {
                        gameOver()
                    }
                }
                obstacle.removeFromParent()
            }
        }
    }
    
    func gameOver() {
        // Visualizza la schermata di Game Over con il punteggio e le opzioni di riavvio
        let gameOverScene = GameOverScene(size: self.size, score: score)
        self.view?.presentScene(gameOverScene, transition: SKTransition.flipHorizontal(withDuration: 0.5))
    }
}


class GameOverScene: SKScene {
    init(size: CGSize, score: Int) {
        super.init(size: size)
        // Configura la schermata di Game Over
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
