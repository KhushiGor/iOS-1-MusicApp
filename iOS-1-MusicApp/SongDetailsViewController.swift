//
//  SongDetailsViewController.swift
//  iOS-1-MusicApp
//
//  Created by Khushi Mineshkumar Gor on 2024-12-09.
//

import UIKit

class SongDetailsViewController: UIViewController, NetworkingDelegate{
    func networkingDidFinishWithSongObj(so: SongInfo) {
        DispatchQueue.main.async {
            
            self.songNameLable.text = so.songname
            self.songArtistNameLable.text = "Artist: \(so.songname)"
            self.downloadImage(icon:so.songImage)
            
        }
    }
    
    
    

    @IBOutlet weak var songIcon: UIImageView!
    
    
    @IBOutlet weak var songNameLable: UILabel!
    
    
    @IBOutlet weak var songArtistNameLable: UILabel!
    
    var selectedSong: String = ""
    
    var notificationName = (UIApplication.shared.delegate as! AppDelegate).notificationName
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var selectedSong: String = ""
        
        var notificationName = (UIApplication.shared.delegate as! AppDelegate).notificationName
        
        
    }
    
    @objc
    func updateUI(_ notification: Notification){
        
        var so = notification.userInfo!["songObj"] as! SongInfo
        DispatchQueue.main.async {
            self.songNameLable.text = so.songname
            self.songArtistNameLable.text = "Artist : \(so.songname)"
            self.downloadImage(icon:so.songImage)
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
