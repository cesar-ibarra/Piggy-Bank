//
//  ThanksView.swift
//  Piggy Bank
//
//  Created by Cesar Ibarra on 5/24/25.
//

import SwiftUI

struct ThanksView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 8) {
            
            Text("Thank You 💕")
                .font(.system(.title2, design: .rounded).bold())
                .multilineTextAlignment(.center)
            
            Text("Your support means a lot! Thank you for helping make this app better — I truly appreciate it.")
                .font(.system(.body, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(.bottom, 16)
            
        }
        .padding(16)
        .background(Color("card-background"), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        .padding(.horizontal, 8)
    }
}

#Preview {
    ThanksView()
}
