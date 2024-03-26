//
//  ExperiencesView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 15.3.24..
//

import SwiftUI

struct ExperiencesView: View {
    let experiences: [Experience]
    @State var isExpanded = false

    var body: some View {
        ForEach(experiences) {
            HeaderView(
                isExpanded: isExpanded,
                headingView: .init(Text($0.company.rawValue.capitalized)),
                subHeadingView: .init(subHeading($0)),
                imageSource: .url($0.company.imageURLString)
            )
            .onTapGesture { isExpanded.toggle() }
        }
        .animation(.smooth, value: isExpanded)
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
    ExperiencesView(experiences: Constants.experiences)
}
