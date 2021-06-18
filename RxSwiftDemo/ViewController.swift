//
//  ViewController.swift
//  RxSwiftDemo
//
//  Created by Subhra Roy on 18/06/21.
//

import UIKit
import RxSwift
import RxCocoa

struct Product {
    let imageName: String
    let title: String
}

struct ProductViewModel {
    var items = PublishSubject<[Product]>()
    
    func fetchItems(){
        let products = [
            Product(imageName: "house", title: "Home"),
            Product(imageName: "gear", title: "Settings"),
            Product(imageName: "person.circle", title: "Profile"),
            Product(imageName: "airplane", title: "Flights"),
            Product(imageName: "bell", title: "Activity")
        ]
        
        items.onNext(products)
        items.onCompleted()
    }
}

class ViewController: UIViewController {
    
    private let tableView: UITableView = {
       let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var viewModel: ProductViewModel = ProductViewModel()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(tableView)
        tableView.frame = view.bounds
        bindTableData()
    }
    
    private func bindTableData(){
        //Bind items to table
        viewModel.items.bind(to: tableView.rx.items(cellIdentifier: "cell",
                                cellType: UITableViewCell.self)
        ) { row , model , cell in
            cell.textLabel?.text = model.title
            cell.imageView?.image = UIImage(systemName: model.imageName)
        }.disposed(by: disposeBag)
        //Bind a model selected handler
        tableView.rx.modelSelected(Product.self).bind { (model) in
            print("\(model.title)")
            print("\(model.imageName)")
            
        }.disposed(by: disposeBag)
        //fetch items
        viewModel.fetchItems()
    }


}

