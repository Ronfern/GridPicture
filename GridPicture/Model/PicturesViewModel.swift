//
//  PictureViewModel.swift
//  GridPicture
//
//  Created by Роман Чугай on 26.08.2020.
//  Copyright © 2020 Роман Чугай. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol  PhotoViewModelType: ViewModelType {
    var rows: PublishSubject<[PhotoModel]>  { get }
}

class PhotoViewModel: PhotoViewModelType {
    var rows: PublishSubject<[PhotoModel]> = PublishSubject()
    
    
    let dataSource: PhotoDataSource
    
    init(dataSource: PhotoDataSource) {
        self.dataSource = dataSource
    }
    
     func loadData(pageNumber: Int) {
        dataSource.fetchPhotos(pageNumber: pageNumber) { result in
            self.rows.onNext(result)
        }
    }
    

    func cleanRows() {
        rows.onCompleted()
    }
    
    func findData(pageNumber: Int, text: String) {
        dataSource.findPhotos(searchText: text, pageNumber: pageNumber) { result in
            self.rows.onNext(result)
        }
    }
    
    
}
