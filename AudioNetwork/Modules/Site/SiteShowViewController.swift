//
//  SiteShowViewController.swift
//  AudioNetwork
//
//  Created by Oleg on 04.06.2022.
//

import UIKit
import WebKit
import CoreData

class SiteShowViewController: UIViewController, StoryboardInstantiable {
    var transfer: Track?
    var transferFromCore : TasksCore?
    
    // MARK: - Properties
    @IBOutlet private weak var wkWeb: WKWebView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var addFavorite: UIBarButtonItem!
    
    // MARK: - Properties
    static var storyboardFileName: UIStoryboard.Storyboard { .siteShow }
    var coordinator: SiteShowCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showSite()
        createNavButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if transfer == nil {
            addFavorite.isEnabled = false
        } else {
            addFavorite.isEnabled = true
        }
    }
    
    @IBAction private func backButtonAction(_ sender: UIBarButtonItem) {
        if wkWeb.canGoBack {
            wkWeb.goBack()
        }
    }
    
    @IBAction private func foreardButtnAction(_ sender: UIBarButtonItem) {
        if wkWeb.canGoForward {
            wkWeb.goForward()
        }
    }
    
    @IBAction private func refreshAction(_ sender: UIBarButtonItem) {
        wkWeb.reload()
    }
    
    @IBAction private func addButtonAction(_ sender: UIBarButtonItem) {
        if transfer?.artistName != nil || transfer?.artistName != nil || transfer?.artworkUrl100 != nil {
            saveTask(name: transfer?.artistName ?? "", track: transfer?.trackName ?? "", image: transfer?.artworkUrl100 ?? "", trackUrl: transfer?.trackViewUrl ?? "", listenUrl: transfer?.previewUrl ?? "", kind: transfer?.kind ?? "", releaseDate: transfer?.releaseDate ?? "")
            let slideVC = AlertCustomView(text: "ADDED TO FAVORITE")
            slideVC.modalPresentationStyle = .custom
            slideVC.transitioningDelegate = self
            self.present(slideVC, animated: true, completion: nil)
        }
    }
}

extension SiteShowViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

private extension SiteShowViewController {
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
    
    func showSite() {
        if transfer?.trackViewUrl != nil || transfer?.previewUrl != nil {
            guard let myUrl = URL(string: transfer?.trackViewUrl ?? transfer?.previewUrl ?? "" ) else { return }
            let request = URLRequest(url: myUrl)
            wkWeb.load(request)
        } else if transferFromCore?.trackViewUrlCore != nil || transferFromCore?.previewUrlCore != nil {
            guard let myUrl = URL(string: transferFromCore?.trackViewUrlCore ?? transferFromCore?.previewUrlCore ?? "") else { return }
            let request = URLRequest(url: myUrl)
            wkWeb.load(request)
        } else {
            guard let myUrl = URL(string: "https://www.google.com.ua/?hl=ru" ) else { return }
            let request = URLRequest(url: myUrl)
            wkWeb.load(request)
        }
        spinner.stopAnimating()
    }
    
    func createNavButton() {
        guard let addImage = UIImage(systemName: "airpodsmax") else { return }
        let addButton = UIBarButtonItem(image: addImage,  style: .plain, target: self, action: #selector(justLIstenWatch(sender:)))
        addButton.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        addButton.tintColor = .black
        navigationItem.rightBarButtonItems = [addButton]
        
        let titleLabel = UILabel()
        titleLabel.text = "AppleSite"
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "Marker Felt Thin", size: 17)
        navigationItem.titleView = titleLabel
        
        let button =  UIButton(type: .custom)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(back(sender:)), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 20)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    @objc func back(sender: UIBarButtonItem) {
        coordinator?.popBack()
    }
    
    @objc func justLIstenWatch(sender: UIBarButtonItem) {
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
}
