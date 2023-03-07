//
//  ProfileViewViewModel.swift
//  netflixclone_swift
//
//  Created by may on 2/27/23.
//

import Foundation
import Combine
import FirebaseAuth

class ProfileViewViewModel: ObservableObject {
	
	@Published var user: UserAccount?
	@Published var profiles: [UserProfile] = []
	@Published var currentUserProfile: UserProfile?
	@Published var error: Error?
	
	var subscriptions: Set<AnyCancellable> = []
	
	
	func retrieveUser() {
		guard let id = Auth.auth().currentUser?.uid else {return}
		DatabaseManager.shared.collectionUsers(retrieve: id)
			.handleEvents(receiveOutput: { [weak self] userResult in
				self?.user = userResult
				self?.retrieveUserProfiles()
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
	
	func retrieveUserProfiles() {
		guard let userID = user?.id else { return }
		
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
	
	func retrieveCurrentUserProfile(profileID id: String){
		DatabaseManager.shared.collectionUsersProfiles(getProfile: id)
			.sink { [weak self] result in
				if case .failure(let error) = result {
					self?.error = error
				}
			} receiveValue: { [weak self] userProfileResult in
				self?.currentUserProfile = userProfileResult
			}
			.store(in: &subscriptions)

	}
	

	
	
}
