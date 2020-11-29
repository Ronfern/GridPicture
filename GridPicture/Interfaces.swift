//
//  File.swift
//  GridPicture
//
//  Created by Роман Чугай on 27.08.2020.
//  Copyright © 2020 Роман Чугай. All rights reserved.
//



protocol ViewModelType {
    func loadData(pageNumber: Int)
    func findData(pageNumber: Int, text: String)
    func cleanRows()
}
