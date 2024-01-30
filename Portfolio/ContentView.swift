//
//  ContentView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 30.1.24..
//

import SwiftUI
import SwiftData

struct ContentView: View {
    let tabs: [TabScreenView.Data] = [
        .init(
            navigation: .init(
                title: "Projects", tabIcon: "folder"
            ), 
            content: .init(Text("A"))
        ),
        .init(
            navigation: .init(
                title: "About", tabIcon: "person"
            ), 
            content: .init(Text("B"))
        ),
    ]
    
    var body: some View {
        TabView {
            ForEach(tabs) { data in
                TabScreenView(data: data)
            }
        }
    }
}

struct TabScreenView: View {
    let data: Data

    var body: some View {
        NavigationStack {
            data.content
                .navigationTitle(data.navigation.title)
        }
        .tabItem { Label(data.navigation.title, systemImage: data.navigation.tabIcon) }
    }
    
    struct Data: Identifiable {
        let navigation: Navigation
        let content: AnyView
        let id = UUID()
        
        struct Navigation {
            let title: String
            let tabIcon: String
        }
    }
}



#Preview {
    ContentView()
}
