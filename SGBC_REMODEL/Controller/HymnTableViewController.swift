//
//  HymnTableViewController.swift
//  SGBC_REMODEL
//
//  Created by ADMIN on 17/09/2022.
//

import UIKit
import WebKit

class HymnTableViewController: UITableViewController, UISearchBarDelegate{

    
    var webView: WKWebView!
    var hymns = [String]()
    
    var filteredData = [String]()
    var allData = [String]()
    var searchBarIsEmpty = true
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // adding a search bar
        let searchBar = UISearchBar(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: view.frame.width, height: 40)))
        searchBar.delegate = self
        view.addSubview(searchBar)
        
        tabBarController?.tabBar.isHidden = true
        self.tableView.keyboardDismissMode = .onDrag
        self.hideKeyboardWhenTappedAround()
        
        
        
        title = "Psalms & Hymns"
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items{
            if item.contains(".pdf"){
                hymns.append(item)
            }
        }
        hymns.append("Hymn 0.pdf") // temporary fix for search bar in view -> use uiviewcontroller instead
        sortHymn(hymnList: &self.hymns, ascendingOrder: true)

    }
    
    // Refactor this sorting later
    func sortHymn(hymnList hymn: inout [String], ascendingOrder order: Bool){
        hymn.sort{first, second in
            var final_string = slice(first, from: " ", to: ".")!
            var before_final: String = ""
            // checking for versions and enabling sort with version for the end ®
            if final_string.contains(" "){
                before_final = final_string
                final_string = slice(final_string, from: 0, to: " ")!
            }
            
            var final_string2 = slice(second, from: " ", to: ".")!
            var before_final2: String = ""
            // checking for versions and enabling sort with version for the end
            if final_string2.contains(" "){
                before_final2 = final_string2
                final_string2 = slice(final_string2, from: 0, to: " ")!
            }
            
            // To sort by the second the number if the hymn numbers are the same
            if !before_final.isEmpty && !before_final2.isEmpty{
                if slice(before_final, from: 0, to: " ")! == slice(before_final2, from: 0, to: " ")!{
                    let firstIndex = before_final.firstIndex(of: " ")!
                    let firstStart = before_final.index(firstIndex, offsetBy: 1)
                    let firstIndexNumber = Int(before_final[firstStart...])!
                    
                    let secondIndex = before_final2.firstIndex(of: " ")!
                    let secondStart = before_final2.index(secondIndex, offsetBy: 1)
                    let secondindexNumber = Int(before_final2[secondStart...])!
                    return firstIndexNumber < secondindexNumber
                }
            }
            
            // To sort by the first number if the hymn numbers are different and don't contain versions or
            // if there are versions
            if order {
                return Int(final_string)! < Int(final_string2)!
            }
            else{return Int(final_string)! > Int(final_string2)! }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredData.isEmpty{return hymns.count}
        else{return filteredData.count}
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hymnidentifier", for: indexPath)
        //cell.textLabel?.text = String(hymns[indexPath.row][..<hymns[indexPath.row].firstIndex(of: ".")!])
        if filteredData.isEmpty{
            cell.textLabel?.text = String(hymns[indexPath.row][..<hymns[indexPath.row].firstIndex(of: ".")!])
        }
        else{
            cell.textLabel?.text = String(filteredData[indexPath.row][..<filteredData[indexPath.row].firstIndex(of: ".")!])
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "WebView") as! WebViewController
        let chosenHymn: String!
        if filteredData.isEmpty{
            chosenHymn = hymns[indexPath.row]}
        else{
            chosenHymn = filteredData[indexPath.row]
        }
        let index = chosenHymn.firstIndex(of: ".")!
        let selectedHymn = String(chosenHymn[..<index])
        vc.selectedHymn = selectedHymn
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        if searchText == ""{
            searchBarIsEmpty = true
            self.tableView.reloadData()
        }
        else{
            searchBarIsEmpty = false
            for item in hymns{
                if item.lowercased().contains(searchText.lowercased()){filteredData.append(item)}
            //self.tableView.reloadData()
            }
            filteredData.append("Hymn 0.pdf") // temporary fix
            filteredData.sort{$0 < $1}
            self.tableView.reloadData()
        }
    }
    

}
