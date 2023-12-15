//
//  SettingsView.swift
//  Turtluge
//
//  Created by Alessandro Ricci on 12/12/23.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var isMuted = false
    
    var body: some View {
        
        NavigationStack{
            
            ZStack{
                
                Image("backgroundGame")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 900)
                    .ignoresSafeArea()
                
                NavigationLink(destination: StartPageView()) {
                    Image("arrow")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                        .padding(.bottom, 280)
                        .padding(.trailing,740)
                }
                
                
                HStack{
                    VStack {
                        Button(action: {
                            
                            isMuted.toggle()
                        }) {
                            Image(isMuted ? "muteIcon" : "volumeIcon")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 250)
                        }
                    }
                    
                    NavigationLink(destination: CreditsView()) {
                        Image("creditsButton")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 250)
                    }
                    
                }
                
                
                
                
                
            }//ZSTACK
            .frame(width: 844, height: 390, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
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
    SettingsView()
}
