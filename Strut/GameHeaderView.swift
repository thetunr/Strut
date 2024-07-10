//
//  GroupHeaderView.swift
//  Strut
//
//  Created by Tony Oh on 7/8/24.
//

import SwiftUI

struct GameHeaderView: View {
    @State private var stepCount: Int = 98765
    
    private var formattedStepCount: String {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            return numberFormatter.string(from: NSNumber(value: stepCount)) ?? "\(stepCount)"
        }
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "carrot")
//                    .fixedSize(horizontal: false, vertical: true)
//                    .aspectRatio(contentMode: .fit)
                Spacer()
            }
            .frame(width:75)
            
            Spacer()
                .frame(height:5)
                .background(Color.blue)
            
            Text(formattedStepCount)
                .font(.system(size:35))
                .frame(width:150)
            
            Spacer()
                .frame(height:5)
                .background(Color.blue)
            
            HStack {
                Spacer()
                
                Button("", systemImage: "book.closed") {
                    // action
                }
                
                Button("", systemImage: "calendar") {
                    // action
                }
            }
            
            .frame(width:75)
            
        }
        .foregroundColor(Color.primary)
        .frame(height:25)
        .padding(15)
    }
}

#Preview {
    GameHeaderView()
}
