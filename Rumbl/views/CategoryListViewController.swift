//
//  ViewController.swift
//  Rumbl
//
//  Created by Ramesh A on 26/02/20.
//  Copyright © 2020 Ramesh A. All rights reserved.
//

import UIKit

class CategoryListViewController: UITableViewController {
    
    let defaultRowCount = 1
    let viewModel = CategoryListViewModel()
    
    private var selectedVideoIndex: Int = 0
    private var selectedNodes: [Node]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Explore"
        self.tableView.tableFooterView = nil
        self.tableView.allowsSelection = false
        
        viewModel.fetchVideoFeed { (status) in
            if status {
                print("fetch - succeeded")
                self.tableView.reloadData()
            } else {
                print("fetch - failed")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func moreButtonAction(_ sender: Any) {
        print("more button tapped")
    }
}

extension CategoryListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.categoryCount
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return defaultRowCount
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let defaultHeight = 20
        let defaultWidth = Int(tableView.frame.size.width)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: defaultWidth, height: defaultHeight))
        let xOffset = 20
        let yOffset = 10
        let label = UILabel(frame: CGRect(x: xOffset, y: yOffset, width: defaultWidth - xOffset, height: defaultHeight))
        label.font = UIFont.boldSystemFont(ofSize: 16)
        view.addSubview(label)
        let category = viewModel.categoryList[section]
        // setting the title
        label.text = category.title
        return view
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 205
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // using force unwrapping as this should succeed always
        let cell = tableView.dequeueReusableCell(withIdentifier: "explore_tableview_cell") as! CategoryTableViewCell
        let category = viewModel.categoryList[indexPath.section]
        cell.collectionViewModel = VideoCollectionViewModel(category.nodes)
        cell.delegate = self
        return cell
    }
}

extension CategoryListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected: \(indexPath.section)")
    }
}

extension CategoryListViewController: CategoryTableViewCellDelegate {
    func didSelectNodes(_ nodes: [Node], at index: Int) {
        selectedNodes = nodes
        selectedVideoIndex = index
        showVideoPlayer()
    }
    
    func showVideoPlayer() {
        self.performSegue(withIdentifier: "show_videos", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? PlayerViewController {
            destinationVC.currentIndex = selectedVideoIndex
            destinationVC.nodes = selectedNodes
        }
    }
}
