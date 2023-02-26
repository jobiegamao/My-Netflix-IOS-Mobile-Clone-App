//
//  OnboardingViewController.swift
//  netflixclone_swift
//
//  Created by may on 2/26/23.
//

import UIKit

class OnboardingViewController: UIViewController {
	
	private let logoImageView: UIImageView = {
		let iv = UIImageView()
		let urlString = "https://image.tmdb.org/t/p/w500/wwemzKWzjKYJFfCeiB57q3r4Bcm.png"
		if let url = URL(string: urlString) {
			iv.sd_setImage(with: url)
		}
		iv.clipsToBounds = true
		iv.contentMode = .scaleAspectFit
		iv.translatesAutoresizingMaskIntoConstraints = false
		
		return iv
	}()
	
	private lazy var signupBtn: BoxButton = {
		let btn = BoxButton(title: "Sign Up")
		btn.isEnabled = true
		btn.isHidden = true
		
		btn.addTarget(self, action: #selector(didTapSignup), for: .touchUpInside)
		return btn
	}()

	private lazy var loginBtn: BoxButton = {
		let btn = BoxButton(title: "Login", filled: false)
		btn.isEnabled = true
		btn.isHidden = true
		
		btn.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
		return btn
	}()
	
	@objc private func didTapSignup(){
		print("signup")
		let vc = SignUpViewController()
		navigationController?.pushViewController(vc, animated: true)
	}
	
	@objc private func didTapLogin(){
		print("login")
		let vc = LoginViewController()
		navigationController?.pushViewController(vc, animated: true)
	}
	
	private func applyConstraints(){
		NSLayoutConstraint.activate([
			logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			logoImageView.topAnchor.constraint(lessThanOrEqualTo: view.topAnchor, constant: 250),
			logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			logoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			
			signupBtn.topAnchor.constraint(lessThanOrEqualTo: logoImageView.bottomAnchor, constant: 250),
			signupBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			signupBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			signupBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20), 
			
			
			loginBtn.topAnchor.constraint(lessThanOrEqualTo: signupBtn.bottomAnchor, constant: 20),
			loginBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			loginBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			loginBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

		])
	}
	
	private func presentViewAnimation(){
		UIView.animate(withDuration: 1.5, delay: 0.5, animations: { [weak self] in
			self?.logoImageView.frame.origin.y -= 50
		}) { [weak self] _ in
			// Show the button after the animation completes
			self?.signupBtn.isHidden = false
			self?.loginBtn.isHidden = false
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .systemBackground
		view.addSubview(logoImageView)
		view.addSubview(signupBtn)
		view.addSubview(loginBtn)
		
		applyConstraints()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		presentViewAnimation()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		logoImageView.frame.origin.y += 50
	}
	
    

 

}
