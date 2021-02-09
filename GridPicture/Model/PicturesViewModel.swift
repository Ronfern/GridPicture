//
//  PictureViewModel.swift
//  GridPicture
//
//  Created by Роман Чугай on 26.08.2020.
//  Copyright © 2020 Роман Чугай. All rights reserved.
//

import Foundation

//
//protocol ViewModelDelegate: class {
//    func didLoadData()
//}
//
//protocol ViewModelType {
//    func loadData(pageNumber: Int)
//    func findData(pageNumber: Int, text: String)
//    func cleanRows()
//    var delegate: ViewModelDelegate? { get set }
//}
//
//
//protocol  PhotoViewModelType: ViewModelType {
//    var rows: [PhotoModel]  { get }
//}
//
//class PhotoViewModel: PhotoViewModelType {
//    
//    weak var delegate: ViewModelDelegate?
//    var rows: [PhotoModel]  = []
//    let dataSource: PhotoDataSource
//    
//    init(dataSource: PhotoDataSource) {
//        self.dataSource = dataSource
//    }
//    
//     func loadData(pageNumber: Int) {
//        dataSource.fetchPhotos(pageNumber: pageNumber) {[weak self] result in
//            DispatchQueue.main.async {
//                guard let ws = self else { return }
//                ws.rows.append(contentsOf: result)
//                ws.delegate?.didLoadData()
//            }
//        }
//    }
//    
//    func cleanRows() {
//        rows = []
//    }
//    
//    func findData(pageNumber: Int, text: String) {
//        dataSource.findPhotos(searchText: text, pageNumber: pageNumber) {[weak self] result in
//            DispatchQueue.main.async {
//                guard let ws = self else { return }
//                ws.rows.append(contentsOf: result)
//                ws.delegate?.didLoadData()
//            }
//        }
//    }
//    
//}
