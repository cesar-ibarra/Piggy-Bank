//
//  TipsView.swift
//  Piggy Bank
//
//  Created by Cesar Ibarra on 5/24/25.
//

import SwiftUI

struct TipsView: View {
//    @Environment(\.dismiss) private var dismiss
    @StateObject var storeKit = StoreKitManager()
    @State var isPurchased: Bool = false
    
    var didTapClose: () -> ()
    
    var body: some View {
        if !isPurchased {
            VStack(spacing: 8) {
                HStack {
                    Spacer()
                    Button(action: didTapClose) {
                        Image(systemName: "xmark")
                            .symbolVariant(.circle.fill)
                            .font(.system(.largeTitle, design: .rounded).bold())
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.gray, .gray.opacity(0.2))
                    }
                }
                Text("Enjoying the app so far? 👀")
                    .font(.system(.title2, design: .rounded).bold())
                    .multilineTextAlignment(.center)
                
                Text("If you enjoy using the app, consider buying me a coffee to support future updates and improvements. Thank you!")
                    .font(.system(.body, design: .rounded))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 16)
                
                ForEach(storeKit.storeProducts) { product in
                    HStack {
                        
                        VStack(alignment: .leading,
                               spacing: 3) {
                            Text(product.displayName)
                                .font(.system(.title3, design: .rounded).bold())
                            Text(product.description)
                                .font(.system(.callout, design: .rounded).weight(.regular))
                        }
                        
                        Spacer()
                        
                        Button{
                            Task {
                                try await storeKit.purchase(product)
                            }
                        } label: {
                            PurchasedValidated(storeKit: storeKit, product: product)
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .font(.callout.bold())
                        .onChange(of: storeKit.purchasedCoffeeForMe) { oldValue, item in
                            Task {
                                isPurchased = (try? await storeKit.isPurchased(product)) ?? false
                            }
                        }
                    }
                    .padding(16)
                    .background(Color(UIColor.systemBackground),
                                in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
            }
            .padding(16)
            .background(Color("card-background"), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            .padding(8)
            .overlay(alignment: .top) {
                Image("logo")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .padding(6)
                    .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .offset(y: -25)
            }
        } else {
            ThanksView()
        }

    }
}

#Preview {
    TipsView{}
}
