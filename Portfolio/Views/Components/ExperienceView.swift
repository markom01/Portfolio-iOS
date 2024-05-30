//
//  ExperiencesView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 15.3.24..
//

import SwiftUI

struct ExperienceView: View {
    let experience: Experience
    var isExpanded = false

    var body: some View {
        if isExpanded {
            List {
                header.listRowBackground(Color.clear)
                Section("About") { Text(experience.company.about) }
                Section("Technologies") {
                    SkillsView(technologies: experience.company.technologies)
                }
            }
            .scrollBounceBehavior(.basedOnSize)
#if os(macOS)
        .removeListBg()
#endif
        } else { header }
    }

    var header: some View {
        HeaderView(
            isExpanded: isExpanded,
            headingView: .init(Text(experience.company.rawValue.capitalized)),
            subHeadingView: .init(subHeading(experience)),
            imageSource: experience.company.logo
        )
    }

    func subHeading(_ experience: Experience) -> some View {
        HStack(spacing: .xSmall) {
            Text(experience.start.formatted(.dateTime.month().year()))
            Text("-")
            if Calendar.current.isDateInToday(experience.end) {
                Text("Present")
            } else {
                Text(experience.end.formatted(.dateTime.month().year()))
            }
        }
    }
}

#Preview {
    ExperienceView(experience: Constants.experiences[0])
}
