//
//  AuthViewModel.swift
//  netflixclone_swift
//
//  Created by may on 2/26/23.
//

import Foundation
import Firebase
import Combine

final class AuthViewModel: ObservableObject {
	
	@Published var email: String?
	@Published var password: String?
	@Published var isAuthenticationValid: Bool = false
	@Published var user: User? // from Auth Library
	@Published var error: Error?
	
	private var subscriptions: Set<AnyCancellable> = []
	
	func validateForm(){
		guard let email = email, let password = password else { return }
		isAuthenticationValid = isValidEmail(email) && isValidPassword(password: password)
		
	}
	
	func isValidEmail(_ email: String) -> Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

		let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return emailPred.evaluate(with: email)
	}
	
	func isValidPassword(password: String) -> Bool {
		guard password.count > 5
		else{return false}
		
		return true
	}
	
	func createUser(){
		guard let email = email, let password = password else { return }
		AuthManager.shared.registerUser(with: email, password: password)
			.handleEvents(receiveOutput: { [weak self] user in
				self?.user = user
			})
			.sink { [weak self] result in
				if case .failure(let error) = result {
					self?.error = error
				}
			} receiveValue: { [weak self] user in
				self?.saveUserInDB(for: user)
				print("user saved in database!")
			}
			.store(in: &subscriptions)
	}
	
	func saveUserInDB(for user: User){
		DatabaseManager.shared.collectionUsers(add: user)
			.sink { [weak self] result in
				if case .failure(let error) = result {
					self?.error = error
				}
			} receiveValue: {[weak self] bool in
				print("Adding user in db: \(bool)")
				self?.createFirstProfile(for: user)
			}
			.store(in: &subscriptions)
		
		

	}
	
	func loginUser(){
		guard let email = email, let password = password else { return }
		AuthManager.shared.loginUser(with: email, password: password)
			.sink { [weak self] result in //error
				if case .failure(let error) = result {
					self?.error = error
				}
			} receiveValue: { [weak self] user in //
				self?.user = user
			}
			.store(in: &subscriptions)
	}
	
	func createFirstProfile(for user: User){
		let userAccount = UserAccount(from: user)
		let firstProfileName = "Me"
		let profile = UserProfile(user: userAccount, userID: userAccount.id, userProfileName: firstProfileName, userProfileIcon: "profileicon")
		
		DatabaseManager.shared.collectionUsersProfiles(add: profile)
			.sink { [weak self] result in
				if case .failure(let error) = result {
					self?.error = error
				}
			} receiveValue: { userProfileResult in
				AppSettings.selectedProfile = userProfileResult
				UserDefaults.standard.set(userProfileResult.id, forKey: AppSettings.selectedProfileIDForKey)
			}
			.store(in: &subscriptions)
	}
	
}


/*
 
 final -> prevents the class from being inherited
 ObservableObject -> A type of object with a publisher that emits before the object has changed so that when important changes happen the view will reload.
 @Published -> @Published property wrapper is added to any properties inside an observed object that should cause views to update when they change.
 
 necessary structure of it
 .sink{}
 .receive{}
 .store()
 
 .handleEvents(receiveOutput:) is there to access the return value of the func above
 

 // when ERROR
	 .sink { [weak self] result in
		 if case .failure(let error) = result {
			 self?.error = error
		 }
	 }
 
 // when SUCCESS
	// get the output given
	 .handleEvents(receiveOutput: { [weak self] user in
		 self?.user = user
	 })
 
	// call function in success closure
	 receiveValue: { [weak self] user in //
		 self?.saveUserInDB
	 }
 
 
 */
