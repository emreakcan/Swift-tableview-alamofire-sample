//
//  ViewController.swift
//  HelloWorld
//
//  Created by Emre on 21.06.2018.
//  Copyright © 2018 Emre. All rights reserved.
//

import UIKit
import Alamofire



var jsonDecoder = JSONDecoder()
var messages = [MessageMdl]()

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableView.register(UINib.init(nibName: "MyCellTableViewCell", bundle: nil), forCellReuseIdentifier: "myCell")
        
        self.getMessages()
        
        refreshBtn.addTarget(self, action: #selector(getMessages), for: UIControlEvents.touchUpInside)

    }
    
    @objc func getMessages(){
        Alamofire.request(myUrl).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                
                let allMessages = try? jsonDecoder.decode([MessageMdl].self, from: responseData.data!)
                messages.removeAll()
                for message in allMessages!{
                    messages.append(message)
                    print(message.message)
                }
                
                self.displayMessages()
                
            }
        }
    }
    
    func displayMessages(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("MyCellTableViewCell", owner: self, options: nil)?.first as! MyCellTableViewCell
        
        cell.txtField.text = messages[indexPath.row].message
        cell.txtField.tag = indexPath.row
        cell.sendBtn.tag = indexPath.row
        
        cell.sendBtn.addTarget(self, action: #selector(myTargetFunction2), for: UIControlEvents.touchUpInside)
        cell.txtField.addTarget(self, action: #selector(myTargetFunction), for: UIControlEvents.editingDidBegin)

        return cell
    }
    
    @objc func myTargetFunction(textField: UITextField) {
        textField.text = ""
    }
    
    @objc func myTargetFunction2(_ sender: UIButton) {
        let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! MyCellTableViewCell
        
        if let message = cell.txtField.text{
            sendMessage(message: message, messageMdl: messages[sender.tag])
            messages.remove(at: sender.tag)
            displayMessages()
        }
        
    }
    
    func sendMessage(message: String, messageMdl : MessageMdl){
        let parameters = [
            "message": message,
            "senderfbid": messageMdl.getterfbid ,
            "getterfbid": messageMdl.senderfbid
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in}
        
    }
    
    
}



