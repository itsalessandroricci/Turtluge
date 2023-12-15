//
//  GameOverView.swift
//  Turtluge
//
//  Created by Alessandro Ricci on 12/12/23.
//

import SwiftUI

struct GameOverView: View {
    var body: some View {
        
        ZStack{
            
            Image("backgroundGame")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 900)
                .ignoresSafeArea()
            
            
            
            HStack{
                Image("gameOver")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 600)
                    .padding(.bottom,200)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .ignoresSafeArea()
            
            HStack{
                
                NavigationLink(destination:
                                GameView()) {
                    Image("restartButton")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200)
                }
                
                NavigationLink(destination: StartPageView()) {
                    Image("homeButton")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200)
                }
                
            }
            .padding(.top, 150)
          
        }
        
        .ignoresSafeArea()
        
    }
}

#Preview {
    GameOverView()
}
