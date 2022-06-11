//
//  SiteShowViewController.swift
//  AudioNetwork
//
//  Created by Oleg on 04.06.2022.
//

import UIKit

class SiteShowViewController: UIViewController, StoryboardInstantiable{
    
    // MARK: - Properties
    static var storyboardFileName: UIStoryboard.Storyboard { .some }
    var coordinator: SomeCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

}


import UIKit
import WebKit
import CoreData

class ShowViewController: UIViewController {
    var transfer: Track?
    var transferFromCore : TasksCore?
    
    @IBOutlet weak var wkWeb: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if transfer?.trackViewUrl != nil || transfer?.previewUrl != nil {
            let myUrl = URL(string: transfer?.trackViewUrl ?? transfer?.previewUrl ?? "" )
            let request = URLRequest(url: myUrl!)
            wkWeb.load(request)
        } else if transferFromCore?.trackViewUrlCore != nil || transferFromCore?.previewUrlCore != nil {
            let myUrl = URL(string: transferFromCore?.trackViewUrlCore ?? transferFromCore?.previewUrlCore ?? "")
            let request = URLRequest(url: myUrl!)
            wkWeb.load(request)
        } else {
            let myUrl = URL(string: "https://www.google.com.ua/?hl=ru" )
            let request = URLRequest(url: myUrl!)
            wkWeb.load(request)
        }
    }
    
    @IBAction func JustLIstenWatch(_ sender: Any) {
        if transfer?.previewUrl != nil {
            let myUrl = URL(string: transfer?.previewUrl ?? "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/ed/c5/88/edc588aa-8d51-269a-999c-7a4093f78322/mzaf_17496324978451793251.plus.aac.p.m4a" )
            let request = URLRequest(url: myUrl!)
            wkWeb.load(request)
        } else if transferFromCore?.previewUrlCore != nil {
            let myUrl = URL(string: transferFromCore?.previewUrlCore ?? "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/ed/c5/88/edc588aa-8d51-269a-999c-7a4093f78322/mzaf_17496324978451793251.plus.aac.p.m4a" )
            let request = URLRequest(url: myUrl!)
            wkWeb.load(request)
        }
    }
    
    @IBAction func backButAction(_ sender: Any) {
        if wkWeb.canGoBack {
            wkWeb.goBack()
        }
    }
    
    @IBAction func forwardButAction(_ sender: Any) {
        if wkWeb.canGoForward {
            wkWeb.goForward()
        }
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        wkWeb.reload()
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        if transfer?.artistName != nil || transfer?.artistName != nil || transfer?.artworkUrl100 != nil{
            saveTask(name: transfer?.artistName ?? "", track: transfer?.trackName ?? "", image: transfer?.artworkUrl100 ?? "", trackUrl: transfer?.trackViewUrl ?? "", listenUrl: transfer?.previewUrl ?? "", kind: transfer?.kind ?? "", releaseDate: transfer?.releaseDate ?? "")
        }
    }
    
    func saveTask( name: String, track: String, image: String, trackUrl: String, listenUrl: String, kind: String, releaseDate: String) {
        let appDeleg = UIApplication.shared.delegate as! AppDelegate
        let context = appDeleg.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "TasksCore", in: context) else { return }
        
        let taskObject = TasksCore(entity: entity, insertInto: context)
        taskObject.artistNameCore = name
        taskObject.trackNameCore = track
        taskObject.artworkUrl100Core = image
        taskObject.trackViewUrlCore = trackUrl
        taskObject.previewUrlCore = listenUrl
        taskObject.kindCore = kind
        taskObject.releaseDateCore = releaseDate
        
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
