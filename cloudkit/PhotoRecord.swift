//
//  CloudKitViewModel.swift
//  cloudkit
//
//
//Created by DevifyUI on 04/06/24.

import CloudKit

struct PhotoRecord: Identifiable {
    var id: CKRecord.ID
    var name: String
    var identifier: String
    var age: String
    var gender: String
    var imageName: String
    var photoAsset: CKAsset?

    init(record: CKRecord) {
        self.id = record.recordID
        self.name = record["name"] as? String ?? ""
        self.identifier = record["identifier"] as? String ?? ""
        self.age = record["age"] as? String ?? ""
        self.gender = record["gender"] as? String ?? ""
        self.imageName = record["imageName"] as? String ?? ""
        self.photoAsset = record["photo"] as? CKAsset
    }

    init(id: CKRecord.ID, name: String, identifier: String, age: String, gender: String, imageName: String) {
        self.id = id
        self.name = name
        self.identifier = identifier
        self.age = age
        self.gender = gender
        self.imageName = imageName
        self.photoAsset = nil
    }
}





