//
//  PlaceViewModel.swift
//  Shisheo
//
//  Created by Arina Nefedova on 26.07.2021.
//

import Foundation
import RxSwift
//import RxCocoa

class PlaceViewModel {
    
    public enum PlaceError {
        case internetError(String)
        case serverMessage(String)
    }
    
    public let places : PublishSubject<[Place]> = PublishSubject()
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let error : PublishSubject<PlaceError> = PublishSubject()
    
    private let disposable = DisposeBag()
    private let url = "https://gateway-dev.shisheo.com/social/api/web/post/arina/test"
    
    
    public func requestData(){
        
        self.loading.onNext(true)
        APIManager.requestData(url: url, method: .get, parameters: nil, completion: { (result) in
            self.loading.onNext(false)
            switch result {
            case .success(let returnJson) :
                let places = returnJson.arrayValue.compactMap {return Place(data: try! $0.rawData())}
                self.places.onNext(places)
            case .failure(let failure) :
                switch failure {
                case .connectionError:
                    self.error.onNext(.internetError("Check your Internet connection."))
                case .authorizationError(let errorJson):
                    self.error.onNext(.serverMessage(errorJson["message"].stringValue))
                default:
                    self.error.onNext(.serverMessage("Unknown Error"))
                }
            }
        })
        
    }
}
