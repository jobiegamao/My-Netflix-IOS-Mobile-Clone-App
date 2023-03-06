//
//  StorageManager.swift
//  netflixclone_swift
//
//  Created by may on 3/2/23.
//

import Foundation
import Combine
import FirebaseStorageCombineSwift
import FirebaseStorage

enum FireStorageError: Error {
	case invalidImageID
}

final class StorageManager{
	static let shared = StorageManager()
	
	let storage = Storage.storage()
	
	// method returns a download URL for a given image ID,
	func getDownloadURL(for id: String?) -> AnyPublisher<URL, Error>{
		guard let id = id else {
			return Fail(error: FireStorageError.invalidImageID)
				.eraseToAnyPublisher()
			}
		
		return storage
			.reference(withPath: id)
			.downloadURL()
			.eraseToAnyPublisher()
			
	}
	
	// method uploads an image with given metadata and a random ID to Firebase Storage.
	func uploadProfilePhoto(with randomID: String, image: Data, metadata: StorageMetadata) -> AnyPublisher<StorageMetadata, Error> {
		storage
			.reference()
			.child("images/\(randomID).jpg")
			.putData(image, metadata: metadata)
			.print()
			.eraseToAnyPublisher()
	}
}
