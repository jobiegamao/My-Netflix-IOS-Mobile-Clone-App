//
//  UserProfileButton.swift
//  netflixclone_swift
//
//  Created by may on 2/28/23.
//

import UIKit

class UserProfileButton: ButtonImageAndText {
	
	var userProfile: UserProfile?
	

	init(userProfile: UserProfile, imageSize: CGFloat = 60.0) {
		self.userProfile = userProfile
		let image = URL(string: userProfile.userProfileIcon)
		
		super.init(text: userProfile.userProfileName, image: nil)
		
		iconImageView.sd_setImage(with: image, placeholderImage: UIImage(systemName: "face.dashed.fill"), options: [.progressiveLoad])
		iconImageView.layer.cornerRadius = 10
		iconImageView.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
		iconImageView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
		
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
