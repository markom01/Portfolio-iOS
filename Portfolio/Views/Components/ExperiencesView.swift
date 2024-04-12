//
//  ExperiencesView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 15.3.24..
//

import SwiftUI

struct ExperiencesView: View {
    let experiences: [Experience]
    @Binding var selectedExperienceId: UUID?

    var body: some View {
        ForEach(experiences) { experience in
            if selectedExperienceId == nil || selectedExperienceId == experience.id {
                VStack(spacing: .large) {
                    HeaderView(
                        isExpanded: selectedExperienceId == experience.id,
                        headingView: .init(Text(experience.company.rawValue.capitalized)),
                        subHeadingView: .init(subHeading(experience)),
                        imageSource: experience.company.logo
                    )
                    .onTapGesture { selectedExperienceId = experience.id }
                    if selectedExperienceId == experience.id {
                        SectionView(header: "About") { Text(experience.company.about) }
                        TechSectionView(technologies: experience.company.technologies)
//                        SectionView(header: "Projects") {}
                    }
                }
                .id(experience.id)
            }
        }
    }

    @ViewBuilder
    func subHeading(_ experience: Experience) -> some View {
        HStack(spacing: .xSmall) {
            Text(experience.start.formatted(.dateTime.month().year()))
            Text("-")
            if Calendar.current.isDateInToday(experience.end) { Text("Present") } else { Text(experience.end.formatted(.dateTime.month().year())) }
        }
    }
}

#Preview {
    ExperiencesView(experiences: Constants.experiences, selectedExperienceId: .constant(nil))
}
