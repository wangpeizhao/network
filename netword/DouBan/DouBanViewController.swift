//
//  DouBanViewController.swift
//  netword
//
//  Created by MrParker on 2019/8/8.
//  Copyright © 2019 MrParker. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class DouBanViewController: UIViewController {
    
    //显示资源列表的tableView
    var tableView:UITableView!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Specs.color.white
        
        // set bar
        setNavBarTitle(view: self, title: "搜索")
        
        
        // set left btn
        setNavBarLeftBtn(view: self, title: "Close", selector: #selector(close))
        
        setUp()
        // Do any additional setup after loading the view.
    }
    
    @objc func close() {
        _close(view: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUp() {
        DouBanProvider.rx.request(.channels)
            .subscribe { event in
                switch event {
                case let .success(response):
                    let str = String(data: response.data, encoding: String.Encoding.utf8)
                    print("返回的数据是：", str ?? "")
                case let .error(error):
                    print("数据请求失败!错误原因：", error)
                }
        }.disposed(by: disposeBag)
        
        //创建表视图
        self.tableView = UITableView(frame:self.view.frame, style:.plain)
        //创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(self.tableView!)
        
        
        //初始化ViewModel
//        let viewModel = DouBanViewModel(searchAction: searchAction)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
