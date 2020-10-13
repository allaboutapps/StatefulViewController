//
//  ForegroundViewStoreViewController.swift
//  Example
//
//  Created by Matthias Wagner on 27.12.18.
//  Copyright © 2018 Alexander Schuch. All rights reserved.
//

import UIKit
import StatefulViewController

class ForegroundViewStoreViewController: UIViewController, StatefulViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var deleteButton: UIButton!

    @IBOutlet weak var addButton: UIButton!

    @IBOutlet weak var headerView: UIView!

    @IBOutlet weak var headerLabel: UILabel!

    @IBOutlet weak var overlayView: UIView!

    @IBOutlet weak var stateFullContainer: UIView!

    // MARK: - Properties

    private let refreshControl = UIRefreshControl()

    fileprivate var dataArray = [String]()

    // MARK: - LifeCylce

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup refresh control
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)

        let topInset = (navigationController?.navigationBar.frame.origin.y ?? 0)
            + headerView.frame.origin.y
            + headerView.frame.size.height
        let insets = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)

        // Setup placeholder views
        loadingView = LoadingView(frame: view.frame).prepare(insets: insets)
        emptyView = EmptyView(frame: view.frame).prepare(insets: insets)
        let failureView = ErrorView(frame: view.frame)
        failureView.tapGestureRecognizer.addTarget(self, action: #selector(refresh))
        errorView = failureView.prepare(insets: insets)

        foregroundViewStore = [
            .empty: [overlayView, headerLabel, addButton],
            .error: [overlayView, headerLabel, addButton],
            .loading: [addButton]
        ]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupInitialViewState()
        refresh()
    }

    // MARK: - Refresh

    @objc func refresh() {
        if (lastState == .loading) { return }

        startLoading {
            print("completaion startLoading -> loadingState: \(self.currentState.rawValue)")
        }
        print("startLoading -> loadingState: \(self.lastState.rawValue)")

        // Fake network call
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {

            // Success
            self.dataArray = ["Merlot", "Sauvignon Blanc", "Blaufränkisch", "Pinot Nior"]
            self.tableView.reloadData()
            self.endLoading(error: nil, completion: {
                print("completion endLoading -> loadingState: \(self.currentState.rawValue)")
            })
            print("endLoading -> loadingState: \(self.lastState.rawValue)")

            // Error
            //self.endLoading(error: NSError(domain: "foo", code: -1, userInfo: nil))

            // No Content
            //self.endLoading(error: nil)

            self.refreshControl.endRefreshing()
        }
    }

    // MARK: - IBActions

    @IBAction func onRefresh(_ sender: Any) {
        refresh()
    }
    
    @IBAction func onDeleteButton(_ sender: Any) {
        guard let indexOfDeleteButton = foregroundViewStore?[.empty]?.firstIndex(of: deleteButton) else { return }
        foregroundViewStore?[.empty]?.remove(at: indexOfDeleteButton)
    }

    @IBAction func onAddButton(_ sender: Any) {
        foregroundViewStore?[.empty]?.append(deleteButton)
    }
}


extension ForegroundViewStoreViewController {

    func hasContent() -> Bool {
        return false
    }

    func handleErrorWhenContentAvailable(_ error: Error) {
        let alertController = UIAlertController(title: "Ooops", message: "Something went wrong.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

}

// MARK: - UITableViewDataSource

extension ForegroundViewStoreViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath)
        cell.textLabel?.text = dataArray[(indexPath as NSIndexPath).row]
        return cell
    }
}
