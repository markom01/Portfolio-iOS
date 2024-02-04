//
//  TabsView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 30.1.24..
//

import SwiftUI
import SwiftData

struct TabsView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var context
    @Query var preferences: [Preference]
    
    let tabs: [TabScreenView.Data] = [
        .init(
            navigation: .init(
                title: "Projects", tabIcon: "folder"
            ), 
            content: .init(ProjectsView())
        ),
        .init(
            navigation: .init(
                title: "Skills", tabIcon: "star"
            ),
            content: .init(Text("B"))
        ),
        .init(
            navigation: .init(
                title: "About", tabIcon: "person"
            ), 
            content: .init(Text("B"))
        ),

    ]
    
    var body: some View {
        NavigationStack {
             TabView {
                 ForEach(tabs) { TabScreenView(data: $0).tag($0.id) }
            }
             .navigationBarTitleDisplayMode(.inline)
             .toolbarBackground(.visible, for: .navigationBar)
             .toolbar {
                 ToolbarItem(placement: .principal) {
                     ImageView(name: .gemJewel, size: 30)
                 }
                 
                 ToolbarItem(placement: .topBarTrailing) {
                     SwitchView(
                        isOn: Binding(
                            get: { preferences.first?.isDarkMode ?? (colorScheme == .dark) },
                            set: { preferences.first?.isDarkMode = $0 }
                        )
                     )
                 }
             }
        }
        .onAppear {
            if preferences.isEmpty {
                context.insert(Preference(isDarkMode: colorScheme == .dark))
            }
        }
        .environment(\.colorScheme, preferences.first?.isDarkMode ?? (colorScheme == .dark) ? .dark : .light)
        .overlay {
            LaunchView(
                backgroundColor: preferences.first?.isDarkMode ?? (colorScheme == .dark) ? .black : .white)
        }
        .animation(.linear(duration: 0.3), value: preferences.first?.isDarkMode)
    }
}

#Preview {
    TabsView()
        .modelContainer(for: Preference.self)
}
