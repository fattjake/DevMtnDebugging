//
//  ViewController.swift
//  Search iTunes Debugging
//
//  Created by Jake Gundersen on 11/11/16.
//  Copyright © 2016 Jake Gundersen. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate {
    var searchBar : UISearchBar?
    var itunesResults = [Result]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        let sb = UISearchBar(frame: rect)
        sb.showsCancelButton = true
        sb.delegate = self
        
        self.tableView.tableHeaderView = sb
        searchBar = sb
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dismissSearchBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchString = searchBar.text {
            iTunesRequestManager.getSearchResults(searchString, results: 25, langString: "en") { results, error in
                //4
                let itresults = results.map { return Result(dictionary: $0) }
                    .enumerated()
                    .map({ index, element -> Result in
                        element.rank = index + 1
                        return element
                    })
                
              
                    self.itunesResults = itresults
                    self.tableView.reloadData()
                    self.searchBar?.resignFirstResponder()
            }
        }
    }
    
    func dismissSearchBar() {
        tableView.setContentOffset(CGPoint(x: 0, y: 44), animated: true)
        searchBar?.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismissSearchBar()
    }
    
    //MARK: UITableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itunesResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomiTunesCell") as? CustomiTunesCell {
            let index = indexPath.row + 1
            let result = itunesResults[index]
            
            result.loadIcon(completion: { (image) in
                cell.imgView.image = image
            })
            cell.mainLabel.text = result.trackName
            cell.detailLabel.text = result.artistName
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let storyboard = self.storyboard,
            let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            let result = itunesResults[indexPath.row]
            vc.result = result
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

