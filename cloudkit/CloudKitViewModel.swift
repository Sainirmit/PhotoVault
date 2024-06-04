//
//  CloudKitViewModel.swift
//  cloudkit
//
//
//Created by DevifyUI on 04/06/24.



import Foundation
import CloudKit
import SwiftUI

class CloudKitViewModel: ObservableObject {
    @Published var photos: [PhotoRecord] = []
    private let container: CKContainer
    private let publicDB: CKDatabase

    init() {
        container = CKContainer(identifier: "iCloud.com.yourdomain.yourapp") // Use your container identifier
        publicDB = container.publicCloudDatabase
    }

    func fetchPhotos() {
        let query = CKQuery(recordType: "PhotoRecord", predicate: NSPredicate(value: true))
        publicDB.perform(query, inZoneWith: nil) { records, error in
            if let error = error {
                print("Error fetching records: \(error)")
                return
            }
            DispatchQueue.main.async {
                self.photos = records?.compactMap { record in
                    PhotoRecord(record: record)
                } ?? []
            }
        }
    }

    func addPhoto(photoRecord: PhotoRecord, image: UIImage) {
        let record = CKRecord(recordType: "PhotoRecord")
        record["name"] = photoRecord.name as CKRecordValue
        record["identifier"] = photoRecord.identifier as CKRecordValue
        record["age"] = photoRecord.age as CKRecordValue
        record["gender"] = photoRecord.gender as CKRecordValue
        record["imageName"] = photoRecord.imageName as CKRecordValue

        let url = saveToTemporaryLocation(image: image)
        let asset = CKAsset(fileURL: url)
        record["photo"] = asset

        publicDB.save(record) { record, error in
            if let error = error {
                print("Error saving record: \(error)")
                return
            }
            self.fetchPhotos()
        }
    }

    private func saveToTemporaryLocation(image: UIImage) -> URL {
        let data = image.jpegData(compressionQuality: 1.0)!
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".jpg")
        try! data.write(to: url)
        return url
    }
}

//#Preview {
//    CloudKitViewModel()
//}
