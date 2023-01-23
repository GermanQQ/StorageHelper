//
//  ProductCardView.swift
//  SwiftUIPractice
//
//  Created by Vadim German on 22.01.2023.
//

import SwiftUI

struct ProductCardView: View {
    let product: Product
    init(product: Product) {
        self.product = product
    }
    
    var body: some View {
        HStack {
            if product.image.isEmpty{
                PlaceholderImage()
            } else {
                ProductImage()
            }
            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.headline)
                Text(product.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 4.0)
                HStack {
                    Text("Баркод: \(product.barcode)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                    Text("Кількість: \(product.stock)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

struct ProductImage: View {
    var body: some View {
        Image(systemName: "cart")
            .resizable()
            .frame(width: 80, height: 80)
            .cornerRadius(8)
    }
}

struct PlaceholderImage: View {
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .foregroundColor(.gray.opacity(0.3))
                .frame(width: 80, height: 80)
                .cornerRadius(8)
            Image(systemName: "photo")
                .resizable()
                .foregroundColor(.gray)
                .frame(width: 50, height: 50)
                .aspectRatio(contentMode: .fit)
        }
    }
}

