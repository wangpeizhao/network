//
//  DouBanModel.swift
//  netword
//
//  Created by MrParker on 2019/8/8.
//  Copyright © 2019 MrParker. All rights reserved.
//  http://www.hangge.com/blog/cache/detail_1797.html

import Foundation
import ObjectMapper

struct DouBanRepositories: Mappable {
    
    var name: String!
    var seq_id: Int!
    var channel_id: Int!
    var items: [DouBanRepository]!//本次查询返回的所有仓库集合
    
    init?(map: Map) {
        self.items = []
    }
    
    mutating func mapping(map: Map) {
        self.name <- map["name"]
        self.seq_id <- map["seq_id"]
        self.channel_id <- map["channel_id"]
    }
}

//单个仓库模型
struct DouBanRepository: Mappable {
    var song: String!
    var artist: String!
    var title: String!
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.song <- map["song"]
        self.artist <- map["artist"]
        self.title <- map["title"]
    }
    
}
