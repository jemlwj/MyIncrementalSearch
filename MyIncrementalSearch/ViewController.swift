//
//  ViewController.swift
//  MyIncrementalSearch
//
//  Created by Jeremy Lua on 30/1/22.
//  Copyright © 2022 Jeremy Lua. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let presenter = APIPresenter()
    
    @IBOutlet weak var queryTextfield: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var queryTableView: UITableView!
    
    var items: [Item] = []
    var loadedPages = 0
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print (APIPresenter.lastAPICall.timeIntervalSinceNow)
        print(Date().timeIntervalSinceNow)
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        let query = self.queryTextfield.text ?? ""
        if query.isEmpty {
            let alert = UIAlertController(title: "Empty textfield", message: "Please enter a query", preferredStyle: .alert )
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true)
        }
        let queryEncoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        self.queryTextfield.resignFirstResponder()
        
        self.loadedPages = 1
        self.presenter.loadList(query: queryEncoded ?? "", page: self.loadedPages, success: { items in
            self.items = items
            DispatchQueue.main.async {
                self.queryTableView.reloadData()
            }
        }, throttleFailure: {
            
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "API Throttling Enabled", message: "The web request can only be made every 5 seconds. Please try again later", preferredStyle: .alert )
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true)
            }
        })
    }
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "queryCell")
//        let cell = tableView.dequeueReusableCell(withIdentifier: "queryCell", for: indexPath)
        
        let cellData = self.items[indexPath.row]
        
        cell.textLabel?.text = cellData.full_name
        cell.detailTextLabel?.text = "\(cellData.html_url)"
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) {
            if !isLoading {
                isLoading = true
                self.presenter.loadList(query: self.queryTextfield.text ?? "test", page: self.loadedPages, success: { items in
                    self.items.append(contentsOf: items)
                    self.isLoading = false
                    DispatchQueue.main.async {
                        self.queryTableView.reloadData()
                    }
                }, throttleFailure: {
                    self.isLoading = false
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "API Throttling Enabled", message: "The web request can only be made every 5 seconds. Please try again later", preferredStyle: .alert )
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                            alert.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true)
                    }
                })
            }
        }
    }
    
}

