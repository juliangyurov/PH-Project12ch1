//
//  ViewController.swift
//  Project1
//
//  Created by Yulian Gyuroff on 17.09.23.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [String]()
    var viewCounters = [Int]()
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let savedViewCounters = defaults.object(forKey: "savedViewCounters") as? [Int] {
            viewCounters = savedViewCounters
        }
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Storm Viewer"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            let items = try! fm.contentsOfDirectory(atPath: path)
            for item in items {
                //print(item)
                if item.hasPrefix("nssl"){
                    //This is picture to load
                    self?.pictures.append(item)
                    if ((self?.viewCounters.isEmpty) != nil) {
                        self?.viewCounters.append(0)
                    }
                }
                self?.pictures.sort()
            }
            print(self?.pictures ?? ["NA"])
            
            DispatchQueue.main.async {
                [weak self] in
                self?.tableView.reloadData()
            }
        }
 
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.selectedNumber = indexPath.row
            vc.numberImages = pictures.count
            viewCounters[indexPath.row] += 1
            defaults.set(viewCounters,forKey: "savedViewCounters")
            tableView.reloadData()
            navigationController?.pushViewController(vc, animated: true)
        }
            
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        cell.detailTextLabel?.text = "Views: \(viewCounters[indexPath.row])"
        return cell
    }
    
    @objc func shareTapped(){
        let vc = UIActivityViewController(activityItems: ["Check my new app \"Storm Viewer\""], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

}

