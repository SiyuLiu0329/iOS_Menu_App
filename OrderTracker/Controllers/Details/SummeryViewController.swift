//
//  SummeryViewController.swift
//  OrderTracker
//
//  Created by macOS on 24/2/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class SummeryViewController: UIViewController {
    var dropDownView: DropDownView!
    var dropDownButton: DropDownButton!
    var orderList: OrderList!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDropDownMenu()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SummeryViewController: UITableViewDelegate, UITableViewDataSource {
    func reloadSummary() {
        dropDownView.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderList.getItemsInCurrentOrder().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = String(describing: orderList.getItemsInCurrentOrder()[indexPath.row].number)
        return cell
    }
    
    
    func setUpDropDownMenu() {
        addBarButton()
        addDropDownView()
        dropDownButton.delegate = dropDownView
    }
    
    func addBarButton() {
        dropDownButton = DropDownButton()
        dropDownButton.frame = CGRect(x: 0, y: 0, width: 150, height: 40)
        dropDownButton.translatesAutoresizingMaskIntoConstraints = false
        dropDownButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        dropDownButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        dropDownButton.setTitle("Order Summary", for: .normal)
        dropDownButton.backgroundColor = UIColor.darkGray
        let item = UIBarButtonItem(customView: dropDownButton)
        self.navigationItem.setRightBarButtonItems([item, item], animated: true)
    }
    
    func addDropDownView() {
        dropDownView = DropDownView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        view.addSubview(dropDownView)
        dropDownView.translatesAutoresizingMaskIntoConstraints = false
        dropDownView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        dropDownView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        dropDownView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        dropDownView.tableView.delegate = self
        dropDownView.tableView.dataSource = self
    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dim = collectionView.bounds.width / 4 - 5
        return CGSize(width: dim, height: dim)
    }
    
}


