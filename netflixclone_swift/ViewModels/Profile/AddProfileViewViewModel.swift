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

final class AddProfileViewViewModel: ObservableObject {
	
	@Published var user: UserAccount?
	@Published var profiles: [UserProfile] = []
	
	@Published var avatarPath: String?
	@Published var imageData: UIImage?
	
	@Published var displayName: String?
	@Published var isFormValid: Bool = false
	
	@Published var isDone: Bool = false
	@Published var error: Error?
	
	private var subscriptions: Set<AnyCancellable> = []
	
	func retreiveUser() {
		guard let id = Auth.auth().currentUser?.uid else {return}
		DatabaseManager.shared.collectionUsers(retreive: id)
			.handleEvents(receiveOutput: { [weak self] userResult in
				self?.user = userResult
				self?.retreiveUserProfiles()
			})
			.sink { [weak self] completion in
				if case .failure(let error) = completion {
					self?.error = error
				}
			} receiveValue: { [weak self] userResult in
				self?.user = userResult
			}
			.store(in: &subscriptions)

	}
	
	func retreiveUserProfiles() {
		guard let userID = user?.id else { return }
		print(userID)
		DatabaseManager.shared.collectionUsersProfiles(getProfilesOf: userID)
			.sink { [weak self] result in
				if case .failure(let error) = result {
					self?.error = error
				}
			} receiveValue: { [weak self] profileArrayResult in
				self?.profiles = profileArrayResult
			}
			.store(in: &subscriptions)

	}
	
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
		guard let currentUser = self.user,
				let displayName,
				let avatarPath else {
			print("createProfile null items")
			return
			
		}
		
		print("createProfile")

		let profile = UserProfile(user: currentUser, userID: currentUser.id, userProfileName: displayName, userProfileIcon: avatarPath)
		
		DatabaseManager.shared.collectionUserProfiles(add: profile)
			.sink { [weak self] result in
				if case .failure(let error) = result {
					self?.error = error
				}
			} receiveValue: { [weak self] userProfileResult in
				print("new user added: ",userProfileResult)
				self?.isDone = true
			}
			.store(in: &subscriptions)
	}
	
	
}
