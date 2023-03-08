//
//  Extensions.swift
//  netflixclone_swift
//
//  Created by may on 1/16/23.
//

import Foundation
import UIKit

extension String{
	
	func capitalizeFirstLetter() -> String {
		return self.prefix(1).capitalized + self.dropFirst().lowercased()
	}
	
}

extension UIImage {

	func withInset(_ insets: UIEdgeInsets) -> UIImage? {
		let cgSize = CGSize(width: self.size.width + insets.left * self.scale + insets.right * self.scale,
							height: self.size.height + insets.top * self.scale + insets.bottom * self.scale)

		UIGraphicsBeginImageContextWithOptions(cgSize, false, self.scale)
		defer { UIGraphicsEndImageContext() }

		let origin = CGPoint(x: insets.left * self.scale, y: insets.top * self.scale)
		self.draw(at: origin)

		return UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(self.renderingMode)
	}
	

}

extension UIViewController {
  func screen() -> UIScreen? {
	var parent = self.parent
	var lastParent = parent
	
	while parent != nil {
	  lastParent = parent
	  parent = parent!.parent
	}
	
	return lastParent?.view.window?.windowScene?.screen
  }
}

extension UIView {
	func removeAllSubviews() {
		subviews.forEach { $0.removeFromSuperview() }
	}
}

extension Notification.Name {
	static let didTapDownload = Notification.Name("didTapDownload")
	static let didSelectAProfile = Notification.Name("didSelectAProfile")
	static let didAddNewProfile = Notification.Name("didAddNewProfile")
}
