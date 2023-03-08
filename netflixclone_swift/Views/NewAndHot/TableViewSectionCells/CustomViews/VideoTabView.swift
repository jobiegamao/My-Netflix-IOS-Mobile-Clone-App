//
//  videoTabView.swift
//  netflixclone_swift
//
//  Created by may on 2/22/23.
//
import UIKit


class VideoTabView: UIView {
	
	
	//when film exists, only then it will show the buttons that needs the film data
	var buttons: [UIButton] = []{
		didSet {
			configureVideoTabView()
		}
	}
	
	private let logoImageView: UIImageView = {
		let liv = UIImageView()
		liv.translatesAutoresizingMaskIntoConstraints = false
		liv.contentMode = .scaleAspectFill
		liv.clipsToBounds = true
		return liv
	}()
	
	private lazy var stack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: buttons)
		stack.spacing = 40
		stack.alignment = .trailing
		stack.translatesAutoresizingMaskIntoConstraints = false
		
		return stack
	}()
	
	
	// MARK: init()
	override init(frame: CGRect = .zero) {
		super.init(frame: frame)
		translatesAutoresizingMaskIntoConstraints = false
	}
	
	private func configureVideoTabView(){
		
		addSubview(logoImageView)
		addSubview(stack)
		
		NSLayoutConstraint.activate([
			logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
			logoImageView.topAnchor.constraint(equalTo: topAnchor),
			logoImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
			logoImageView.trailingAnchor.constraint(lessThanOrEqualTo: stack.leadingAnchor),
			
			stack.topAnchor.constraint(equalTo: topAnchor),
			stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
			stack.bottomAnchor.constraint(equalTo: bottomAnchor),
			
		])
	}
	
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
