//
//  TwoStateButton.swift
//  VisionSampleProject
//
//  Created by James Rochabrun on 2/1/21.
//

import SwiftUI

struct TwoStateButton: View {
    
    private let text: String
    private let disabled: Bool
    private let background: Color
    private let action: () -> Void
    
    init(text: String,
         disabled: Bool,
         background: Color = .blue,
         action: @escaping () -> Void) {
        self.text = text
        self.disabled = disabled
        self.background = disabled ? .gray : background
        self.action = action
    }
    
    var body: some View {
        Button(action: action, label: {
            
            HStack {
                Spacer()
                Text(text)
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()
            .background(background)
            .cornerRadius(10)
        }).disabled(disabled)
    }
}
