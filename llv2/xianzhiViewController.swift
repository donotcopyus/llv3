//
//  xianzhiViewController.swift
//  LunaLauren
//
//  Created by Luna Cao on 2018/7/5.
//  Copyright © 2018年 Luna Cao. All rights reserved.
//

import UIKit

class xianzhiViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    //return rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return self.setel.count
    }
    
    //create contents
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let identify:String = "cell"
        let cell = table.dequeueReusableCell(withIdentifier: identify, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = self.setel[indexPath.row]
        return cell
    }
    

    @IBOutlet weak var search: UISearchBar!
    
    @IBOutlet weak var table: UITableView!
    
    var set:[String] = ["我是","用来","测试","的！","只是","一个","demo"]
    var setel:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 代理
        self.setel = self.set
        self.search.delegate = self
        self.table.delegate = self
        self.table.dataSource = self
        
        self.table.register(UITableViewCell.self,forCellReuseIdentifier: "cell")
        
    }
    
    func searchBar (_ search:UISearchBar, textDidChange searchText: String){
        
        print(searchText)
        
        //as the case of no input
        if searchText == ""{
            self.setel = self.set
        }
       
        else {
            self.setel = []
            for ctrl in self.set {
                if ctrl.lowercased().hasPrefix(searchText.lowercased()) {
                    self.setel.append(ctrl)
                }
            }
        }
        
        self.table.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //button to go back to main
    @IBOutlet weak var back: UIButton!
    @IBAction func goBack(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
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
