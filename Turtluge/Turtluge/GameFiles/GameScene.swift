//
//  GameScene.swift
//  Turtluge
//
//  Created by Alessandro Ricci on 12/12/23.
//

import Foundation
import SpriteKit
import SwiftUI
import AVFoundation


class GameScene: SKScene, ObservableObject, SKPhysicsContactDelegate{
    
    var backgroundMusicPlayer: AVAudioPlayer!
    
    let player = SKSpriteNode(imageNamed: "walkingBlue0")
    
    var playerAnimationWalking = [SKTexture]()
    
    var playerAnimationRotate = [SKTexture]()
    
    var playerAnimationUnderGround = [SKTexture]()
    
    var redCanDestruction = [SKTexture]()
    
    var yellowCanDestruction = [SKTexture]()
    
    var blueCanDestruction = [SKTexture]()
    
    var plasticBagAnimation = [SKTexture]()
    
    var cigAnimation = [SKTexture]()
    
    var touchesBegan = false
    
    var isRolling = false
    
    var isUnderGround = false
    
    var collision = false
    
    let pauseButton = SKSpriteNode(imageNamed: "pauseButton")
    
    var scoreLabel: SKLabelNode!
    
    var livesLabel: SKLabelNode!
    
    var score = 0
    
    var lives: Int = 3
    
    var obstacles: [SKSpriteNode] = []
    
    var gameSpeed: CGFloat = 1.4 // Easy mode by default
    
    
    @Published var isGameOver = false
    @Published var isPausedG = false
    
    
   
    
    
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
        
//        //redCanDestruction
//        
//        let textureRedCanDestruction = SKTextureAtlas(named: "redCanDestruction")
//        for i in 1..<textureRedCanDestruction.textureNames.count {
//            
//            let name = "redExplodingCan" + String(i)
//            redCanDestruction.append(textureRedCanDestruction.textureNamed(name))
//        }
        
        
        moveBackGround(image: "sky1", y: 0, z: -5, duration: 90000, needPhysics: false, size: self.size)
        
        moveBackGround(image: "sea1", y: 0, z:-2, duration: 3, needPhysics: false, size: CGSize(width: self.size.width, height: 120))
        
        moveBackGround(image: "beach1", y: 0, z:-2, duration: 3, needPhysics: true, size: CGSize(width: self.size.width, height: 50))
        
        moveBackGround(image: "beach1", y: 0, z:-2, duration: 3, needPhysics: false, size: CGSize(width: self.size.width, height: 100))
        
        
        player.run(SKAction.repeatForever(SKAction.animate(with: playerAnimationWalking, timePerFrame: 0.10)))
        
        
        let spawnDelayRed = SKAction.wait(forDuration: TimeInterval.random(in: 1...2))
        run(spawnDelayRed) {
            self.spawnRedCanObstacles()
        }
        
        let spawnDelayYellow = SKAction.wait(forDuration: TimeInterval.random(in: 4...5))
        run(spawnDelayYellow) {
            self.spawnYellowCanObstacles()
        }
        
        let spawnDelayBlue = SKAction.wait(forDuration: TimeInterval.random(in: 8...9))
        run(spawnDelayBlue) {
            self.spawnBlueCanObstacles()
        }
        
        let spawnDelayPlastic = SKAction.wait(forDuration: TimeInterval.random(in: 11...12))
        run(spawnDelayPlastic) {
            self.spawnPlasticBagObstacles()
        }
        
        let spawnDelayCig = SKAction.wait(forDuration: TimeInterval.random(in: 14...18))
        run(spawnDelayCig) {
            self.spawnCigObstacles()
        }
        
        setupScoreLabel()
        
        setupLivesLabel()
        
        loadBackgroundMusic()
        
        playGameOverSound()

        
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        if pauseButton.contains(touchLocation) {
                isPaused()
            self.removeAllActions()
            backgroundMusicPlayer.stop()
            
            }
        
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
        self.isUnderGround = false
    }
    
    func loadBackgroundMusic() {
        if let musicURL = Bundle.main.url(forResource: "TurtlugeMusic", withExtension: "mp3") {
            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: musicURL)
                backgroundMusicPlayer.numberOfLoops = -1 
                backgroundMusicPlayer.volume = 0.5
                backgroundMusicPlayer.play()
            } catch {
                print("Errore nel caricare il file audio di sottofondo.")
            }
        } else {
            print("File audio di sottofondo non trovato.")
        }
    }
    
    func playGameOverSound() {
        if let gameOverSoundURL = Bundle.main.url(forResource: "GameOver", withExtension: "mp3") {
            do {
                let gameOverSoundPlayer = try AVAudioPlayer(contentsOf: gameOverSoundURL)
                gameOverSoundPlayer.volume = 1.0  // Imposta il volume desiderato
                gameOverSoundPlayer.play()
            } catch {
                print("Errore nel caricare il file audio di Game Over.")
            }
        } else {
            print("File audio di Game Over non trovato.")
        }
    }
    
    func playCanDestroySound() {
        if let canDestroySoundURL = Bundle.main.url(forResource: "canDestroyMusic", withExtension: "mp3") {
            do {
                let canDestroySoundPlayer = try AVAudioPlayer(contentsOf: canDestroySoundURL)
                canDestroySoundPlayer.volume = 1.0  // Imposta il volume desiderato
                canDestroySoundPlayer.play()
            } catch {
                print("Errore nel caricare il file audio di distruzione della redCan.")
            }
        } else {
            print("File audio di distruzione della redCan non trovato.")
        }
    }
    
    func goUnderground() {
        self.isUnderGround = true
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
        
        //RED CAN CONTACT
        
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
                self.score += 1
                scoreLabel.text = "Score: \(score)"
                print("+1 Point!! Congrats. The update score:\(score)")
            }
            
            
            
            
            else {
                    self.lives -= 1
                    livesLabel.text = "Lives: \(self.lives)"
                    if lives <= 0 {
                        print("GAMEOVER")
                        
                        playGameOverSound()
                        gameOver()
                    }
                    
                    print("RedCan hit player. Remaining Lives: \(lives)")
                
            }
                playerHit(node: nodeB)
            }
        
        //YELLOW CAN CONTACT
        
        if (nodeA == player && nodeB.name == "yellowCan") || (nodeB == player && nodeA.name == "yellowCan") {
                // Check if either nodeA or nodeB is the player, and the other is a redCan
            if self.isRolling {
                nodeB.run(SKAction.sequence([
                    SKAction.group([
                        SKAction.animate(with: yellowCanDestruction, timePerFrame: 0.25),
                        SKAction.wait(forDuration: 1.0),
                        SKAction.scale(to: 0.85, duration: 0.05),
                        SKAction.scaleX(by: 1, y: 0.90, duration: 0.0)
                    ])
                ]))
                self.score += 1
                scoreLabel.text = "Score: \(score)"
                print("+1 Point!! Congrats. The update score:\(score)")
            }
            
            else {
                    self.lives -= 1
                    livesLabel.text = "Lives: \(self.lives)"
                    if lives <= 0 {
                        print("GAMEOVER")
                        
                        playGameOverSound()
                        gameOver()
                    }
                    
                    print("YellowCan hit player. Remaining Lives: \(lives)")
                
            }
                playerHit(node: nodeB)
            }
        
        
        //BLUE CAN CONTACT
        if (nodeA == player && nodeB.name == "blueCan") || (nodeB == player && nodeA.name == "blueCan") {
                // Check if either nodeA or nodeB is the player, and the other is a redCan
            if self.isRolling {
                nodeB.run(SKAction.sequence([
                    SKAction.group([
                        SKAction.animate(with: blueCanDestruction, timePerFrame: 0.25),
                        SKAction.wait(forDuration: 1.0),
                        SKAction.scale(to: 0.45, duration: 0.05),
                        SKAction.scaleX(by: 1, y: 0.90, duration: 0.0)
                    ])
                ]))
                self.score += 1
                scoreLabel.text = "Score: \(score)"
                print("+1 Point!! Congrats. The update score:\(score)")
            }
            
            else {
                    self.lives -= 1
                    livesLabel.text = "Lives: \(self.lives)"
                    if lives <= 0 {
                        print("GAMEOVER")
                        
                        playGameOverSound()
                        gameOver()
                    }
                    
                    print("BlueCan hit player. Remaining Lives: \(lives)")
                
            }
                playerHit(node: nodeB)
            }
        
        //PLASTICBAG CONTACT
        if (nodeA == player && nodeB.name == "plasticBag") || (nodeB == player && nodeA.name == "plasticBag") {
                // Check if either nodeA or nodeB is the player, and the other is a redCan
            if self.isUnderGround {
                
                self.score += 1
                scoreLabel.text = "Score: \(score)"
                print("+1 Point!! Congrats. The update score:\(score)")
            
                
            }
            
            else {
                    self.lives -= 1
                    livesLabel.text = "Lives: \(self.lives)"
                    if lives <= 0 {
                        print("GAMEOVER")
                        
                        playGameOverSound()
                        gameOver()
                    }
                    
                    print("PlasticBag hit player. Remaining Lives: \(lives)")
                
            }
                playerHit(node: nodeB)
            }
        
        //CIG CONTACT
        if (nodeA == player && nodeB.name == "cig") || (nodeB == player && nodeA.name == "cig") {
                // Check if either nodeA or nodeB is the player, and the other is a redCan
            if self.isUnderGround {
                
                self.score += 1
                scoreLabel.text = "Score: \(score)"
                print("+1 Point!! Congrats. The update score:\(score)")
                
            }
            
            else {
                    self.lives -= 1
                    livesLabel.text = "Lives: \(self.lives)"
                    if lives <= 0 {
                        print("GAMEOVER")
                        
                        playGameOverSound()
                        gameOver()
                    }
                    
                    print("Cig hit player. Remaining Lives: \(lives)")
                
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
        
         let spawnDelayRed = SKAction.wait(forDuration: TimeInterval.random(in: 1...10))
         run(spawnDelayRed) {
             self.spawnRedCanObstacles()
         }
    }
    
    // YellowCanSpawn
     func spawnYellowCanObstacles() {
        // Logica per generare ostacoli a intervalli regolari
        let obstacleYellowCanTypes = ["yellowCan"]
        let obstacleYellowCan = SKSpriteNode(imageNamed: obstacleYellowCanTypes.randomElement()!)
        obstacleYellowCan.position = CGPoint(x: frame.maxX, y: 150)
        obstacleYellowCan.physicsBody?.affectedByGravity = false
        obstacleYellowCan.physicsBody = SKPhysicsBody(rectangleOf: obstacleYellowCan.size)
        obstacleYellowCan.physicsBody?.isDynamic = false
        obstacleYellowCan.physicsBody?.categoryBitMask = 2
        obstacleYellowCan.physicsBody?.contactTestBitMask = 1
//        obstacleRedCan.physicsBody = SKPhysicsBody(texture: obstacleRedCan.texture!,size: obstacleRedCan.texture!.size())
        
        obstacleYellowCan.name = "yellowCan"
//         obstacles.append(obstacleRedCan)
        
        obstacleYellowCan.zPosition = 3
        
        obstacleYellowCan.setScale(0.30)
        
        
        addChild(obstacleYellowCan)
        
        let moveAction = SKAction.moveBy(x: -frame.size.width, y: 0, duration: TimeInterval(4.2 / gameSpeed))
        let removeAction = SKAction.removeFromParent()
        obstacleYellowCan.run(SKAction.sequence([moveAction, removeAction]))
        
        //Animation
        
        //yellowCanDestruction
        
        let textureYellowCanDestruction = SKTextureAtlas(named: "yellowCanDestruction")
        for i in 1..<textureYellowCanDestruction.textureNames.count {
            
            let name = "yellowExplodingCan" + String(i)
            yellowCanDestruction.append(textureYellowCanDestruction.textureNamed(name))
        }
        
        if player.frame.intersects(obstacleYellowCan.frame){
            obstacleYellowCan.run(SKAction.sequence([
                SKAction.group([
                    
                    SKAction.animate(with: yellowCanDestruction, timePerFrame: 0.1),
                    SKAction.wait(forDuration: 0.000001),
                    SKAction.scale(to: 0.45, duration: 0.0),
                    SKAction.scaleX(by: 1, y: 0.90, duration: 0.5)
                ])
            ]))
        }
        
         let spawnDelayYellow = SKAction.wait(forDuration: TimeInterval.random(in: 2...12))
         run(spawnDelayYellow) {
             self.spawnYellowCanObstacles()
         }
       
         
    }

    // BlueCanSpawn
     func spawnBlueCanObstacles() {
        // Logica per generare ostacoli a intervalli regolari
        let obstacleBlueCanTypes = ["blueCan"]
        let obstacleBlueCan = SKSpriteNode(imageNamed: obstacleBlueCanTypes.randomElement()!)
        obstacleBlueCan.position = CGPoint(x: frame.maxX, y: 150)
        obstacleBlueCan.physicsBody?.affectedByGravity = false
        obstacleBlueCan.physicsBody = SKPhysicsBody(rectangleOf: obstacleBlueCan.size)
        obstacleBlueCan.physicsBody?.isDynamic = false
         obstacleBlueCan.physicsBody?.categoryBitMask = 2
        obstacleBlueCan.physicsBody?.contactTestBitMask = 1
//        obstacleRedCan.physicsBody = SKPhysicsBody(texture: obstacleRedCan.texture!,size: obstacleRedCan.texture!.size())
        
        obstacleBlueCan.name = "blueCan"
//         obstacles.append(obstacleRedCan)
        
        obstacleBlueCan.zPosition = 3
        
        obstacleBlueCan.setScale(0.30)
        
        
        addChild(obstacleBlueCan)
        
        let moveAction = SKAction.moveBy(x: -frame.size.width, y: 0, duration: TimeInterval(4.2 / gameSpeed))
        let removeAction = SKAction.removeFromParent()
        obstacleBlueCan.run(SKAction.sequence([moveAction, removeAction]))
        
        //Animation
        
        //yellowCanDestruction
        
        let textureBlueCanDestruction = SKTextureAtlas(named: "blueCanDestruction")
        for i in 1..<textureBlueCanDestruction.textureNames.count {
            
            let name = "blueExplodingCan" + String(i)
            blueCanDestruction.append(textureBlueCanDestruction.textureNamed(name))
        }
        
        if player.frame.intersects(obstacleBlueCan.frame){
            obstacleBlueCan.run(SKAction.sequence([
                SKAction.group([
                    
                    SKAction.animate(with: blueCanDestruction, timePerFrame: 0.1),
                    SKAction.wait(forDuration: 0.000001),
                    SKAction.scale(to: 0.45, duration: 0.0),
                    SKAction.scaleX(by: 1, y: 0.90, duration: 0.5)
                ])
            ]))
        }
        
        
        //Spawn Delay
       
         let spawnDelayBlue = SKAction.wait(forDuration: TimeInterval.random(in: 3...14))
         run(spawnDelayBlue) {
             self.spawnBlueCanObstacles()
         }
    }
    
    // PlasticBagCanSpawn
     func spawnPlasticBagObstacles() {
        // Logica per generare ostacoli a intervalli regolari
        let obstaclePlasticBagTypes = ["plasticBag1"]
        let obstaclePlasticBag = SKSpriteNode(imageNamed: obstaclePlasticBagTypes.randomElement()!)
        obstaclePlasticBag.position = CGPoint(x: frame.maxX, y: 150)
        obstaclePlasticBag.physicsBody?.affectedByGravity = false
        obstaclePlasticBag.physicsBody = SKPhysicsBody(rectangleOf: obstaclePlasticBag.size)
        obstaclePlasticBag.physicsBody?.isDynamic = false
         obstaclePlasticBag.physicsBody?.categoryBitMask = 2
        obstaclePlasticBag.physicsBody?.contactTestBitMask = 1
//        obstacleRedCan.physicsBody = SKPhysicsBody(texture: obstacleRedCan.texture!,size: obstacleRedCan.texture!.size())
        
        obstaclePlasticBag.name = "plasticBag"
//         obstacles.append(obstacleRedCan)
        
        obstaclePlasticBag.zPosition = 3
        
        obstaclePlasticBag.setScale(0.30)
        
        
        addChild(obstaclePlasticBag)
        
        let moveAction = SKAction.moveBy(x: -frame.size.width, y: 0, duration: TimeInterval(4.2 / gameSpeed))
        let removeAction = SKAction.removeFromParent()
        obstaclePlasticBag.run(SKAction.sequence([moveAction, removeAction]))
        
        //Animation
        
        //plasticBagAnimation
        
        let texturePlasticBag = SKTextureAtlas(named: "plasticAnimation")
        for i in 1..<texturePlasticBag.textureNames.count {
            
            let name = "plasticBag" + String(i)
            plasticBagAnimation.append(texturePlasticBag.textureNamed(name))
        }
        
    obstaclePlasticBag.run(SKAction.repeatForever(SKAction.animate(with: plasticBagAnimation, timePerFrame: 0.20)))
        
       
         let spawnDelayPlastic = SKAction.wait(forDuration: TimeInterval.random(in: 4...16))
         run(spawnDelayPlastic) {
             self.spawnPlasticBagObstacles()
         }
        
    }
    
    // CigCanSpawn
     func spawnCigObstacles() {
        // Logica per generare ostacoli a intervalli regolari
        let obstacleCigTypes = ["cig1"]
        let obstacleCig = SKSpriteNode(imageNamed: obstacleCigTypes.randomElement()!)
        obstacleCig.position = CGPoint(x: frame.maxX, y: 150)
        obstacleCig.physicsBody?.affectedByGravity = false
        obstacleCig.physicsBody = SKPhysicsBody(rectangleOf: obstacleCig.size)
        obstacleCig.physicsBody?.isDynamic = false
         obstacleCig.physicsBody?.categoryBitMask = 2
        obstacleCig.physicsBody?.contactTestBitMask = 1
//        obstacleRedCan.physicsBody = SKPhysicsBody(texture: obstacleRedCan.texture!,size: obstacleRedCan.texture!.size())
        
        obstacleCig.name = "cig"
//         obstacles.append(obstacleRedCan)
        
        obstacleCig.zPosition = 3
        
        obstacleCig.setScale(0.30)
        
        
        addChild(obstacleCig)
        
        let moveAction = SKAction.moveBy(x: -frame.size.width, y: 0, duration: TimeInterval(4.2 / gameSpeed))
        let removeAction = SKAction.removeFromParent()
        obstacleCig.run(SKAction.sequence([moveAction, removeAction]))
        
        //Animation
        
        //CigAnimation
        
        let textureCig = SKTextureAtlas(named: "cigAnimation")
        for i in 1..<textureCig.textureNames.count {
            
            let name = "cig" + String(i)
            cigAnimation.append(textureCig.textureNamed(name))
        }
        
    obstacleCig.run(SKAction.repeatForever(SKAction.animate(with: cigAnimation, timePerFrame: 0.15)))
        
       
         let spawnDelayCig = SKAction.wait(forDuration: TimeInterval.random(in: 2...18))
         run(spawnDelayCig) {
             self.spawnCigObstacles()
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
    func isPaused() {
        
        isPausedG = true
        
    }
    func gameOver() {
        // Visualizza la schermata di Game Over con il punteggio e le opzioni di riavvio
        
        
        
        backgroundMusicPlayer.stop()
        
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
