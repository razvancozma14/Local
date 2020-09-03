//
//  LocationDetailsViewController.swift
//  Local
//
//  Created by Razvan Cozma on 02/09/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import RxSwift
import UIKit
import Kingfisher

class LocationDetailsViewController: UIViewController {
    private let navigator: NavigatorType
    private let viewModel: LocationDetailsViewModel
    
    private let disposeBag = DisposeBag()
    private var uiItems = [LocationDetailsUIItem]()
    
    private lazy var locationTableView: UITableView = {
        let tableview = UITableView(frame: CGRect.zero)
        tableview.register(LocationTitleTableViewCell.self, forCellReuseIdentifier: "LocationTitleTableViewCell")
        tableview.register(LocationAddressTableViewCell.self, forCellReuseIdentifier: "LocationAddressTableViewCell")
        tableview.register(LocationSubtitleTableViewCell.self, forCellReuseIdentifier: "LocationSubtitleTableViewCell")
        tableview.register(LocationImageTableViewCell.self, forCellReuseIdentifier: "LocationImageTableViewCell")
        tableview.register(LocationMapTableViewCell.self, forCellReuseIdentifier: "LocationMapTableViewCell")
        tableview.rowHeight = UITableView.automaticDimension
        tableview.estimatedRowHeight = 100
        tableview.separatorStyle = .none
        tableview.backgroundColor = .clear
        tableview.dataSource = self
        tableview.delegate = self
        return tableview
    }()
    
    init(viewModel: LocationDetailsViewModel, navigator: NavigatorType) {
        self.viewModel = viewModel
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.UI.defaultBackgroundColor
        setupBindings()
        viewModel.fetchData()
    }
    
    override func loadView() {
        super.loadView()
        self.view.addSubview(locationTableView)
        locationTableView.leadingAnchor(equalTo: view.leadingAnchor)
            .trailingAnchor(equalTo: view.trailingAnchor)
            .topAnchor(equalTo: view.safeAreaLayoutGuide.topAnchor)
            .bottomAnchor(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    func setupBindings(){
        viewModel.locationUIItems.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (items) in
                self.uiItems = items
                self.locationTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension LocationDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uiItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch uiItems[indexPath.row] {
        case .locationTitle(let name):
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTitleTableViewCell", for: indexPath) as! LocationTitleTableViewCell
            cell.nameLabel.text = name
            return cell
        case .address(let address):
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationAddressTableViewCell", for: indexPath) as! LocationAddressTableViewCell
            cell.addressTextField.rx.controlEvent([.editingDidEnd])
                .asObservable()
                .subscribe(onNext: {[unowned self] _ in
                    self.viewModel.updateAddress(address: cell.addressTextField.text ?? "")
                })
                .disposed(by: disposeBag)
            cell.addressTextField.text = address
            return cell
        case .details(detailsTitle: let detailsTitle, detailsSubtitle: let detailsSubtitle):
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationSubtitleTableViewCell", for: indexPath) as! LocationSubtitleTableViewCell
            cell.titleLabel.text = detailsTitle
            cell.subTitleLabel.text = detailsSubtitle
            return cell
        case .image(imageUrl: let imageUrl):
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationImageTableViewCell", for: indexPath) as! LocationImageTableViewCell
            if let url = imageUrl {
                cell.locationImageView.kf.setImage(with: url)
                cell.locationImageView.backgroundColor = .clear
            }else{
                cell.locationImageView.backgroundColor = .lightGray
                cell.locationImageView.image = nil
            }
            return cell
        case .map(latitude: let latitude, longitude: let longitude):
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationMapTableViewCell", for: indexPath) as! LocationMapTableViewCell
            cell.update(latitude: latitude, longitude: longitude)
            return cell
        }
    }
}
