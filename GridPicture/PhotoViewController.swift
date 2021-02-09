//
//  ViewController.swift
//  GridPicture
//
//  Created by Роман Чугай on 26.08.2020.
//  Copyright © 2020 Роман Чугай. All rights reserved.
//

import UIKit
import Nuke

class PhotoViewController: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionGrid: UICollectionView! {
        didSet {
            collectionGrid.delegate = self
            collectionGrid.dataSource = self
            collectionGrid.register(UINib(nibName: String(describing: PhotoProductCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: PhotoProductCell.self))
        }
    }
    
    private var model: PhotoViewModelType! = PhotoViewModel(dataSource: PhotoDataSource())
    private var pageCount = 0
    private var load = true
    private var type: TypeCollection = .listPhotos {
        didSet {
            cleanRows()
        }
    }
    
    enum TypeCollection {
        case listPhotos
        case findPhotos
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
        pagination()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

}
extension PhotoViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            type = .listPhotos
        }
        if searchBar.text!.count > 3, load  == true  {
            type = .findPhotos
        }
        
        if  model.rows.count >= 300 {
            cleanRows()
            return
        }
        pagination()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() 
    }
}
    

extension PhotoViewController: ViewModelDelegate {
    
    func didLoadData() {
        self.load = true
        DispatchQueue.main.async {
            self.collectionGrid.reloadData()
        }
    }
    
}
    
private extension PhotoViewController {
    
    func cleanRows() {
        model.cleanRows()
        pageCount = 0
        DispatchQueue.main.async {
            self.collectionGrid.reloadData()
        }
    }
    
    func pagination() {
        load = false
        pageCount += 1
        if type == .listPhotos {
            model.loadData(pageNumber: pageCount)
        } else {
            model.findData(pageNumber: pageCount, text: searchBar.text!)
        }
    }
}

extension PhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
 
 func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return model.rows.count
 }
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotoProductCell.self), for: indexPath) as! PhotoProductCell
        if let pictureModel = model.rows.getElement(at: indexPath.row), let urls =  pictureModel.urls {
            let url = type == .listPhotos ? urls.small : urls.regular
            cell.setPictureToCell(pictureToCell: url)
            return cell
        }
        
        return UICollectionViewCell()
    }
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let pictureModel = model.rows.getElement(at: indexPath.row), let urls =  pictureModel.urls {
          if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detail") as? DetailViewController {
            viewController.photoModel = urls.full
                if let navigator = navigationController {
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == model.rows.count - 1 && model.rows.count < 300 && load {
            if  type == .listPhotos {
                pagination()
            } else if searchBar.text!.count > 2 {
                pagination()
            }
        }
    }
}


extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
       
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       return UIEdgeInsets.init(top: 0, left: 10, bottom: 15, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch type {
        case .listPhotos:
            return CGSize.init(width: collectionView.frame.size.width / 4, height: collectionView.frame.size.height / 12)
        case .findPhotos:
            return CGSize.init(width: collectionView.frame.size.width / 1.1, height: collectionView.frame.size.height)
        }
        
    }
}
