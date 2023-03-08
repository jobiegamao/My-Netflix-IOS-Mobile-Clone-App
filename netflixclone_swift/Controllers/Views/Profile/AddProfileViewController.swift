//
//  AddProfileViewController.swift
//  netflixclone_swift
//
//  Created by may on 2/28/23.
//

import UIKit
import Combine
import PhotosUI

class AddProfileViewController: UIViewController {

	private var viewModel = AddProfileViewViewModel()
	private var subscriptions: Set<AnyCancellable> = []
	
	private var profiles = [UserProfile]()
	
	private let scrollView: UIScrollView = {
		let view = UIScrollView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.alwaysBounceVertical = true //important!
		view.keyboardDismissMode = .onDrag
		
		return view
	}()
	
	private let textLabel: UILabel = {
		
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Fill in your data"
		label.font = .systemFont(ofSize: 32, weight: .bold)
		label.textColor = .label
		
		return label
	}()
	
	private lazy var avatarPlaceholderImageView: UIImageView = {
		let imageView = UIImageView(frame: .zero)
		imageView.image = UIImage(systemName: "camera.fill")
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.layer.cornerRadius = 10
		imageView.clipsToBounds = true
		imageView.layer.masksToBounds = true
		imageView.backgroundColor = .secondarySystemFill
		imageView.tintColor = .gray
		imageView.isUserInteractionEnabled = true

		imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapUpload)))
		
		return imageView
	}()
	
	private let displaynameTextfield: CustomTextField = {
		let field = CustomTextField(placeholder: "Name")
		return field
	}()
	
	private lazy var submitBtn: BoxButton = {
		let btn = BoxButton(title: "Submit", height: 50.0, filled: true)
		btn.addTarget(self, action: #selector(didTapSubmitBtn), for: .touchUpInside)
		return btn
	}()
	
	// MARK: - Main
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .systemBackground
		view.addSubview(scrollView)
		scrollView.addSubview(textLabel)
		scrollView.addSubview(avatarPlaceholderImageView)
		scrollView.addSubview(displaynameTextfield)
		scrollView.addSubview(submitBtn)
		
		bindViews()
		configureConstraints()
    }
    
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		viewModel.retrieveUser()
	}

   // MARK: - Private Methods

	
	private func bindViews(){
		displaynameTextfield.addTarget(self, action: #selector(didUpdateDisplayname), for: .editingChanged)
		
		viewModel.$isFormValid.sink { [weak self] isFormValid in
			self?.submitBtn.isEnabled = isFormValid
		}
		.store(in: &subscriptions)
		
		viewModel.$isDone.sink { [weak self] boolResult in
			if boolResult {
				self?.dismiss(animated: true){
					NotificationCenter.default.post(name: .didAddNewProfile, object: nil)
				}
			}
		}
		.store(in: &subscriptions)

	}
	
	
	@objc private func didTapUpload(){
		var config = PHPickerConfiguration()
		config.filter = .images //pick only photos
		config.selectionLimit = 1
		
		let picker = PHPickerViewController(configuration: config)
		picker.delegate = self
		present(picker, animated: true)
	}
	
	@objc private func didTapSubmitBtn(){
		viewModel.uploadAvatar()
	}
	
	@objc private func didUpdateDisplayname(){
		viewModel.displayName = displaynameTextfield.text
		viewModel.validateForm()
	}
	
	private func configureConstraints(){
		
		let fieldSpacing = 20.0
		let margin = 30.0
		NSLayoutConstraint.activate([
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			scrollView.topAnchor.constraint(equalTo: view.topAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
												  
			textLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
			textLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30),
			
			avatarPlaceholderImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
			avatarPlaceholderImageView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 10),
			avatarPlaceholderImageView.widthAnchor.constraint(equalToConstant: 100),
			avatarPlaceholderImageView.heightAnchor.constraint(equalToConstant: 100),
			
			displaynameTextfield.topAnchor.constraint(equalTo: avatarPlaceholderImageView.bottomAnchor, constant: fieldSpacing + 10),
			displaynameTextfield.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: margin),
			displaynameTextfield.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -margin),
			
			submitBtn.leftAnchor.constraint(equalTo: displaynameTextfield.leftAnchor),
			submitBtn.rightAnchor.constraint(equalTo: displaynameTextfield.rightAnchor),
			submitBtn.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -fieldSpacing)
		])
	}
}


extension AddProfileViewController: PHPickerViewControllerDelegate {
	func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
		DispatchQueue.main.async{
			picker.dismiss(animated: true)
		}
		
		for result in results {
			result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
				if let image = object as? UIImage {
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
						self?.avatarPlaceholderImageView.image = image
						self?.avatarPlaceholderImageView.contentMode = .scaleAspectFill
						self?.viewModel.imageData = image
						self?.viewModel.validateForm()
					}
				}
			}
		}
				
		
	}
}
