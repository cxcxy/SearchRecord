//
//  ViewController.swift
//  SearchRecord
//
//  Created by 陈旭 on 16/9/8.
//  Copyright © 2016年 陈旭. All rights reserved.
//

import UIKit
import TagListView
class ViewController: UIViewController {
    private var myContent = 0
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var hostArray = [String]()
    var newArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .None
        tableView.estimatedRowHeight = 410
        
        tableView.tableHeaderView = searchTagView
        
        hostArray = ["本周特价","新年福袋","天天","分享甘甜的难得时光","上帝在细节中","充满爱的设计"]
       
        for str in hostArray {
            searchTagView.listViewHost.addTag(str)
        }
        
        loadSearchStory()
      
        searchTagView.listViewNew.delegate = self
        searchTagView.listViewHost.delegate = self
        
        searchTagView.listViewNew.addObserver(self, forKeyPath: "bounds", options: .New, context: &myContent)
        
        /**
         测试
         */
        
    }
    /**
     读取视图数据
     */
    func loadSearchTagView()  {
 
         searchTagView.listViewNew.removeAllTags()
      
        for str in newArray {
            searchTagView.listViewNew.addTag(str)
        }

    }
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        let height = searchTagView.listViewHost.bounds.height + searchTagView.listViewNew.bounds.height + 68

        searchTagView.bounds.size.height =  height
        tableView.beginUpdates()
        
        tableView.tableHeaderView = searchTagView

        tableView.endUpdates()
        print(height)
        print("高度发生变化")
        
    }
    lazy var searchTagView: SearchViewHeader = {
        let view = NSBundle.mainBundle().loadNibNamed(String(SearchViewHeader), owner: self, options: nil).last as! SearchViewHeader

        return view
    }()


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    /**
     插入搜索记录，不存在则插入
     */
    func insertSearchStory(searchStr: String) {
        for str in newArray {
            guard str != searchStr else{
                
                return
            }
        }
        
        let sql = "INSERT INTO t_searchModel(searchStr)VALUES(?);"
        
        SearchDB.shareInstance.db.executeUpdate(sql, withArgumentsInArray: [searchStr])
        loadSearchStory()
    }
    /**
     读取最近搜索的历史数据
     */
    func loadSearchStory() {
        
        newArray = []
        
        let sql = "SELECT * FROM t_searchModel;"
        
        let resultSet = SearchDB.shareInstance.db.executeQuery(sql, withArgumentsInArray: nil)
        
        while resultSet.next() {
         
            let name = resultSet.stringForColumn("searchStr")
            
            newArray.insert(name, atIndex: 0)
            
        }
        
        loadSearchTagView()

    }

    @IBAction func closeAction(sender: AnyObject) {
        textField.text = ""
        textField.resignFirstResponder()
        
    }
}
// MARK: - UITextFieldDelegate
extension ViewController:UITextFieldDelegate{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.text == "" {
         
            return false
        }
        textField.resignFirstResponder()

        insertSearchStory(textField.text!)
   
        return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        
        
        return true
    }
    
}

// MARK: - UITableViewDelegate,UITableViewDataSource
extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
         textField.resignFirstResponder()
    }
}
extension ViewController:TagListViewDelegate{
    /**
     点击Item
     
     - parameter title:   
     - parameter tagView:
     - parameter sender:
     */
    func tagPressed(title: String, tagView: TagView, sender: TagListView) -> Void{
        
        insertSearchStory(title)
    }

}
