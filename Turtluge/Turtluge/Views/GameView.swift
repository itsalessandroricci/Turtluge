//
//  GameView.swift
//  Turtluge
//
//  Created by Alessandro Ricci on 12/12/23.
//

import SwiftUI
import SpriteKit

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
            
            NavigationLink(destination: StartPageView(), label: { Text("Navigate")})
        }
        .ignoresSafeArea()
    }
}

#Preview {
    GameView()
}
