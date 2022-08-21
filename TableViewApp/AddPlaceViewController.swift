//
//  AddPlaceViewController.swift
//  TableViewApp
//
//  Created by Борис Седых on 18.08.2022.
//

import UIKit
import PhotosUI

class AddPlaceViewController: UITableViewController {
    
    @IBOutlet weak var placeImage: UIImageView!
    
    override func viewDidLoad() {
        tableView.sectionHeaderTopPadding = 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
                self.choosePhoto(from: .camera)
            }
            let photoLibraryAction = UIAlertAction(title: "Photo", style: .default) { _ in
                self.choosePhoto(from: .photoLibrary)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            
            actionSheet.addAction(cameraAction)
            actionSheet.addAction(photoLibraryAction)
            actionSheet.addAction(cancelAction)
            
            present(actionSheet, animated: true)
            
        } else {
            view.endEditing(true)
        }
    }
}

// MARK: Text field delegate
extension AddPlaceViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

// MARK: Choosing photo
extension AddPlaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    enum PhotoSource {
        case camera
        case photoLibrary
    }
    
    func choosePhoto(from source: PhotoSource) {
        switch source {
        case .camera:
            let imagePicker = UIImagePickerController()
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                imagePicker.delegate = self
                present(imagePicker, animated: true)
            }
            
        case .photoLibrary:
            var pickerConfiguration = PHPickerConfiguration(photoLibrary: .shared())
            pickerConfiguration.filter = .images
            let imagePicker = PHPickerViewController(configuration: pickerConfiguration)
            imagePicker.delegate = self
            present(imagePicker, animated: true)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        placeImage.image = image
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)

        guard let result = results.first else {
            return
        }
        
        let itemProvider = result.itemProvider
        guard itemProvider.canLoadObject(ofClass: UIImage.self) else {
            print("Can't load object of type UIImage")
            return
        }
                
        itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    self.placeImage.image = image as? UIImage
                }
            }
        }
    }
}
