//
//  textfield.swift
//  from socialmedia_swift
//
//  Created by may on 2/7/23.
//

import UIKit
import PhotosUI

class CustomTextField: UITextField {
	
	private let accentColor = UIColor(named: "NetflixRed")
	
	var padding: CGFloat = 10.0
	var borderColor: CGColor = UIColor.systemGray4.cgColor
	var bcgColor: UIColor = .secondarySystemFill
	
	convenience init(placeholder: String, keyboardType: UIKeyboardType = .twitter ) {
		self.init()
		self.translatesAutoresizingMaskIntoConstraints = false
		self.backgroundColor = bcgColor
		self.layer.cornerRadius = 8.0
		self.layer.masksToBounds = true
		self.layer.borderWidth = 1.0
		self.layer.borderColor = borderColor
		
		
		//left padding in text
		self.leftView = UIView(
			frame: CGRect(x: 0.0, y: 0.0, width: padding, height: self.frame.height))
		self.leftViewMode = .always
		
		self.keyboardAppearance = .default
		self.keyboardType = keyboardType
		self.placeholder = placeholder
		
		self.heightAnchor.constraint(equalToConstant: 50).isActive = true
		
		self.delegate = self
	}
	
}

extension CustomTextField: UITextFieldDelegate {
	func textFieldDidBeginEditing(_ textField: UITextField) {
		self.layer.borderColor = accentColor?.cgColor
		// Add content offset on the parent scroll view if there is
		if let parent = self.superview as? UIScrollView {
			if let isPortrait = self.window?.windowScene?.interfaceOrientation.isPortrait{
				let offsetY: Double = isPortrait ? 200 : 25
				parent.setContentOffset(CGPoint(x: 0, y: self.frame.origin.y - offsetY), animated: true)
			}
		}
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		self.layer.borderColor = borderColor
		
		//return scrollview back
		if let parent = self.superview as? UIScrollView {
			parent.setContentOffset(
				CGPoint(x: 0, y: 0), animated: true)
		}
	}
}
