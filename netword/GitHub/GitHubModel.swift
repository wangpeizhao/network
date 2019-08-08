//
//  GitHubModel.swift
//  netword
//
//  Created by MrParker on 2019/8/6.
//  Copyright © 2019 MrParker. All rights reserved.
//

import Foundation
import ObjectMapper

//包含查询返回的所有库模型
struct GitHubRepositories: Mappable {
    
    var totalCount: Int!
    var incompleteResults: Bool!
    var items: [GitHubRepository]!//本次查询返回的所有仓库集合
    
    init() {
        print("Init()")
        self.totalCount = 0
        self.incompleteResults = false
        self.items = []
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.totalCount <- map["total_count"]
        self.incompleteResults <- map["incomplete_results"]
        self.items <- map["items"]
    }
}

//单个仓库模型
struct GitHubRepository: Mappable {
    var id: Int!
    var name: String!
    var fullName: String!
    var htmlURL: String!
    var description: String!
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.id <- map["id"]
        self.name <- map["name"]
        self.fullName <- map["full_name"]
        self.htmlURL <- map["html_url"]
        self.description <- map["description"]
    }
    
}
