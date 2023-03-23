//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by tamu on 24/03/23.
//

import UIKit
import RxSwift
import SkeletonView

class DetailViewController: UIViewController {
    @IBOutlet weak var cityNameLbl: UILabel!
    @IBOutlet weak var weatherTitleLbl: UILabel!
    @IBOutlet weak var weatherValueLbl: UILabel!
    @IBOutlet weak var minTempTitleLbl: UILabel!
    @IBOutlet weak var minTempValueLbl: UILabel!
    @IBOutlet weak var maxTempTitleLbl: UILabel!
    @IBOutlet weak var maxTempValueLbl: UILabel!
    @IBOutlet weak var sunriseTitleLbl: UILabel!
    @IBOutlet weak var sunriseValueLbl: UILabel!
    @IBOutlet weak var sunsetTitleLbl: UILabel!
    @IBOutlet weak var sunsetValueLbl: UILabel!

    var cityId = 0
    var viewModel = Dependency().resolve(DetailViewModel.self)
    var disposeBag = DisposeBag()
    
    init(cityId: Int) {
        super.init(nibName: String(describing: DetailViewController.self), bundle: nil)
        self.cityId = cityId
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Current Weather"
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.state.asObservable()
            .subscribe(onNext: { [weak self] state in
                guard let weakSelf = self else { return }
                switch state {
                case .failed, .loading, .notLoad:
                    weakSelf.setupSkeloton()
                case .finished:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        weakSelf.hideSkeloton()
                        weakSelf.configureValue()
                    }
                }
            }).disposed(by: disposeBag)
        viewModel.loadCurrentWeather(cityId: cityId)
    }
    
    private func setupSkeloton() {
        [cityNameLbl, weatherTitleLbl, weatherValueLbl, minTempTitleLbl, minTempValueLbl, maxTempTitleLbl, maxTempValueLbl, sunriseTitleLbl, sunriseValueLbl, sunsetTitleLbl, sunsetValueLbl].forEach {
            $0?.showAnimatedSkeleton()
        }
    }
    
    private func hideSkeloton() {
        [cityNameLbl, weatherTitleLbl, weatherValueLbl, minTempTitleLbl, minTempValueLbl, maxTempTitleLbl, maxTempValueLbl, sunriseTitleLbl, sunriseValueLbl, sunsetTitleLbl, sunsetValueLbl].forEach {
            $0?.hideSkeleton()
        }
    }

    private func configureValue() {
        if let validData = viewModel.responseData {
            cityNameLbl.text = validData.name
            weatherValueLbl.text = validData.weather?.first?.main
            minTempValueLbl.text = setTempFormat(temp: validData.main?.temp_min)
            maxTempValueLbl.text =  setTempFormat(temp: validData.main?.temp_max)
            sunriseValueLbl.text = setDateFormat(date: validData.sys?.sunrise ?? 0)
            sunsetValueLbl.text = setDateFormat(date: validData.sys?.sunset ?? 0)
        }
    }
    
    private func setTempFormat(temp: Double?) -> String {
        if let validTemp = temp {
            let celciusTemp = validTemp - 273.15
            let measurement = Measurement(value: celciusTemp, unit: UnitTemperature.celsius)
            let measurementFormatter = MeasurementFormatter()
            measurementFormatter.unitStyle = .short
            measurementFormatter.numberFormatter.maximumFractionDigits = 2
            measurementFormatter.unitOptions = .temperatureWithoutUnit
            return "\(measurementFormatter.string(from: measurement))C"
        }
        return ""
    }
    
    private func setDateFormat(date: Int) -> String {
        let dateFormatter = DateFormatter()
        let epochTime = TimeInterval(date)
        let newDate = Date(timeIntervalSince1970: epochTime)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd MMM yyyy, HH:mm"
        let finalDate = dateFormatter.string(from: newDate)
        return finalDate
    }
}
