//
//  SwitchView.swift
//  Portfolio
//
//  Created by Marko Meseldzija on 3.2.24..
//

import SwiftUI
import SwiftUIIntrospect

struct SwitchView: View {
    @Binding var isOn: Bool
    
    var body: some View {
        Toggle("", isOn: $isOn)
        .toggleStyle(.switch)
        .labelsHidden()
#if os(iOS)
        .tint(.black.opacity(0.2))
        .introspect(.toggle, on: .iOS(.v17), customize: setBackgroundImage)
#endif
    }
    
    #if os(iOS)
    func setBackgroundImage(_ uiSwitch: UISwitch) {
        let backgroundLayer = uiSwitch.layer.sublayers?[0].sublayers?[0]
        uiSwitch.layer.cornerRadius = backgroundLayer?.cornerRadius ?? 15.5
        uiSwitch.layer.masksToBounds = true
        uiSwitch.layer.contents = UIImage(resource: .switchBg).cgImage
    }
    #endif
}

#Preview(traits: .sizeThatFitsLayout) {
   DemoSwitchView()
}

struct DemoSwitchView: View {
    @State var isOn = false

    var body: some View {
        SwitchView(isOn: $isOn)
    }
}
