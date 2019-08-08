//
//  GitHubService.swift
//  netword
//
//  Created by MrParker on 2019/8/8.
//  Copyright © 2019 MrParker. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import ObjectMapper

class GitHubService {
    //搜索资源数据
    func searchRepositories(Query: String) -> Driver<GitHubRepositories> {
        return GitHubProvider.rx.request(.repositories(Query))
            .filterSuccessfulStatusCodes()
            .mapObject(GitHubRepositories.self)
            .asDriver(onErrorDriveWith: Driver.empty())
    }
}
