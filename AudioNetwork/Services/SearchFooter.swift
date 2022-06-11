//
//  SearchFooter.swift
//  AudioNetwork
//
//  Created by OlegPrushlyak on 31.07.2021.
//

import UIKit

class SearchFooter: UIView {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    
    override func draw(_ rect: CGRect) {
        label.frame = bounds
    }
    
    private func configureView() {
        backgroundColor = .gray
        alpha = 0
        
        label.textAlignment = .center
        label.textColor = .white
        addSubview(label)
    }
    
    private func hideFooter() {
        alpha = 0
    }
    
    private func showFooter() {
        alpha = 1
    }
}

// MARK: Public API
extension SearchFooter {
    func setNotFiltering() {
        label.text = ""
        hideFooter()
    }
    
    func setIsFilteringToShow(filteredItemCount: Int, of totalItemCount: Int) {
        
        switch filteredItemCount {
        case totalItemCount: setNotFiltering()
        case 0:
            label.text = "No item match your query"
            showFooter()
        default:
            label.text = "Filtering \(filteredItemCount) of \(totalItemCount)"
            showFooter()
        }
    }
}


