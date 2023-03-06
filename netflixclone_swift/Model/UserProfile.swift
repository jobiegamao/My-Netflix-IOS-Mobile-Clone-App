//
//  UserProfiles.swift
//  netflixclone_swift
//
//  Created by may on 2/27/23.
//

import Foundation

struct UserProfile: Codable {
	var id: String = UUID().uuidString
	let user: UserAccount
	let userID: String
	let userProfileName: String
	let userProfileIcon: String
}
