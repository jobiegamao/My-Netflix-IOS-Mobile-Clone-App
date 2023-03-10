//
//  UserAccount.swift
//  netflixclone_swift
//
//  Created by may on 2/26/23.
//

import Foundation
import Firebase

struct UserAccount: Codable {
	let id: String
	var createdOn: Date = Date()
	var isUserSubscribed: Bool = true
	var expirationDate: Date?
	
	//auto id from User Firebase
	init(from user: User) {
		self.id = user.uid
	}
}
