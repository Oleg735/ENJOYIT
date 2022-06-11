//
//  FindTableViewCell.swift
//  AudioNetwork
//
//  Created by OlegPrushlyak on 06.06.2022.
//

import UIKit

class FindTableViewCell: UITableViewCell {
    @IBOutlet private weak var imageV: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var trackLabel: UILabel!
    @IBOutlet private weak var kindLabel: UILabel!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    
    func setImage(urlName: String){
        guard let imageUrl = URL(string: urlName) else { return }
        guard let data = try? Data(contentsOf: imageUrl) else { return }
        let image = UIImage(data: data)
        
        imageV.image = image
    }
    
    func setStr(labelStr: String) -> String{
        let string = labelStr
        if string.count >= 7 {
            let firstCharIndex = string.index(string.startIndex, offsetBy: 7)
            let firstChar = string.substring(to: firstCharIndex)
            return firstChar
        }
        return string
    }
    
    func configure( _ model: Track) {
        titleLabel.text = model.artistName
        trackLabel.text = model.trackName
        kindLabel.text = model.kind
        if let artUrl = model.artworkUrl100 {
            setImage(urlName: artUrl)
        }
        if let release = model.releaseDate {
            releaseDateLabel.text = setStr(labelStr: release)
        }
    }
    
    func configureFromDataBase( _ tasks: TasksCore) {
        titleLabel.text = tasks.artistNameCore
        trackLabel.text = tasks.trackNameCore
        kindLabel.text = tasks.kindCore
        if let artUrl = tasks.artworkUrl100Core {
            setImage(urlName: artUrl)
        }
        if let release = tasks.releaseDateCore {
            releaseDateLabel.text = setStr(labelStr: release)
        }
    }
}
