//
//  ExperienceView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 15.3.24..
//

import SwiftUI

struct ExperienceView: View {
    let experience: Experience

    var body: some View {
        HStack {
            ImageView(source: .url(experience.company.imageURLString), size: 50)
            VStack(alignment: .leading) {
                HStack(spacing: 5) {
                    Text(experience.title)
                    Text("@")
                    Text(experience.company.rawValue)
                }.foregroundStyle(.primary)
                HStack(spacing: 5) {
                    Text(experience.start.formatted(.dateTime.month().year()))
                    Text("-")
                    Text(experience.end.formatted(.dateTime.month().year()))
                }
            }
        }
    }
}

#Preview {
    ExperienceView(experience: Constants.experience)
}
