//
//  ImageViewController.swift
//  AlbumImage
//
//  Created by Arthur Sobrosa on 02/12/24.
//

import UIKit

class ImageViewController: UIViewController {
    // MARK: - UI Properties
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "person.fill")
        imageView.layer.borderColor = UIColor.label.cgColor
        imageView.layer.borderWidth = 2
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        return imagePicker
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        navigationItem.title = "Image Edition"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageView.layer.cornerRadius = imageView.bounds.width / 2
    }
    
    // MARK: - Methods
    
    private func presentImageActionSheet() {
        let alertController = UIAlertController(title: "Select image", message: "Choose a new image", preferredStyle: .actionSheet)
        
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { [weak self] _ in
            guard let self else { return }
            
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                print("Photo library not available")
                return
            }
            
            imagePicker.sourceType = .photoLibrary
            
            present(imagePicker, animated: true)
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            guard let self else { return }
            
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                print("Camera not available")
                return
            }
            
            imagePicker.sourceType = .camera
            
            present(imagePicker, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(libraryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    @objc
    private func imageTapped() {
        presentImageActionSheet()
    }
}

// MARK: - UI Setup

extension ImageViewController {
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

// MARK: Image Picker Delegate

extension ImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let selectedImage = info[.originalImage] as? UIImage? {
            imageView.image = selectedImage
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
