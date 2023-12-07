//
//  SearchResultViewController.swift
//  WeatherNow
//
//  Created by Uladzislau Yatskevich on 7.12.23.
//

import UIKit
import Combine

protocol SearchResultViewControllerDelegate {
    func searchResultDidTap(city:String)
}



class SearchResultViewController: UIViewController {


    @IBOutlet var tempLabel: UILabel!

    var viewModel: WeatherViewModel?

    private var cancellable = Set<AnyCancellable>()


    var delegate: SearchResultViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
//        binding()

    }
    
    func configure(model: WeatherDetail) {
    }

//    func binding() {
//        viewModel?.$currentWeather
//            .sink(receiveValue: {[weak self] currentWeather in
//
//                self?.tempLabel.text =
//                currentWeather.main?.temp != nil ?
//                "\(Int((currentWeather.main?.temp!)!)) ºC"
//                : " "}
//            )
//            .store(in: &cancellable)
//    }

}
