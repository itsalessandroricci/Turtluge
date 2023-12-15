//
//  StartPageView.swift
//  Turtluge
//
//  Created by Alessandro Ricci on 12/12/23.
//

import SwiftUI

struct StartPageView: View {
    var body: some View {
        NavigationStack{
            
            ZStack{
                Image("backgroundGame")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 900)
                    .ignoresSafeArea()
                
                NavigationLink(destination: SettingsView()) {
                    Image("settingsIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                        .padding(.bottom, 250)
                        .padding(.leading,750)
                }
                
                VStack{
                    Image("title")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250)
                        .padding(.top, 25)
                    
                    HStack{
                        
                        NavigationLink(destination: GameView()) {
                            Image("easyButton")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 230)
                        }
                        NavigationLink(destination: GameView()) {
                            Image("mediumButton")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 220)
                        }
                        NavigationLink(destination: GameView()) {
                            Image("hardButton")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 230)
                        }
                        
                    } //HStack
                   
                } //VStack
 
            }//ZSTACK
            .frame(width: 844, height: 390, alignment: .center)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }//NAVI
        .navigationViewStyle(StackNavigationViewStyle())
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

#Preview {
    StartPageView()
}
