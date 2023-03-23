//
//  MainViewController.swift
//  WeatherApp
//
//  Created by tamu on 23/03/23.
//

import UIKit
import RxSwift
import SkeletonView

class MainViewController: UIViewController {
    @IBOutlet weak var weatherTypeField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    private let weatherTypePickerView = UIPickerView()
    
    var disposeBag = DisposeBag()
    var viewModel = Dependency().resolve(MainViewModel.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherTypeField.delegate = self
        setPickerKeyboard()
        configureTableView()
        bindViewModel()
    }

    private func bindViewModel() {
        viewModel.state.asObservable()
            .subscribe(onNext: { [weak self] state in
                guard let weakSelf = self else { return }
                switch state {
                case .failed, .loading, .notLoad:
                    weakSelf.tableView.showAnimatedSkeleton()
                case .finished:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        weakSelf.tableView.hideSkeleton()
                        weakSelf.tableView.reloadData()
                    }
                }
            }).disposed(by: disposeBag)
        viewModel.insertToCityModel()
    }
    
    private func setPickerKeyboard() {
        weatherTypePickerView.delegate = self
        weatherTypeField.inputView = self.weatherTypePickerView
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let nibName = UINib(nibName: String(describing: MainTableViewCell.self), bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: String(describing: MainTableViewCell.self))
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            textField.text = viewModel.weatherType[0]
        }
        viewModel.populateWeatherByType(weatherType: textField.text ?? "")
        tableView.reloadData()
        return true
    }
}

extension MainViewController: UIPickerViewDelegate {
    //MARK: - PickerDelegate
    @available(iOS 2.0, *)
    @objc public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    @objc func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.weatherType.count
    }
    
    @objc func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.weatherType[row]
    }
    
    @objc func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        weatherTypeField.text = viewModel.weatherType[row]
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getCitiesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MainTableViewCell.self)) as? MainTableViewCell {
            cell.cityNameLbl.text = viewModel.tempDatas[indexPath.row].city?.name
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let data = viewModel.tempDatas[indexPath.row]
        guard let cityId = data.city?.id else { return }
        let detailVC = DetailViewController(cityId: cityId)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension MainViewController: SkeletonTableViewDataSource {
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }
        
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
        
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return String(describing: MainTableViewCell.self)
    }
}
