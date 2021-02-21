//
//  ContentView.swift
//  ASLVision
//
//  Created by Théo Arrouye on 2/20/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            QuizTabView()
                .tabItem {
                    Label("QUIZZES_LABEL", systemImage: "list.dash")
                }

            AlphabetListView()
                .tabItem {
                    Label("ALPHABET_LABEL", systemImage: "textformat.alt")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
