//
//  HomeCollectionController.swift
//  ABCTest
//
//  Created by Anees Mv on 05/05/21.
//

import Foundation
import UIKit

protocol HeaderDelegate:class {
    func collectionView(didSelect image: String,index:Int)
}

class HomeCollectionController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControll: UIPageControl?
    @IBOutlet weak var searchBar: UISearchBar!
    
    weak var delegate: HeaderDelegate?
    var cardsList = ["abc","edf","ghi"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.reloadData()
        pageControll?.numberOfPages = cardsList.count
        pageControll?.isHidden = !(cardsList.count > 1)
    }
}

extension HomeCollectionController:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.cardsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = CollectionViewCell.identifier
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,
                                                     for: indexPath) as? CollectionViewCell
            else { return UICollectionViewCell() }
        
        let anImage = UIImage(named: self.cardsList[indexPath.item]) ?? UIImage()
        cell.imageView.image = anImage
        return cell
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            DispatchQueue.main.async {
                self.pageControll?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            }
        }
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            DispatchQueue.main.async {
                self.pageControll?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            }
        }
    }

}
