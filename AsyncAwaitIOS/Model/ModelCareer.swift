//
//  ModelCareer.swift
//  AsyncAwaitIOS
//
//  Created by Rezaul Islam on 17/7/23.
//
import Foundation

// MARK: - CareerRespose
struct CareerRespose: Codable {
    var message: String
    var data: [Career]
}

// MARK: - Datum
struct Career: Codable, Identifiable{
    var id: Int
    var name: String
    var logo, url: String
}

struct CareerReq: Codable{
    var name, url: String
}
 
