//
//  ViewController.swift
//  DemoApp
//
//  Created by Anees Mv on 05/05/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerViewForCollection: UIView!
    @IBOutlet weak var cardCollectionHeightConstraint: NSLayoutConstraint!

    var collectionContainerHeight:CGFloat = CGFloat(262)
    
    var tableDataSource:[String] = ["Apple","Orange","Mango","Grapes","Avocado","Cherry","Gauva","Papaya","Banana","Cherry","Gauva","Papaya","Banana"]
    var filteredDataSource:[String] = []
    var lastContentOffset: CGFloat = 0
    var homeCollectionController:HomeCollectionController?
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight  = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.contentInset = UIEdgeInsets.init(top: collectionContainerHeight, left: 0, bottom: 0, right: 0)
        tableView.register(UINib(nibName: "HeaderTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "HeaderTableViewCell")
    }
      
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let collectionController = segue.destination as? HomeCollectionController {
            collectionController.view.layoutSubviews()
            collectionController.delegate = self
            collectionController.searchBar.delegate = self
            collectionController.searchBar.searchTextField.delegate = self
            homeCollectionController = collectionController
        }
    }
    
    // MARK: - Private Method
    
    func isFiltering() -> Bool {
        return homeCollectionController?.searchBar.isFirstResponder ?? false && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return homeCollectionController?.searchBar.text?.isEmpty ?? true
    }
}

// MARK: - UITableViewDelegate,UITableViewDataSource Methods
extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering() ? filteredDataSource.count : tableDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let titleString = isFiltering() ? filteredDataSource[indexPath.row] : tableDataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier,
                                                 for: indexPath) as! HomeTableViewCell
        
        cell.titlelabel.text = titleString

        return cell
    }

    
    // MARK: - UIScrollViewDelegate Methods
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let y = collectionContainerHeight - (scrollView.contentOffset.y + collectionContainerHeight)
        let height = min(max(y, 40), collectionContainerHeight)
        cardCollectionHeightConstraint.constant = height
    }

}


    // MARK: - HeaderDelegate Method
extension HomeViewController:HeaderDelegate {
    func collectionView(didSelect image: String, index: Int) {
//        self.tableView.reloadData()
    }
}

    // MARK: - UISearchBarDelegate Method
extension HomeViewController:UISearchBarDelegate,UITextFieldDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredDataSource = self.tableDataSource.filter { (item) -> Bool in
            return item.lowercased().contains(searchText.lowercased())
        }
        
        self.tableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        homeCollectionController?.searchBar.resignFirstResponder()
        return true
    }
    
    
    
}


