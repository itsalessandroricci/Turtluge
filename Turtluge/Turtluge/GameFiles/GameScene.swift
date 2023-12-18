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


class GameScene: SKScene, ObservableObject, SKPhysicsContactDelegate, AVAudioPlayerDelegate{
    
    var backgroundMusicPlayer: AVAudioPlayer!
    
    var canDestroySoundPlayer: AVAudioPlayer?
    
    var DamageSoundPlayer: AVAudioPlayer?
    
    let player = SKSpriteNode(imageNamed: "walkingBlue0")
    
    var playerAnimationWalking = [SKTexture]()
    
    var playerAnimationRotate = [SKTexture]()
    
    var playerAnimationUnderGround = [SKTexture]()
    
    var redCanDestruction = [SKTexture]()
    
    var yellowCanDestruction = [SKTexture]()
    
    var blueCanDestruction = [SKTexture]()
    
    var plasticBagAnimation = [SKTexture]()
    
    var cigAnimation = [SKTexture]()
    
    var damageAnimation = [SKTexture]()
    
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
        
        // DamageAnimation
        
        let textureDamageAnimation = SKTextureAtlas(named: "DamageAnimation")
        for i in 1..<textureDamageAnimation.textureNames.count {
            
            let name = "DamageAnimation" + String(i)
            damageAnimation.append(textureDamageAnimation.textureNamed(name))
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
        
        obstaclesSpawn()
        
//        let spawnDelayRed = SKAction.wait(forDuration: TimeInterval.random(in: 1...2))
//        run(spawnDelayRed) {
//            self.spawnRedCanObstacles()
//        }
//        
//        let spawnDelayYellow = SKAction.wait(forDuration: TimeInterval.random(in: 4...5))
//        run(spawnDelayYellow) {
//            self.spawnYellowCanObstacles()
//        }
//        
//        let spawnDelayBlue = SKAction.wait(forDuration: TimeInterval.random(in: 8...9))
//        run(spawnDelayBlue) {
//            self.spawnBlueCanObstacles()
//        }
//        
//        let spawnDelayPlastic = SKAction.wait(forDuration: TimeInterval.random(in: 11...12))
//        run(spawnDelayPlastic) {
//            self.spawnPlasticBagObstacles()
//        }
//        
//        let spawnDelayCig = SKAction.wait(forDuration: TimeInterval.random(in: 14...18))
//        run(spawnDelayCig) {
//            self.spawnCigObstacles()
//        }
        
        setupScoreLabel()
        
        setupLivesLabel()
        
        loadBackgroundMusic()
        
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
        // Interrompi la musica di sottofondo
        backgroundMusicPlayer.pause()

        if let canDestroySoundURL = Bundle.main.url(forResource: "canDestroyMusic", withExtension: "mp3") {
            do {
                canDestroySoundPlayer = try AVAudioPlayer(contentsOf: canDestroySoundURL)
                canDestroySoundPlayer?.volume = 1.0
                canDestroySoundPlayer?.rate = 0.5
                canDestroySoundPlayer?.delegate = self
                canDestroySoundPlayer?.play()
            } catch let error {
                print("Errore nella riproduzione dell'audio di distruzione della lattina: \(error.localizedDescription)")
                
                backgroundMusicPlayer.play()
            }
        } else {
            print("File audio di distruzione della lattina non trovato.")
           
            backgroundMusicPlayer.play()
        }
    }


    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if player == canDestroySoundPlayer {
            
            backgroundMusicPlayer.play()
        }
        if player == DamageSoundPlayer {
            // Riprendi la musica di sottofondo dopo l'effetto di danneggiamento
            backgroundMusicPlayer.play()
        }
    }
    
    func playDamageSound() {
            backgroundMusicPlayer.pause()

            if let DamageSoundSoundURL = Bundle.main.url(forResource: "turtleDamage", withExtension: "mp3") {
                do {
                    DamageSoundPlayer = try AVAudioPlayer(contentsOf: DamageSoundSoundURL)
                    DamageSoundPlayer?.volume = 1.0
                    DamageSoundPlayer?.rate = 0.5
                    DamageSoundPlayer?.delegate = self
                    DamageSoundPlayer?.play()
                } catch let error {
                    print("Errore nella riproduzione dell'audio di danneggiamento: \(error.localizedDescription)")
                    backgroundMusicPlayer.play()
                }
            } else {
                print("File audio di danneggiamento non trovato.")
                backgroundMusicPlayer.play()
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
    
    func startDamageAnimation() {
        
        player.removeAllActions()
        
        player.run(SKAction.sequence([
            SKAction.group([
                SKAction.animate(with: damageAnimation, timePerFrame: 0.08),
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
                playCanDestroySound()
            }
            
            
            
            
            else {
                    self.lives -= 1
                    livesLabel.text = "Lives: \(self.lives)"
                
                    playDamageSound()
                    startDamageAnimation()
                
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
                playCanDestroySound()
            }
            
            else {
                    self.lives -= 1
                    livesLabel.text = "Lives: \(self.lives)"
                    playDamageSound()
                    startDamageAnimation()
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
                playCanDestroySound()
            }
            
            else {
                    self.lives -= 1
                    livesLabel.text = "Lives: \(self.lives)"
                    playDamageSound()
                    startDamageAnimation()
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
                    playDamageSound()
                    startDamageAnimation()
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
                    playDamageSound()
                    startDamageAnimation()
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
    

    func obstaclesSpawn() {
     
        let obstaclesData = [
            ("redCan", "redCan"),
            ("yellowCan", "yellowCan"),
            ("blueCan", "blueCan"),
            ("plasticBag1", "plasticBag"),
            ("cig1", "cig")
        ]

       
        let randomObstacleData = obstaclesData.randomElement()!

       
        let (obstacleType, obstacleName) = randomObstacleData

        
        let obstacle = SKSpriteNode(imageNamed: obstacleType)
        obstacle.position = CGPoint(x: frame.maxX, y: 150)
        obstacle.physicsBody?.affectedByGravity = false
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.categoryBitMask = 2
        obstacle.physicsBody?.contactTestBitMask = 1
        obstacle.name = obstacleName
        obstacle.zPosition = 3
        obstacle.setScale(0.30)

        if obstacleName == "plasticBag" {
            obstacle.run(SKAction.repeatForever(SKAction.animate(with: plasticBagAnimation, timePerFrame: 0.20)))
        }
        
        if obstacleName == "cig" {
            obstacle.run(SKAction.repeatForever(SKAction.animate(with: cigAnimation, timePerFrame: 0.15)))
        }
        
        
       
        addChild(obstacle)

        
        let moveAction = SKAction.moveBy(x: -frame.size.width, y: 0, duration: TimeInterval(4.2 / gameSpeed))
        let removeAction = SKAction.removeFromParent()
        obstacle.run(SKAction.sequence([moveAction, removeAction]))

        
        let spawnDelay = SKAction.wait(forDuration: TimeInterval.random(in: 2...6))
        run(spawnDelay) {
            self.obstaclesSpawn()
        }
        
        //redCanDestruction
        
        let textureRedCanDestruction = SKTextureAtlas(named: "redCanDestruction")
        for i in 1..<textureRedCanDestruction.textureNames.count {
            
            let name = "redExplodingCan" + String(i)
            redCanDestruction.append(textureRedCanDestruction.textureNamed(name))
        }
        
        //yellowCanDestruction
        
        let textureYellowCanDestruction = SKTextureAtlas(named: "yellowCanDestruction")
        for i in 1..<textureYellowCanDestruction.textureNames.count {
            
            let name = "yellowExplodingCan" + String(i)
            yellowCanDestruction.append(textureYellowCanDestruction.textureNamed(name))
        }
        
        //blueCanDestruction
        
        let textureBlueCanDestruction = SKTextureAtlas(named: "blueCanDestruction")
        for i in 1..<textureBlueCanDestruction.textureNames.count {
            
            let name = "blueExplodingCan" + String(i)
            blueCanDestruction.append(textureBlueCanDestruction.textureNamed(name))
        }
        
        //PlasticBag Animation
        
        let texturePlasticBag = SKTextureAtlas(named: "plasticAnimation")
        for i in 1..<texturePlasticBag.textureNames.count {
            
            let name = "plasticBag" + String(i)
            plasticBagAnimation.append(texturePlasticBag.textureNamed(name))
        }
        
        // Cig Animation
        
        let textureCig = SKTextureAtlas(named: "cigAnimation")
        for i in 1..<textureCig.textureNames.count {
            
            let name = "cig" + String(i)
            cigAnimation.append(textureCig.textureNamed(name))
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
