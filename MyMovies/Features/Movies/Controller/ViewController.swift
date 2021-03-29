//
//  ViewController.swift
//  MyMovies
//
//  Created by Vitor Spessoto on 17/02/21.
//

import UIKit
import UserNotifications
import AVKit

class ViewController: UIViewController {
    
    //*************************************************
    // MARK: - Properties
    //*************************************************
    var movie: Movie?
    var alert: UIAlertController!
    var datePicker = UIDatePicker()
    var trailer = String()
    var moviePlayer: AVPlayer?
    var moviePlayerController: AVPlayerViewController?
    
    //*************************************************
    // MARK: - Outlets
    //*************************************************
    @IBOutlet weak var ivMovie: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbCategories: UILabel!
    @IBOutlet weak var lbDuration: UILabel!
    @IBOutlet weak var lbRating: UILabel!
    @IBOutlet weak var tvSummary: UITextView!
    @IBOutlet weak var btnPlay: UIButton!
    
    //*************************************************
    // MARK: - Lifecycle
    //*************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        if let title = movie?.title {
            loadTrailer(title: title)
        }
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(changeDate), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let movie = movie {
            ivMovie.image = movie.image as? UIImage
            lbTitle.text = movie.title
            lbCategories.text = movie.categories
            lbDuration.text = movie.duration
            lbRating.text = "⭐️\(movie.rating)/10"
            tvSummary.text = movie.summary
        }
    }
    
    //*************************************************
    // MARK: - IBActions
    //*************************************************
    @IBAction func scheduleNotification(_ sender: UIButton) {
        alert = UIAlertController(title: "Lembrete", message: "Quando deseja ser lembrado de assistir o filme?", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Data do lembrete"
            self.datePicker.date = Date()
            textField.inputView = self.datePicker
        })
        
        let okAction = UIAlertAction(title: "Agendar", style: .default) { (action) in
            self.schedule()
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func play(_ sender: UIButton) {
        guard let moviePlayerController = moviePlayerController else { return }
        present(moviePlayerController, animated: true) {
            self.moviePlayer?.play()
        }
    }
    
    //*************************************************
    // MARK: - Actions
    //*************************************************
    @objc func changeDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm'h"
        
        alert?.textFields?.first?.text = formatter.string(from: datePicker.date)
    }
    
    //*************************************************
    // MARK: - Navigation
    //*************************************************
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddEditViewController {
            vc.movie = movie
        }
    }
    
    //*************************************************
    // MARK: - Private methods
    //*************************************************
    private func loadTrailer(title: String) {
        API.loadTrailers(title: title) { (apiResult) in
            guard let results = apiResult?.results,
                  let trailer = results.first else { return }
            
            DispatchQueue.main.async {
                self.trailer = trailer.previewUrl
                self.prepareVideo()
            }
        }
    }
    
    private func schedule() {
        let content = UNMutableNotificationContent()
        let movieTitle = movie?.title ?? ""
        
        content.title = "Lembrete"
        content.body = "Assitir filme '\(movieTitle)'"
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: datePicker.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: "Lembrete", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    private func prepareVideo() {
        guard let url = URL(string: trailer) else { return }
        
        moviePlayer = AVPlayer(url: url)
        moviePlayerController = AVPlayerViewController()
        
        moviePlayerController?.player = moviePlayer
        moviePlayerController?.showsPlaybackControls = true
    }
}

