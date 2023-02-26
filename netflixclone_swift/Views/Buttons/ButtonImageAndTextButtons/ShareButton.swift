//
//  ShareButton.swift
//  netflixclone_swift
//
//  Created by may on 2/22/23.
//

import UIKit

class ShareButton: ButtonImageAndText {
	
	var filmModel: Film?

	init() {
		super.init(text:"Share" ,image: UIImage(systemName: "paperplane.fill"))
		addTarget(self, action: #selector(shareAction(_:)), for: .touchUpInside)
	}
	
	@objc private func shareAction(_ sender: UIButton) {
		print("share")
		guard let poster_path = filmModel?.poster_path else { return }
		let imageURL = posterBaseURL + poster_path
		
		let shareSheetVC = UIActivityViewController(activityItems: [imageURL], applicationActivities: nil)
		
		//for ipadpopover sharemenu
		shareSheetVC.popoverPresentationController?.sourceView = sender
		shareSheetVC.popoverPresentationController?.sourceRect = sender.frame
		
		// Get a reference to the view controller that contains the videoTabView using the superview property
		let viewController = GlobalMethods.shared.getNearestViewController(of: self)

		// Present the share sheet on the view controller
		if let viewController = viewController {
		   viewController.present(shareSheetVC, animated: true, completion: nil)
		}
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	

}
