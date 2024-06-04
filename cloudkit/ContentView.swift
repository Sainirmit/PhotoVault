//
//  CloudKitViewModel.swift
//  cloudkit
//
//
//Created by DevifyUI on 04/06/24.

import SwiftUI
import CloudKit

struct ContentView: View {
    @StateObject private var viewModel = CloudKitViewModel()
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.photos) { photoRecord in
                        VStack {
                            if let fileURL = photoRecord.photoAsset?.fileURL,
                               let data = try? Data(contentsOf: fileURL),
                               let image = UIImage(data: data) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                            } else {
                                Text("Failed to load image")
                            }
                            Text(photoRecord.name)
                            Text(photoRecord.identifier)
                            Text("\(photoRecord.age) \(photoRecord.gender)")
                        }
                        .padding()
                        .background(Color(UIColor.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 2)
                    }
                }
                .padding()
            }
            .navigationTitle("Photo Vault")
            .navigationBarItems(trailing: HStack {
                Button(action: {
                    showImagePicker = true
                }) {
                    Text("Update Backup")
                }
                Button(action: {
                    viewModel.fetchPhotos()
                }) {
                    Text("Recover Backup")
                }
            })
            .sheet(isPresented: $showImagePicker, onDismiss: {
                if let selectedImage = selectedImage {
                    let newPhotoRecord = PhotoRecord(id: CKRecord.ID(), name: "New Photo", identifier: UUID().uuidString, age: "N/A", gender: "N/A", imageName: "newPhoto")
                    viewModel.addPhoto(photoRecord: newPhotoRecord, image: selectedImage)
                }
            }) {
                ImagePicker(image: $selectedImage)
            }
        }
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//#Preview {
//    ContentView()
//}
