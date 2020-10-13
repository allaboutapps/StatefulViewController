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
    
    var errorDescription: String? {
        "Check your internet connection."
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
        
        startLoading {
            print("completaion startLoading -> loadingState: \(self.currentState.rawValue)")
        }
        print("startLoading -> loadingState: \(self.lastState.rawValue)")
        
        // Fake network call
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            // set Error
            self.endLoading(error: ExampleError.noConnection, completion: {
                print("completion endLoading -> loadingState: \(self.currentState.rawValue)")
            })
            print("endLoading -> loadingState: \(self.lastState.rawValue)")
        }
    }
    
}


extension ErrorViewController {
    
    func hasContent() -> Bool {
        return false
    }
    
}
