//
//  AddEditViewController.swift
//  MyMovies
//
//  Created by Vitor Spessoto on 22/02/21.
//

import UIKit

class AddEditViewController: UIViewController {
    
    //*************************************************
    // MARK: - Properties
    //*************************************************
    var movie: Movie?
    
    //*************************************************
    // MARK: - IBOutlets
    //*************************************************
    @IBOutlet weak var ivMovie: UIImageView!
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfCategories: UITextField!
    @IBOutlet weak var tfDuration: UITextField!
    @IBOutlet weak var tfRating: UITextField!
    @IBOutlet weak var tvSummary: UITextView!
    @IBOutlet weak var btnAddEdit: UIButton!
    
    //*************************************************
    // MARK: - Lifecycle
    //*************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let movie = self.movie {
            ivMovie.image = movie.image as? UIImage
            tfTitle.text = movie.title
            tfCategories.text = movie.categories
            tfDuration.text = movie.duration
            tfRating.text = "⭐️\(movie.rating)/10"
            tvSummary.text = movie.summary
            btnAddEdit.setTitle("Alterar", for: .normal)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //*************************************************
    // MARK: - IBActions
    //*************************************************
    @IBAction func addPoster(_ sender: UIButton) {
        let alert = UIAlertController(title: "Adicionar pôster", message: "De onde deseja escolher o pôster?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera Action", style: .default) { (action) in
                self.selectPicture(source: .camera)
            }
            alert.addAction(cameraAction)
        }
        let libraryAction = UIAlertAction(title: "Biblioteca de Fotos", style: .default) { (action) in
            self.selectPicture(source: .savedPhotosAlbum)
        }
        let photosAction = UIAlertAction(title: "Álbum de Fotos", style: .default) { (action) in
            self.selectPicture(source: .photoLibrary)
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alert.addAction(libraryAction)
        alert.addAction(photosAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addEditMovie(_ sender: UIButton) {
        if movie == nil {
            movie = Movie(context: context)
        }
        
        movie?.image = ivMovie.image
        movie?.title = tfTitle.text
        movie?.categories = tfCategories.text
        movie?.duration = tfDuration.text
        movie?.rating = Double(tfRating.text!) ?? 0
        movie?.summary = tvSummary.text
        
        do {
            try context.save()
            navigationController?.popViewController(animated: true)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //*************************************************
    // MARK: - Private methods
    //*************************************************
    private func selectPicture(source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
}

//*************************************************
// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
//*************************************************
extension AddEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            let aspecRatio = image.size.width / image.size.height
            var smallSize: CGSize
          
            if aspecRatio > 1 {
                smallSize = CGSize(width: 800, height: 800/aspecRatio)
            } else {
                smallSize = CGSize(width: 800*aspecRatio, height: 800)
            }
            UIGraphicsBeginImageContext(smallSize)
            image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
            
            let smallImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            ivMovie.image = smallImage
            dismiss(animated: true, completion: nil)
        }
    }
}
