//
//  AddProfileViewViewModel.swift
//  netflixclone_swift
//
//  Created by may on 3/1/23.
//


import Foundation
import Combine
import FirebaseAuth
import FirebaseStorage
import UIKit

final class AddProfileViewViewModel: ProfileViewViewModel {
	
	@Published var avatarPath: String?
	@Published var imageData: UIImage?
	@Published var displayName: String?
	@Published var isFormValid: Bool = false
	
	@Published var isDone: Bool = false
	
	
	func validateForm(){
		guard displayName != nil else { return }
		isFormValid = true
		
	}
	
	func uploadAvatar(){
		let randomID = UUID().uuidString
		guard let imageData = imageData?.jpegData(compressionQuality: 0.5) else { return }
		let metadata = StorageMetadata()
		metadata.contentType = "image/jpeg"
		
		StorageManager.shared.uploadProfilePhoto(with: randomID, image: imageData, metadata: metadata)
			.flatMap({ metadata in
				StorageManager.shared.getDownloadURL(for: metadata.path)
			})
			.sink { [weak self] result in
				switch result{
					case .failure(let error):
						self?.error = error
						
					case .finished:
						self?.createProfile() //create profile after upload image
				}
			} receiveValue: { [weak self] url in
				self?.avatarPath = url.absoluteString
			}
			.store(in: &subscriptions)

	}
	
	func createProfile(){
		guard let currentUser = super.user,
				let displayName,
				let avatarPath else {return}
		
		print("createProfile success")

		let profile = UserProfile(user: currentUser, userID: currentUser.id, userProfileName: displayName, userProfileIcon: avatarPath)
		
		DatabaseManager.shared.collectionUserProfiles(add: profile)
			.sink { [weak self] result in
				if case .failure(let error) = result {
					self?.error = error
				}
			} receiveValue: { [weak self] userProfileResult in
				self?.isDone = true
			}
			.store(in: &subscriptions)
	}
	
	
}
