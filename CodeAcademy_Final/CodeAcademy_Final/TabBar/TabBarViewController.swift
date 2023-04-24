//
//  ViewController.swift
//  APITask-Egidijus
//
//  Created by Egidijus Vaitkevičius on 2023-03-01.
//

import UIKit


class TabBarViewController: UITabBarController {

    let homeVC = HomeViewController()
    let transactionsVC = TransactionsListViewController()
    let settingsVC = SettingsViewController()
    let sendMoneyVC = TransferViewController()
    let viewModel = TransactionsViewModel()
    let transferVC = TransferViewController()
//    var loggedInUser: UserAuthenticationResponse?
    var serviceAPI: ServiceAPI? // Perduodu is loginVC

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarUI()
        fetchTransactions()
    }
    
    func fetchTransactions() {
//        serviceAPI?.fetchingTransactions(url: URLBuilder.getTaskURL(withId: loggedInUser?.accountInfo.id ?? 0), completion: { [weak self] (result) in
//            guard let self = self else {
//                return
//            }
//            DispatchQueue.main.async {
//                switch result {
//                    case .success(let transactions):
//                        print("\(transactions)")
//
//                    case .failure(let error):
//                        print("Error processing json data: \(error)")
//                }
//                    }
//            })
    }

    func setupTabBarUI() {
        let transactionsViewControllerNavigation = UINavigationController(rootViewController: transactionsVC)
        self.setViewControllers([homeVC, transactionsViewControllerNavigation, sendMoneyVC, settingsVC], animated: true)
        guard let items = self.tabBar.items else { return }
        let images = ["house.fill", "arrow.left.arrow.right","list.bullet.clipboard.fill", "gearshape.fill"]

        let color = UIColor(red: 18/255, green: 79/255, blue: 80/255, alpha: 1)

//        let color = UIColor(red: 48/255, green: 176/255, blue: 199/255, alpha: 1.0)
        for image in 0...3 {
            let origImage = UIImage(systemName: images[image])
            let tintedImage = origImage?.withTintColor(color, renderingMode: .alwaysOriginal)
            items[image].image = tintedImage
        }

//        self.tabBar.backgroundColor = UIColor(red: 18/255, green: 79/255, blue: 80/255, alpha: 1)
        let titleColor = UIColor(red: 64/255, green: 200/255, blue: 224/255, alpha: 1)
        UITabBar.appearance().tintColor = titleColor

        homeVC.title = "Home"
        settingsVC.title = "Settings"
        sendMoneyVC.title = "Transfer"
        transactionsVC.title = "Transactions"
        
    }

    func setUser(_ loggedInUser: UserAuthenticationResponse, serviceAPI: ServiceAPI?) {
        homeVC.loggedInUser = loggedInUser
        transactionsVC.loggedInUser = loggedInUser
        settingsVC.loggedInUser = loggedInUser
        sendMoneyVC.loggedInUser = loggedInUser

        self.serviceAPI = serviceAPI

        guard let serviceAPI = serviceAPI else {
            print("Reference of serviceAPI was not transferred")
            return
        }
        
        serviceAPI.fetchingTransactions(url: URLBuilder.getTaskURL(withId: loggedInUser.accountInfo.id), completion: { [weak self] (result) in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                switch result {
                    case .success(let transactions):
                        print("\(transactions)")
    
                    case .failure(let error):
                        print("Error processing json data: \(error)")
                }
                    }
            
            })

        homeVC.serviceAPI = serviceAPI
        settingsVC.serviceAPI = serviceAPI
        settingsVC.homeVC = homeVC
        sendMoneyVC.serviceAPI = serviceAPI
        transactionsVC.serviceAPI = serviceAPI
        transactionsVC.viewModel = viewModel
        homeVC.viewModel = viewModel
        transferVC.viewModel = viewModel

    }

}
