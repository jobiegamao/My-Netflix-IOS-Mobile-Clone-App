//
//  ProfileButton.swift
//  netflixclone_swift
//
//  Created by may on 2/27/23.
//

import UIKit

protocol ProfileButtonDelegate: AnyObject {
	func didTapProfileButton()
}

class ProfileButton: UIButton {
	
	weak var delegate: ProfileButtonDelegate?
	


	override init(frame: CGRect = .zero) {
		super.init(frame: frame)

		layer.cornerRadius = 10
		clipsToBounds = true
		
		translatesAutoresizingMaskIntoConstraints = false
		widthAnchor.constraint(equalToConstant: 35).isActive = true
		heightAnchor.constraint(equalToConstant: 35).isActive = true
		
		addTarget(self, action: #selector(profileAction), for: .touchUpInside)
		
	}
	
	@objc private func profileAction() {
		print("profile")
		delegate?.didTapProfileButton()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
