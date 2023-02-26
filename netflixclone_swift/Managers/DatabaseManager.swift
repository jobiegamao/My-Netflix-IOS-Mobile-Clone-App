//
//  DatabaseManager.swift
//  netflixclone_swift
//
//  Created by may on 2/26/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift
import Combine

class DatabaseManager {
	
	static let shared = DatabaseManager()
	
	let db = Firestore.firestore()
	let usersPath = "users" //collection of users == users table
	
	func collectionUsers(add newUser: User) -> AnyPublisher<Bool, Error> {
		let userAccount = UserAccount(from: newUser)
		
		return db.collection(usersPath).document(userAccount.id).setData(from: userAccount)
			.map{ _ in true }
			.eraseToAnyPublisher()
	}
	
	func collectionUsers(retreive id: String) -> AnyPublisher<UserAccount, Error>{
		db.collection(usersPath).document(id).getDocument()
			.tryMap{ try $0.data(as: UserAccount.self) }
			.eraseToAnyPublisher()
	}
	
	func collectionUsers(for id: String, update fields: [String: Any]) -> AnyPublisher<Bool, Error>{
		db.collection(usersPath).document(id).updateData(fields)
			.map { _ in true }
			.eraseToAnyPublisher()
	}
}
