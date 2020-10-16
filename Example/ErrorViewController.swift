//
//  ErrorViewController.swift
//  Example
//
//  Created by Stefan Wieland on 13.10.20.
//  Copyright © 2020 Alexander Schuch. All rights reserved.
//

import StatefulViewController

enum ExampleError: Error, LocalizedError {
    case noConnection
    case `default`
    
    var errorDescription: String? {
        switch self {
        case .noConnection: return "Check your internet connection."
        case .default: return "Some Error."
        }
    }
}

class ErrorViewController: UIViewController, StatefulViewController {
    
    private let refreshControl = UIRefreshControl()

    var foregroundViewStore = [StatefulViewControllerState.empty: []]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup placeholder views
        loadingView = LoadingView(frame: view.frame)
        emptyView = EmptyView(frame: view.frame)
        let failureView = ErrorView(frame: view.frame)
        failureView.tapGestureRecognizer.addTarget(self, action: #selector(refresh))
        errorView = failureView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupInitialViewState()
        refresh()
    }
    
    @objc func refresh() {
        if (lastState == .loading) { return }
        
        let newError = self.newError()
        
        startLoading() {
            print("completaion startLoading -> loadingState: \(self.currentState.rawValue)")
        }
        print("startLoading -> loadingState: \(self.lastState.rawValue)")
        
        // Fake network call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // set Error
            self.endLoading(error: newError, completion: {
                print("completion endLoading -> loadingState: \(self.currentState.rawValue)")
            })
            print("endLoading -> loadingState: \(self.lastState.rawValue)")
        }
    }
    
    private func newError() -> ExampleError {
        guard let currentError = (errorView as? ErrorView)?.error as? ExampleError else { return .default }
        return currentError == .default ? .noConnection : .default
    }
    
}

extension ErrorViewController {
    
    func hasContent() -> Bool {
        return false
    }
    
}
