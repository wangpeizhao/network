//
//  GitHubViewController.swift
//  netword
//
//  Created by MrParker on 2019/8/6.
//  Copyright © 2019 MrParker. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GitHubViewController: UIViewController {
    //显示资源列表的tableView
    var tableView:UITableView!
    
    //搜索栏
    var searchBar:UISearchBar!
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func close() {
        _close(view: self)
    }
    
    func setUp() {
        //创建表视图
        self.tableView = UITableView(frame:self.view.frame, style:.plain)
        //创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(self.tableView!)
        
        //创建表头的搜索栏
        self.searchBar = UISearchBar(frame: CGRect(x: 0, y: 0,
                                                   width: self.view.bounds.size.width, height: 56))
        self.tableView.tableHeaderView =  self.searchBar
        
        //查询条件输入
        let searchAction = searchBar.rx.text.orEmpty.asDriver()
            .throttle(0.5) //只有间隔超过0.5k秒才发送
            .distinctUntilChanged()
        
        //初始化ViewModel
        let viewModel = GitHubViewModel(searchAction: searchAction)
        
        //绑定导航栏标题数据
        viewModel.navigationTitle.drive(self.navigationItem.rx.title).disposed(by: disposeBag)
        
        //将数据绑定到表格
        viewModel.repositories.drive(tableView.rx.items) { (tableView, row, element) in
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            cell.textLabel?.text = element.name
            cell.detailTextLabel?.text = element.htmlURL
            return cell
            }.disposed(by: disposeBag)
        
        //单元格点击
        tableView.rx.modelSelected(GitHubRepository.self)
            .subscribe(onNext: {[weak self] item in
                //显示资源信息（完整名称和描述信息）
//                print(item)
                self?.showAlert(title: item.fullName, message: item.description)
            }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            print(indexPath.row)
            self?.tableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)
        
        tableView.rx.itemAccessoryButtonTapped.subscribe(onNext: { [weak self] indexPath in
            print("indexPath: \(indexPath)")
        }).disposed(by: disposeBag)
    }
    
    //显示消息
    func showAlert(title:String, message:String){
        let alertController = UIAlertController(title: title,
                                                message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
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
