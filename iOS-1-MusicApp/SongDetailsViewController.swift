//
//  SongDetailsViewController.swift
//  iOS-1-MusicApp
//
//  Created by Khushi Mineshkumar Gor on 2024-12-10.
//

import UIKit

class SongDetailsViewController: UIViewController {

    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    @IBOutlet weak var songNameLabel: UILabel!
    
    @IBOutlet weak var artistNameLabel: UILabel!
    
    var song: Song?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if let song = song {
                   songNameLabel.text = song.name
                   artistNameLabel.text = song.artist
                   
                   // Load the thumbnail image asynchronously
                   if let url = URL(string: song.thumbnailURL) {
                       DispatchQueue.global().async {
                           if let data = try? Data(contentsOf: url) {
                               DispatchQueue.main.async {
                                   self.thumbnailImageView.image = UIImage(data: data)
                               }
                           }
                       }
                   }
               }
    }
    
    @IBAction func saveButtonClicked(_ sender: UIBarButtonItem) {
        
        guard let song = song else { return }
                
                // Save the song to Core Data
                CoreDataManager.shared.saveSongs(songs: [song])
                
                // Optionally, show a confirmation message or alert
                let alert = UIAlertController(title: "Saved", message: "The song has been saved to your library!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
