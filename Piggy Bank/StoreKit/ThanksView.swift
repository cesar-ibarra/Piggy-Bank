//
//  ThanksView.swift
//  Piggy Bank
//
//  Created by Cesar Ibarra on 5/24/25.
//

import SwiftUI

struct ThanksView: View {

    var body: some View {
        VStack(spacing: 8) {
            Text("Thank You 💕")
                .font(.headline)
                .multilineTextAlignment(.center)

            Text("Your support means a lot! Thank you for helping make this app better — I truly appreciate it.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(16)
        .frame(width: 280)
    }
}

#Preview {
    ThanksView()
}
