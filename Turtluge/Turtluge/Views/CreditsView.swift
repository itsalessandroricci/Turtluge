//
//  CreditsView.swift
//  Turtluge
//
//  Created by Alessandro Ricci on 12/12/23.
//

import SwiftUI

struct CreditsView: View {
    var body: some View {
        
        NavigationStack{
            
            ZStack{
                
                Image("backgroundGame")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 900)
                    .ignoresSafeArea()
                
                Image("standingGreen")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120)
                    .ignoresSafeArea()
                    .scaleEffect(x: -1, y: 1)
                    .padding(.top, 300)
                    .padding(.leading, 620)
                    
                Image("credits")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 500)
                    .ignoresSafeArea()
                    .padding(.bottom, 50)
                
                
                NavigationLink(destination: SettingsView()) {
                    Image("arrow")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                        .padding(.bottom, 280)
                        .padding(.trailing,740)
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
    CreditsView()
}
