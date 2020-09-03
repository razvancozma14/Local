//
//  HomeViewController.swift
//  Local
//
//  Created by Razvan Cozma on 01/09/2020.
//  Copyright © 2020 Razvan Cozma. All rights reserved.
//

import RxSwift
import RxCocoa
import RxSwiftExt
import MapKit
import FSPagerView
import NVActivityIndicatorView

class HomeviewControlller: UIViewController{
    private let navigator: NavigatorType
    private let viewModel: HomeViewModel
    private let disposeBag = DisposeBag()
    
    private var homeItems: [HomeUIItem] = []
    private var locationsMarkers = [String: MKPointAnnotation]()
    
    private lazy var loadingView: NVActivityIndicatorView = {
        let loading = NVActivityIndicatorView(frame: CGRect(origin: view.center, size: CGSize(width: 30, height: 30)))
        loading.color = UIColor(red: 255/255, green: 82/255, blue: 62/255, alpha: 1)
        view.addSubview(loading)
        return loading
    }()
    
    private lazy var mapview: MKMapView = {
        let view = MKMapView()
        view.showsUserLocation = true
        return view
    }()
    private let interitemSpacing: CGFloat = 20
    private let offsetItem: CGFloat = 30
    
    private lazy var pagerView: FSPagerView = {
        let pagerView = FSPagerView()
        pagerView.register(HomeCell.self, forCellWithReuseIdentifier: "HomeCell")
        pagerView.interitemSpacing = interitemSpacing
        pagerView.delegate = self
        pagerView.dataSource = self
        return pagerView
    }()
    
    init(viewModel: HomeViewModel, navigator: NavigatorType) {
        self.viewModel = viewModel
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        self.addViews()
        setupBindings()
        self.viewModel.fetchData()
    }
    
    private func addPinnsToMap(){
        
        let showAnntotations = locationsMarkers.isEmpty
        //add or update pin
        for item in homeItems {
            if let oldMarker = locationsMarkers[item.name] {
                oldMarker.coordinate = item.location.coordinate
            } else {
                let annotation = MKPointAnnotation()
                annotation.coordinate = item.location.coordinate
                annotation.title = item.name
                mapview.addAnnotation(annotation)
                locationsMarkers[item.name] = annotation
            }
        }
        
        if showAnntotations {
            mapview.showAnnotations(Array(locationsMarkers.values), animated: false)
        }
        
        //remove pins
        var keySet = Set(locationsMarkers.keys)
        for key in homeItems.map({ $0.name }) {
            keySet.remove(key)
        }
        
        for key in keySet {
            if let marker = locationsMarkers.removeValue(forKey: key) {
                self.mapview.removeAnnotation(marker)
            }
        }
    }
    
    func setupBindings(){
        viewModel.error.asObservable()
            .observeOn(MainScheduler.instance)
            .do(onNext: {[unowned self]  (error) in
                self.showAlert(error: error)
            }).subscribe().disposed(by: disposeBag)
        
        viewModel.locationsUIItems.asObservable()
            .observeOn(MainScheduler.instance)
            .do(onNext: {[unowned self]  (items) in
                self.homeItems = items
                self.pagerView.reloadData()
                self.addPinnsToMap()
            }).subscribe().disposed(by: disposeBag)
        
        
        viewModel.loading.asObservable()
            .observeOn(MainScheduler.instance)
            .do(onNext: {[unowned self]  (show) in
                show ? self.loadingView.startAnimating() : self.loadingView.stopAnimating()
            }).subscribe().disposed(by: disposeBag)
    }
    
    private func showAlert(error: HomeViewModel.HomeError){
        var message = ""
        var secondAction =  UIAlertAction()
        switch error {
        case .internetError(let error):
            message = error
            secondAction = UIAlertAction(title: "Try again", style: .default, handler: {[unowned self] (_) in
                self.viewModel.retry()
            })
        case .locationDisabled:
            message = "This app needs location enabled on your phone. Please activate it from your phone's settings."
            secondAction = UIAlertAction(title: "Go to Settings", style: .default, handler: { (_) in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })
        }
        
        
        let alert = UIAlertController(title: "Oooops!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(secondAction)
        self.present(alert, animated: true)
    }
    
    private func addViews(){
        self.view.backgroundColor = .white
        self.view.addSubview(mapview)
        view.addSubview(pagerView)
        
        mapview.bottomAnchor(equalTo:view.bottomAnchor)
            .leadingAnchor(equalTo: view.leadingAnchor)
            .trailingAnchor(equalTo: view.trailingAnchor)
            .topAnchor(equalTo: view.topAnchor)
        
        let pageheight = (UIScreen.main.bounds.width - interitemSpacing * 2 - offsetItem * 2) / 2
        pagerView.bottomAnchor(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
            .leadingAnchor(equalTo: view.leadingAnchor)
            .trailingAnchor(equalTo: view.trailingAnchor)
            .heightAnchor(equalTo: pageheight)
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        pagerView.itemSize = CGSize(width: pagerView.frame.height * 1.5, height: pagerView.frame.height)
    }
    
    
}

extension HomeviewControlller: FSPagerViewDataSource,FSPagerViewDelegate {
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return homeItems.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "HomeCell", at: index) as! HomeCell
        cell.update(item: homeItems[index])
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        navigator.navigateToDetails(locationTitle: homeItems[index].name, sourceViewController: self)
    }
}

