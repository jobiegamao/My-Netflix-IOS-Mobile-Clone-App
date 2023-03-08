//
//  ManageProfilesViewController.swift
//  netflixclone_swift
//
//  Created by may on 2/28/23.
//

import UIKit
import Combine

class ManageProfilesViewController: UIViewController {
	
	private var viewModel = ManageProfilesViewViewModel()
	private var subscriptions: Set<AnyCancellable> = []
	
	private var profileBtns = [ButtonImageAndText]()
	
	private let vcTitleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Manage Profiles"
		label.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
		label.sizeToFit()
		return label
	}()
	
	private lazy var doneButton: UIButton = {
		let button = UIButton(type: .system)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitle("Done", for: .normal)
		button.tintColor = .label
		button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
		return button
	}()
	
	private lazy var myProfilesView: UICollectionView = {
		let cellSpacing = 15.0
		
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		layout.minimumInteritemSpacing = cellSpacing
		layout.minimumLineSpacing = cellSpacing
		
		layout.itemSize = CGSize(width: 130, height: 130)

		// Create collection view
		let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
		cv.translatesAutoresizingMaskIntoConstraints = false
		cv.dataSource = self
		cv.delegate = self
		cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
		
//		cv.backgroundColor = .tertiaryLabel
		
		
		return cv
	}()
	
	private lazy var addProfileButton: UIButton = {
		let image = UIImage(systemName: "person.crop.circle.badge.plus")
		
		let btn = ButtonImageAndText(text: "Add Profile", image: image)
		btn.iconImageView.contentMode = .center
		btn.iconImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
		btn.iconImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
		btn.iconImageView.transform = btn.iconImageView.transform.scaledBy(x: 1.5, y: 1.5)
		btn.label.font = .systemFont(ofSize: 20, weight: .semibold)
		btn.label.frame.origin.y -= 10
		
		btn.translatesAutoresizingMaskIntoConstraints = false
		btn.heightAnchor.constraint(equalToConstant: 130).isActive = true
		btn.widthAnchor.constraint(equalToConstant: 130).isActive = true
		

		btn.addTarget(self, action: #selector(didTapAddProfileButton), for: .touchUpInside)
		
		return btn
	}()
	
	

	// MARK: - Main
    override func viewDidLoad() {
        super.viewDidLoad()
		title = vcTitleLabel.text
		view.backgroundColor = .systemBackground
		
		view.addSubview(vcTitleLabel)
		view.addSubview(doneButton)
		view.addSubview(myProfilesView)
		
		
		applyConstraints()
		bindViews()
		
		NotificationCenter.default.addObserver(forName: .didAddNewProfile, object: nil, queue: nil) { _ in
			self.viewModel.retrieveUser()
		}
	
    }
	

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		viewModel.retrieveUser()
		print("viewWillAppear")
	}
	
	
	
	
	
	// MARK: - Private Methods
	
	
	private func bindViews(){
		
		viewModel.$profiles.sink { [weak self] profileArrayResult in
			//empty everything first
			self?.profileBtns.removeAll()
			self?.myProfilesView.removeAllSubviews()
			
			self?.profileBtns = profileArrayResult.map { [weak self] userProfile in
				let btn = UserProfileButton(userProfile: userProfile)
				btn.addTarget(self, action: #selector(self?.didTapProfileButton(_:)), for: .touchUpInside)
				btn.heightAnchor.constraint(equalToConstant: 130).isActive = true
				btn.widthAnchor.constraint(equalToConstant: 130).isActive = true
				btn.label.font = .systemFont(ofSize: 20, weight: .semibold)
				btn.label.frame.origin.y -= 10
				
				return btn
			}
			
			DispatchQueue.main.async {
				self?.myProfilesView.reloadData()
			}
		}
		.store(in: &subscriptions)
	}
	
	
	@objc private func didTapDoneButton() {
		dismiss(animated: true, completion: nil)
	}
	
	@objc private func didTapProfileButton(_ sender: UserProfileButton){
		guard let userProfile = sender.userProfile  else { return  }
		
		print(userProfile.userProfileName)
		let vc = EditProfileViewController()
		present(vc, animated: true)
		
	}
	
	@objc private func didTapAddProfileButton(){
		print("add a profile")
		let vc = AddProfileViewController()
		present(vc, animated: true)
		
	}
	
	private func applyConstraints(){
		NSLayoutConstraint.activate([
			vcTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
			vcTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			vcTitleLabel.heightAnchor.constraint(equalToConstant: 50),
		
			doneButton.centerYAnchor.constraint(equalTo: vcTitleLabel.centerYAnchor),
			doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			
			myProfilesView.topAnchor.constraint(equalTo: vcTitleLabel.bottomAnchor, constant: 50),
			myProfilesView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
			myProfilesView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
			myProfilesView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
		])
	}



}

extension ManageProfilesViewController: UICollectionViewDataSource, UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		var numItems = 0
		if viewModel.profiles.count == 5  {
			numItems = 5
			addProfileButton.isHidden = true
		}else {
			numItems = viewModel.profiles.count + 1
		}
		
		return numItems
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
		
		if viewModel.profiles.count < 5 && indexPath.row == viewModel.profiles.count {
			cell.addSubview(addProfileButton)
			return cell
		}
		cell.addSubview(profileBtns[indexPath.row])

		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let vc = EditProfileViewController()
		present(vc, animated: true)
	}

}

