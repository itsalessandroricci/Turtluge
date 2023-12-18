//
//  InstructionsView.swift
//  Turtluge
//
//  Created by Alessandro Ricci on 18/12/23.
//

import SwiftUI

struct InstructionsView: View {
    var body: some View {
        
        NavigationStack{
            NavigationLink(destination: GameView()){
                ZStack{
                    
                    Image("backgroundGame")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 900)
                        .ignoresSafeArea()
                    
                    
                    
                    Image("eggsBackStart")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 820)
                        .ignoresSafeArea()
                        .padding(.top, 220)
                        .padding(.trailing, 750)
                    
                    Image("beach1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 950)
                        .ignoresSafeArea()
                        .padding(.top, 295)
                    
                    
                    
                    Image("standingGreen")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120)
                        .ignoresSafeArea()
                        .padding(.top, 230)
                        .padding(.trailing, 580)
                    
                    Image("eggsFront Start")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 820)
                        .ignoresSafeArea()
                        .padding(.top, 300)
                        .padding(.trailing, 310)
                    
                    HStack{
                        NavigationLink(destination: StartPageView()) {
                            Image("arrow")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50)
                                .padding(.bottom, 280)
                                .padding(.trailing,740)
                            
                            
                        }
                    }
                    
                    
                    HStack{
                        
                        Image("sign")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 400)
                            .padding(.top, 110)
                            .offset(y: 15)
                        
                        
                    }
                    
                    Text("TAP ANYWHERE TO START")
                        .padding(.bottom, 250)
                        .font(.custom("Chalkduster", size: 40))
                        .foregroundColor(.green)
                    
                    
                    
                    
                    
                    
                }//ZSTACK
                .frame(width: 844, height: 390, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
            }
        
            
        }//NAVI
        .navigationViewStyle(StackNavigationViewStyle())
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

#Preview {
    InstructionsView()
}
