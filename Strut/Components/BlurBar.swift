//
//  BlurBar.swift
//  Strut
//
//  Created by Tony Oh on 7/13/24.
//

import SwiftUI

struct BlurBar: View {
    let topColor: Color
    let bottomColor: Color
    let height: CGFloat

    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [topColor, bottomColor]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(height: height)
    }
}
