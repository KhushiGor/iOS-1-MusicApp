//
//  SongDetailsViewController.swift
//  iOS-1-MusicApp
//
//  Created by Khushi Mineshkumar Gor on 2024-12-09.
//

import UIKit

protocol AddingNewSongProtocol {
    func addingNewSongDone(songname: String)
    
}



class SongDetailsViewController: UIViewController, NetworkingDelegate{
    
    var delegate: AddingNewSongProtocol?
    
    
    @IBAction func saveSong(_ sender: Any) {
        
        if let goodsong = songNameLable.text {
            delegate?.addingNewSongDone(songname: goodsong)
            dismiss(animated: true)
        }
    }
    

    @IBOutlet weak var songIcon: UIImageView!
    
    
    @IBOutlet weak var songNameLable: UILabel!
    
    
    @IBOutlet weak var songArtistNameLable: UILabel!
    
    var selectedSong: String?
    
    var notificationName = (UIApplication.shared.delegate as! AppDelegate).notificationName
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let song = selectedSong {
                   self.songNameLable.text = song
                   self.songArtistNameLable.text = "Artist: \(song)"  // Update this if you have more specific song data
               }
        
        
    }
    func networkingDidFinishWithSongObj(so: SongInfo) {
        DispatchQueue.main.async {
            
            self.songNameLable.text = so.song[0].songname
            self.songArtistNameLable.text = "Artist: \(so.song[0].songname)"
            self.downloadImage(icon: so.song[0].songImage)
            
        }
    }
    
    @objc
    func updateUI(_ notification: Notification){
        
        var so = notification.userInfo?["songObj"] as! SongInfo
        DispatchQueue.main.async {
            self.songNameLable.text = so.song[0].songname
            self.songArtistNameLable.text = "Artist : \(so.song[0].songname)"
            self.downloadImage(icon:so.song[0].songImage)
        }
        
    }
    
    
    func networkingDidFinishWithListOfSongs(songs: [String]) {
        
    }
    
    
    
    
    
    
    func downloadImage(icon:String){
            var url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")!
           
            var myQ = DispatchQueue(label: "myQ")
        myQ.async {
            do{
                var imgData = try  Data(contentsOf: url)
                
                DispatchQueue.main.async {
                    self.songIcon.image = UIImage(data: imgData)
                    
                }
                
            }catch {
                print(error)
            }
        }
    }
    
    func networkingDidFail() {
        
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
