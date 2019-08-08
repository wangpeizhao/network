//
//  ViewController.swift
//  netword
//
//  Created by MrParker on 2019/8/3.
//  Copyright © 2019 MrParker. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ViewController: UIViewController {
    
    var tableView: UITableView!
    var textfield: UITextField!
    var password: UITextField!
    var label: UILabel!
    var button: UIButton!
    var uiSwitch: UISwitch!
    var githubButton: UIButton!
//    var activity = UIActivityIndicatorView!
    
    let MusicList = MusicListViewModel()
    //负责对象销毁
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Specs.color.white
        
        // set bar
        setNavBarTitle(view: self, title: "Home")
        
        // set back btn
        let selector: Selector = #selector(actionBack)
        setNavBarBackBtn(view: self, title: "Home", selector: selector)
        
        self._set_up()
        self._bind_tableview()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func actionBack() {
        self.hidesBottomBarWhenPushed = false
        print("ViewController actionBack ")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func actionClick()->Void {
//        _back(view: self)
        print("click...")
        _open(view: self, vc: DouBanViewController())
    }
    
    func _set_up() {
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/2 - 60), style: .grouped)
//        self.tableview.delegate = self
//        self.tableview.dataSource = self
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CELL_IDENTIFY_ID")
        self.tableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0 ))
        self.view.addSubview(self.tableView)
        
        self.textfield = UITextField()
        self.view.addSubview(self.textfield)
        self.textfield.borderStyle = .roundedRect
        self.textfield.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.tableView)
            make.top.equalTo(self.tableView.snp.bottom).offset(20)
            make.width.equalTo(self.view.frame.width/2)
        }
        
        self.password = UITextField()
        self.view.addSubview(self.password)
        self.password.borderStyle = .roundedRect
        self.password.keyboardType = UIKeyboardType.asciiCapable
        self.password.isSecureTextEntry = true
        self.password.returnKeyType = UIReturnKeyType.done
        self.password.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.textfield)
            make.top.equalTo(self.textfield.snp.bottom).offset(20)
            make.width.equalTo(self.view.frame.width/2)
        }
        
        self.label = UILabel()
        self.view.addSubview(self.label)
        self.label.text = "I am Label."
        self.label.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.password)
            make.top.equalTo(self.password.snp.bottom).offset(20)
        }
        
        self.button = UIButton(type: .system)
//        self.button.isEnabled = false
        self.button.setTitle("Submit", for: .normal)
        self.button.setTitleColor(UIColor.gray, for: .disabled)
        self.button.setTitleColor(UIColor.blue, for: .normal)
        self.view.addSubview(self.button)
        self.button.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.label)
            make.top.equalTo(self.label.snp.bottom).offset(20)
        }
        self.button.addTarget(self, action: #selector(actionClick), for: .touchUpInside)
        
        let activity = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        self.view.addSubview(activity)
        activity.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.button)
            make.top.equalTo(self.button.snp.bottom).offset(20)
            make.width.height.equalTo(40)
        }
        
        self.uiSwitch = UISwitch()
        self.view.addSubview(self.uiSwitch)
        self.uiSwitch.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(activity)
            make.top.equalTo(activity.snp.bottom).offset(20)
        }
        
        self.uiSwitch.rx.isOn.bind(to: UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
        .disposed(by: disposeBag)
        
        self.githubButton = UIButton()
        self.githubButton.setTitle("GitHub", for: .normal)
        self.githubButton.setTitleColor(UIColor.blue, for: .normal)
        self.view.addSubview(self.githubButton)
        self.githubButton.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.uiSwitch)
            make.top.equalTo(self.uiSwitch.snp.bottom).offset(20)
        }
        
        self.githubButton.rx.tap
            .bind { [weak self] in
                print("_open to GitHubViewController")
            _open(view: self!, vc: GitHubViewController())
        }
        .disposed(by: disposeBag)
        
        
        
        
        
//        //当文本框内容改变
//        let input = self.textfield.rx.text.orEmpty.asDriver() // 将普通序列转换为 Driver
//            .throttle(0.3) //在主线程中操作，0.3秒内值若多次改变，取最后一次
//
//        //内容绑定到另一个输入框中
//        input.drive(self.label.rx.text)
//            .disposed(by: disposeBag)
//
//        //内容绑定到文本标签中
//        input.map{ "当前字数：\($0.count)" }
//            .drive(self.label.rx.text)
//            .disposed(by: disposeBag)
//
//        //根据内容字数决定按钮是否可用
//        input.map{ $0.count > 5 }
//            .drive(self.button.rx.isEnabled)
//            .disposed(by: disposeBag)
        
        
        self.textfield.rx.controlEvent(.editingDidBegin).asObservable()
            .subscribe(onNext: { _ in
                print("Start")
            }).disposed(by: disposeBag)
        
//
//        let input = self.textfield.rx.text.orEmpty.asDriver()
//            .throttle(0.3)
//        input.drive(self.label.rx.text)
//            .disposed(by: disposeBag)
//        input.map({$0.count > 5})
//            .drive(self.button.rx.isEnabled)
//            .disposed(by: disposeBag)
        
        let _input = self.textfield.rx.text.orEmpty
        
        //观察者
        let observer: Binder<String> = Binder(label) { (view, text) in
            //收到发出的索引数后显示到label上
            self.label.text = "当前字数：\(text.count)"
            print(text)
            print(text.count)
            if (text.count >= 5) {
                let index = self.textfield.text!.index(self.textfield!.text!.startIndex, offsetBy:5)
                
                self.textfield.text = String(text[..<index]) //text.substring(to: index)
            }
            if (text.count >= 5) {
                self.button.isEnabled = true
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                activity.stopAnimating()
//                self.textfield.resignFirstResponder()
//                self.password.becomeFirstResponder()
            } else {
                self.button.isEnabled = false
                activity.startAnimating()
            }
        }
        
        _input.map { $0 }
            .bind(to: observer)
            .disposed(by: disposeBag)
        
        
        

//        input.map(_drive)
//            .drive(self.button.rx.isEnabled)
//            .disposed(by: disposeBag)
        
        
        
//        self.textfield.rx.text.orEmpty.changed
//            .subscribe(onNext: {
//                print("您输入的是：\($0)")
//                self.label.text = $0
//            })
//            .disposed(by: disposeBag)
        
//        let _ = Observable<Int>.interval(1, scheduler: MainScheduler.instance).map {"当前索引数：\($0 )"}.bind(to: self.label.rx.text).disposed(by: disposeBag)
    }
    
    func _drive (str: String) -> String {
        return str
    }
    
    func _bind_tableview() {
        //将数据源数据绑定到tableView上
        MusicList.data
            .bind(to: tableView.rx.items(cellIdentifier:"CELL_IDENTIFY_ID")) { _, music, cell in
                cell.textLabel?.text = music.name
                cell.detailTextLabel?.text = music.singer
            }.disposed(by: disposeBag)
        
        //tableView点击响应
        tableView.rx.modelSelected(Music.self).do(onNext: { element in
            print("Intercepted Next：", element)
        }, onError: { error in
            print("Intercepted Error：", error)
        }, onCompleted: {
            print("Intercepted Completed")
        }, onDispose: {
            print("Intercepted Disposed")
        }).subscribe(onNext: { music in
            print("你选中的歌曲信息【\(music)】")
        }, onError: { error in
            print(error)
        }, onCompleted: {
            print("completed")
        }, onDisposed: {
            print("disposed")
        }
        ).disposed(by: disposeBag)
    }


}

//extension ViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.MusicList.data.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var cell: UITableViewCell? = nil
//        cell = tableView.dequeueReusableCell(withIdentifier: "CELL_IDENTIFY_ID") // , for: indexPath
//
//        if cell == nil{
//            cell = UITableViewCell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: "CELL_IDENTIFY_ID")
//        }
//        let image = UIImage (named: "admin")
//        let music = MusicList.data[indexPath.row]
//        cell?.imageView?.image = image
//        cell?.textLabel?.text = music.name
//        cell?.detailTextLabel?.text = music.singer
//        cell?.accessoryType = .disclosureIndicator
//
//        return cell!
//    }
//
//    //单元格点击
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView!.deselectRow(at: indexPath, animated: true)
//        print("你选中的歌曲信息【\(MusicList.data[indexPath.row])】")
//    }
//
//}
