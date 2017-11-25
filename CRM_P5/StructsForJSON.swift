//
//  StructsForJSON.swift
//  CRM_P5
//
//  Created by Juan Carlos Díaz Torres on 25/11/2017.
//  Copyright © 2017 Juan Carlos Díaz Torres. All rights reserved.
//

import Foundation

struct Salesman : Codable {
    let id: Int
    let login: String
    let fullname: String
    let isAdmin: Bool
    let isSalesman: Bool
    let phone1: String?
    let phone2: String?
    let email1: String?
    let email2: String?
    let notes: String?
    let PhotoId: Int?
    let Photo: Photo?
}

struct Photo: Codable {
    let id: Int
    let url: String
    let mime: String
}

struct Customer: Codable {
    let id: Int
    let name: String
    let cif: String
    let address1: String
    let address2: String
    let postalCode: String
    let phone1: String
    let email1: String
    let web: String
    
}

struct Visits: Codable {
    let plannedFor: String
    let CustomerId: Int
    let SalesmanId: Int
    let favourite: Bool
    let Customer: Customer
    let Salesman: Salesman
}

enum KindOfRequest {
    case AllVisits, MyVisits, MyFavVisits
    
}
