//
//  MessageListController.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 24/04/24.
//

import Foundation
import UIKit
import SwiftUI
import Combine

final class MessageListController:UIViewController{
   
    
    
    //MARK: - Views Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.backgroundColor = .clear
        view.backgroundColor = .clear
        setUpViews()
        setUpMessageListeners()
    }
    
    init(_ viewModel:ChatRoomViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit{
        subscriptions.forEach{$0.cancel()}
        subscriptions.removeAll()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let viewModel: ChatRoomViewModel
    private var subscriptions = Set<AnyCancellable>()
    private let cellIdentifier = "MessageListControllerCells"
    
    private lazy var pullToRefersh:UIRefreshControl = {
        let pullToRefresh = UIRefreshControl()
        pullToRefresh.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return pullToRefresh
    }()
    
    
    private let compostionalLayout = UICollectionViewCompositionalLayout{sectionIndex, layoutEnvironment in
        var listCofig = UICollectionLayoutListConfiguration(appearance: .plain)
        listCofig.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        listCofig.showsSeparators = false
        let section = NSCollectionLayoutSection.list(using: listCofig, layoutEnvironment: layoutEnvironment)
        section.contentInsets.leading = 0
        section.contentInsets.trailing = 0
        
        section.interGroupSpacing = -10
        return section
    }
    
    
    private lazy var messagesCollectionView:UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: compostionalLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.selfSizingInvalidation = .enabledIncludingConstraints
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 60, right: 0)
        collectionView.scrollIndicatorInsets = .init(top: 0, left: 0, bottom: 60, right: 0)
        collectionView.keyboardDismissMode = .onDrag
        collectionView.backgroundColor = .clear
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.refreshControl = pullToRefersh
        return collectionView
    }()

    private let backgroundImageView:UIImageView = {
        let backgroundImageView = UIImageView(image:.chatbackground)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundImageView
    }()
    
    private func setUpViews(){
        view.addSubview(backgroundImageView)
        view.addSubview(messagesCollectionView)
        
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            messagesCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            messagesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messagesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            messagesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }
    
    private func setUpMessageListeners(){
        let delay = 200
        viewModel.$messages
            .debounce(for: .milliseconds(delay), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.messagesCollectionView.reloadData()
            }
            .store(in: &subscriptions)
        
        viewModel.$scrollToBottomRequest
            .debounce(for: .milliseconds(delay), scheduler: DispatchQueue.main)
            .sink { [weak self] scrollRequest in
                if scrollRequest.scroll{
                    self?.messagesCollectionView.scrollToLastItem(at: .bottom, animated: scrollRequest.isAnimated)
                }
            }
            .store(in: &subscriptions)
            
    }

}


extension MessageListController:UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        cell.backgroundColor = .clear
        let message = viewModel.messages[indexPath.item]
        let isNewDay = viewModel.isNewDay(for: message, at: indexPath.item)
        cell.contentConfiguration = UIHostingConfiguration{
            BubbleView(message: message, channel: viewModel.channel, isNewDay: isNewDay)

        }
        return cell
    }
    
    func collectionView(_ tableView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIApplication.dismissKeyboard()
        let messageItem = viewModel.messages[indexPath.row]
        switch messageItem.type{
     
        case .video:
            guard let videoURLString = messageItem.videoURL,
                  let videoURL = URL(string: videoURLString)
            else{ return }
            viewModel.showMediaPlayer(videoURL)
            
        default:
            break
        }
    }
    
    @objc private func refreshData(){
        messagesCollectionView.refreshControl?.endRefreshing()
    }
}

// This is the funationality to scroll to bottom in table view
private extension UICollectionView{
    func scrollToLastItem(at scrollPosition:UICollectionView.ScrollPosition,animated:Bool){
        guard numberOfItems(inSection: numberOfSections - 1) > 0 else {return}

        let lastSectionIndex = numberOfSections - 1
        let lastRowIndex = numberOfItems(inSection: lastSectionIndex) - 1
        let lastRowIndexPath = IndexPath(row: lastRowIndex, section: lastSectionIndex)
        scrollToItem(at: lastRowIndexPath, at: scrollPosition, animated: animated)
    }
}

#Preview{
    MessageListView(ChatRoomViewModel(.placeholder))
        .ignoresSafeArea()
}


