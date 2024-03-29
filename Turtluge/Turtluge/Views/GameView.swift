//
//  GameView.swift
//  Turtluge
//
//  Created by Alessandro Ricci on 12/12/23.
//

import SwiftUI
import SpriteKit
import AVFoundation


struct GameView: View {
    @StateObject private var game = GameScene()
    var body: some View {
        
        ZStack{
            
            HStack{
                SpriteView(scene: game)
                    .ignoresSafeArea()
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .ignoresSafeArea()
            
            if game.isGameOver{
//            NavigationLink(destination: GameOverView(), label: { Text("GAME-OVER")})
                GameOverView()
                
//                    .onAppear {
//                                            game.playGameOverSound()
//                                        }

                
        }
            
            if game.isPausedG{
                
                PauseView()
                
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    GameView()
}
