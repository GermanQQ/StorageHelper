//
//  CreateProductView.swift
//  SwiftUIPractice
//
//  Created by Vadim German on 21.01.2023.
//

import SwiftUI
import UIKit
import FirebaseStorage

struct CreateProductView: View {
    
    let product: Product?
    let standId: String
    @Binding var isPopupCreateVisible: Bool
    @State var barcode: String
    @State private var name = ""
    @State private var description = ""
    @State private var stock = ""
    @State private var showAlert = false
    @State private var image: UIImage?
    @State private var isShowingCamera = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    
    //    init(barcode: String, standId: String, product: Product? = nil) {
    //        self.standId = standId
    //        self.barcode = barcode
    //        self.product = product
    //
    //        if(product != nil){
    //            name = product!.name
    //            description = product!.description
    //            stock = String(product!.stock)
    //            self.barcode = product!.barcode
    //        }
    //    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        HStack{
                            Text("Створити новий продукт")
                                .font(.title)
                                .padding(5)
                            Spacer()
                            Image(systemName: "bag").resizable().foregroundColor(.orange).frame(width: 25, height: 30)
                        }
                        
                        HStack {
                            Text("Назва:").frame(width: 75)
                            TextField("Введіть назву", text: $name)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(5).overlay(alignment: .trailing){
                                    Text("*").foregroundColor(Color.red).offset(x: -10, y: -5).font(.title3)
                                }
                        }
                        HStack {
                            Text("Опис:").frame(width: 75)
                            TextField("Введіть опис", text: $description)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(5)
                        }
                        HStack {
                            Text("Баркод:").frame(width: 75)
                            TextField("Введіть баркод", text: $barcode)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(5)
                                .disabled(true).overlay(alignment: .trailing){
                                    Text("*").foregroundColor(Color.red).offset(x: -10, y: -5).font(.title3)
                                }
                        }
                        HStack {
                            Text("Кількість:").frame(width: 75)
                            TextField("Введіть кількість", text: $stock)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .padding(5).overlay(alignment: .trailing){
                                    Text("*").foregroundColor(Color.red).offset(x: -10, y: -5).font(.title3)
                                }
                        }
                        HStack(alignment: .center, spacing: 5.0) {
                            if(image != nil){
                                Image(uiImage: image!).resizable()
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(8)
                            }else{
                                PlaceholderImage()
                            }
                            Spacer()
                            Button(action: {
                                self.sourceType = .camera
                                self.isShowingCamera = true
                                print("Камера")
                            }) {
                                Image(systemName: "camera")
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(5)
//                            Button(action: {
//                                self.sourceType = .photoLibrary
//                                self.isShowingCamera = true
//                                print("Галерея")
//                            }) {
//                                Image(systemName: "photo.on.rectangle.angled")
//                            }
//                            .padding()
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(5)
                        }
                        .sheet(isPresented: $isShowingCamera) {
                            ImagePicker(sourceType: self.$sourceType, image: self.$image)
                        }
                    }
                }
                HStack(spacing: 10) {
                    Button(action: {
                        isPopupCreateVisible = false
                        print("Відмінити")
                    }) {
                        Text("Відмінити")
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    Button(action: {
                        if self.name.isEmpty || self.stock.isEmpty {
                            self.showAlert = true
                        } else {
                            saveProduct()
                            isPopupCreateVisible = false
                        }
                        
                    }) {
                        Text("Зберегти")
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Error"), message: Text("Name and Stock are required fields"), dismissButton: .default(Text("OK")))
                    }
                }.padding(.horizontal, 20.0)
            }
        }
        
        //        func uploadToFirebase(){
        //
        //        }
    }
    
    fileprivate func saveProduct() {
        let imageData = image?.jpegData(compressionQuality: 0.5);
        let imagePath = imageData != nil ? "\(UUID().uuidString).jpg" : ""
        let product = self.product != nil ? product! : Product(name: name, description: description, image: imagePath, barcode: barcode, stock: Int( stock) ?? 0)
        FirebaseService.shared.createProduct(product: product, standId: standId, imageData: imageData)
        print("Product saved!")
    }
}

//struct CreateProductView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateProductView(product: nil, isPopupCreateVisible: )
//    }
//}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var sourceType: UIImagePickerController.SourceType
    @Binding var image: UIImage?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
