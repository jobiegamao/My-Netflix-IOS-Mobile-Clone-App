//
//  RemindMeButton.swift
//  netflixclone_swift
//
//  Created by may on 2/24/23.
//

import UIKit

class RemindMeButton: ButtonImageAndText {
	
	var filmModel: Film?

	init() {
		super.init(text:"Remind Me" , image: UIImage(systemName: "bell"))
		addTarget(self, action: #selector(remindAction), for: .touchUpInside)
	}
	
	@objc private func remindAction() {
		print("remind")
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
