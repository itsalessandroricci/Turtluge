//
//  ContentView.swift
//  Turtluge
//
//  Created by Alessandro Ricci on 12/12/23.
//

//import SwiftUI
//
//struct ContentView: View {
//
//    @State var currentGameState: GameState = .startPage
//
//
//    @StateObject var gameLogic: ArcadeGameLogic = ArcadeGameLogic()
//
//    var body: some View {
//
//        switch currentGameState {
//        case .startPage:
//            StartPageView(currentGameState: $currentGameState)
//                .environmentObject(gameLogic)
//
//        case .playing:
//            GameView(currentGameState: $currentGameState)
//                .environmentObject(gameLogic)
//
//        case .gameOver:
//            GameOverView(currentGameState: $currentGameState)
//                .environmentObject(gameLogic)
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//}

