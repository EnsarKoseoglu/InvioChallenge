//
//  SplashViewModel.swift
//  InvioChallenge
//
//  Created by invio on 12.11.2022.
//

import Foundation

protocol SplashViewModel: BaseViewModel {
    /// ViewModel ' den viewController' a event tetitkler.
    var stateClosure: ((Result<SplashViewModelImpl.ViewInteractivity, Error>) -> ())? { set get }
    var isInitialLaunch: Bool { get }
    func setInitialLaunch()
}

final class SplashViewModelImpl: SplashViewModel {
    var stateClosure: ((Result<ViewInteractivity, Error>) -> ())?
    
    func start() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.stateClosure?(.success(.appStart))
        }
    }
}

extension SplashViewModelImpl {
    enum ViewInteractivity {
        case appStart
    }
}

extension SplashViewModelImpl {
  var isInitialLaunch: Bool {
    UserDefaults.standard.bool(forKey: "isInitialLaunch")
  }

  func setInitialLaunch() {
    UserDefaults.standard.set(true, forKey: "isInitialLaunch")
  }
}
