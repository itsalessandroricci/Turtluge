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
            Color.black.edgesIgnoringSafeArea(.all)
            HStack{
                Image("gameOver")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 650)
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
    GameOverView()
}
