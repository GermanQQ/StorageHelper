//
//  ProductCardView.swift
//  SwiftUIPractice
//
//  Created by Vadim German on 22.01.2023.
//

import SwiftUI

struct ProductCardView: View {
    let product: Product
    @State var image: UIImage? = nil
    @State private var isAnimated = true
    init(product: Product) {
        self.product = product
    }
    
    var body: some View {
        HStack {
            if product.image.isEmpty{
                PlaceholderImage()
            } else if(image == nil){
                ZStack{
                    PlaceholderImage()
                    ActivityIndicator(isAnimating: $isAnimated, style: .medium).frame(width: 80, height: 80)
                }
            } else {
                ProductImage(image: image!)
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
        }.onAppear{
            if(!product.image.isEmpty){
                FirebaseService.shared.getImageFromStorage(url: product.image) { data in
                    if let data = data {
                        image = UIImage(data: data)
                    } else {
                        print("Error get image for product \(product.id)")
                    }
                }
            }
        }
    }
}

struct ProductImage: View {
    @State var image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
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

