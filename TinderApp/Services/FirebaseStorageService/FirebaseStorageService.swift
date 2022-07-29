//
//  FirebaseStorageService.swift
//  TinderApp
//
//  Created by Timofey on 28/7/22.
//

import FirebaseStorage
import FirebaseAuth


class FirebaseStorageService {
  
  static let shared = FirebaseStorageService()
  
  private var storageRef = Storage.storage().reference()
  
  private var avatarsRef: StorageReference {
    storageRef.child("avatars")
  }
  
  private var currentUserId: String {
    return Auth.auth().currentUser!.uid
  }
  
  func uploadImage(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
    
    guard let scaledImage = image.scaledToSafeUploadSize,
          let imageData = scaledImage.jpegData(compressionQuality: 0.4)
    else { return }
    
    let metaData = StorageMetadata()
    metaData.contentType = "image/jpeg"
    
    avatarsRef
      .child(currentUserId)
      .putData(
        imageData,
        metadata: metaData
      ) { storageMetadata, error in
        guard storageMetadata != nil else {
          completion(.failure(error!))
          return
        }
        
        self.avatarsRef.child(self.currentUserId).downloadURL { url, error in
          guard let downloadUrl = url else {
            completion(.failure(error!))
            return
          }
          completion(.success(downloadUrl))
        }
        
      }
    
  }
}

