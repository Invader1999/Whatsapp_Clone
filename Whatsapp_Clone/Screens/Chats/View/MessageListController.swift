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
    private var lastSrcollPosition:String?
    
    
    //MARK: CUSTOM ANIMATION PROPERTY
    private var startingFrame:CGRect?
    private var blurView:UIVisualEffectView?
    private var focusedView:UIView?
    private var highlightedCell:UICollectionViewCell?
    
    
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
    
    private let pullDownHUDView:UIButton = {
        var buttonConfig = UIButton.Configuration.filled()
        var imageConfig = UIImage.SymbolConfiguration(pointSize: 10,weight: .black)
        
        let image = UIImage(systemName: "arrow.up.circle.fill",withConfiguration: imageConfig)
        buttonConfig.image = image
        buttonConfig.baseBackgroundColor = .bubbleGreen
        buttonConfig.baseForegroundColor = .whatsAppBlack
        buttonConfig.imagePadding = 5
        buttonConfig.cornerStyle = .capsule
        let font = UIFont.systemFont(ofSize: 12, weight: .black)
        buttonConfig.attributedTitle = AttributedString("Pull Down",attributes: AttributeContainer([NSAttributedString.Key.font:font]))
        
        let button = UIButton(configuration: buttonConfig)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        return button
    }()
    
    private func setUpViews(){
        view.addSubview(backgroundImageView)
        view.addSubview(messagesCollectionView)
        view.addSubview(pullDownHUDView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            messagesCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            messagesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messagesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            messagesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            
            pullDownHUDView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide
                .topAnchor,constant: 10),
            pullDownHUDView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
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
        
        viewModel.$isPaginating
            .debounce(for: .milliseconds(delay), scheduler: DispatchQueue.main)
            .sink { [weak self] isPaginating in
                guard let self = self, let lastSrcollPosition else {return}
                if isPaginating == false{
                    guard let index = viewModel.messages.firstIndex(where: {$0.id == lastSrcollPosition}) else {return}
                    let indexPath = IndexPath(item: index, section: 0)
                    self.messagesCollectionView.scrollToItem(at: indexPath,at: .top, animated: false)
                    self.pullToRefersh.endRefreshing()
                }
                
            }.store(in: &subscriptions)
    }

}


extension MessageListController:UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        cell.backgroundColor = .clear
        let message = viewModel.messages[indexPath.item]
        let isNewDay = viewModel.isNewDay(for: message, at: indexPath.item)
        let showSenderName = viewModel.showSenderName(for: message, at: indexPath.item)
        cell.contentConfiguration = UIHostingConfiguration{
            BubbleView(message: message, channel: viewModel.channel, isNewDay: isNewDay, showSenderName:showSenderName)

        }
        return cell
    }
    
    func collectionView(_ tableView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //logic to create snapshot of a selected Cell to display it over
        guard let selectedCell = collectionView.cellForItem(at: indexPath) else {return}
        
        //selectedCell.backgroundColor = .red
        startingFrame =  selectedCell.superview?.convert(selectedCell.frame, to: nil)
        
        guard let snapshotCell = selectedCell.snapshotView(afterScreenUpdates: false) else {return}
        focusedView = UIView(frame: startingFrame ?? .zero)
        guard let focusedView else {return}
        focusedView.isUserInteractionEnabled = false
//        focusedView.backgroundColor = .yellow
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissContextMenu))
        let blurEffect = UIBlurEffect(style: .regular)
        blurView = UIVisualEffectView(effect: blurEffect)
        guard let blurView else {return}
       
        blurView.contentView.isUserInteractionEnabled = true
        blurView.contentView.addGestureRecognizer(tapGesture)
        blurView.alpha = 0
        highlightedCell = selectedCell
        highlightedCell?.alpha = 0
        
        guard let keyWindow = UIWindowScene.current?.keyWindow else {return}
        
        keyWindow.addSubview(blurView)
        keyWindow.addSubview(focusedView)
        focusedView.addSubview(snapshotCell)
        blurView.frame = keyWindow.frame

        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn) {
            blurView.alpha = 1
            focusedView.center.y = keyWindow.center.y
            snapshotCell.frame = focusedView.bounds
        }

        
        //        UIApplication.dismissKeyboard()
        //        let messageItem = viewModel.messages[indexPath.row]
        //        switch messageItem.type{
        //
        //        case .video:
        //            guard let videoURLString = messageItem.videoURL,
        //                  let videoURL = URL(string: videoURLString)
        //            else{ return }
        //            viewModel.showMediaPlayer(videoURL)
        //
        //        default:
        //            break
        //        }
        
        
        
        
    }
    
   
    @objc private func dismissContextMenu(){
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut) {[weak self] in
            guard let self = self else {return}
            focusedView?.frame = startingFrame ?? .zero
            blurView?.alpha = 0
        }completion: { [weak self] _ in
            self?.highlightedCell?.alpha = 1
            self?.blurView?.removeFromSuperview()
            self?.focusedView?.removeFromSuperview()
            
            
            //clearing the cell references
            self?.highlightedCell = nil
            self?.blurView = nil
            self?.focusedView = nil
        }
    }
    
    @objc private func refreshData(){
        lastSrcollPosition = viewModel.messages.first?.id
        //messagesCollectionView.refreshControl?.endRefreshing()
        viewModel.paginateMoreMessages()
    }
    
    func scrollViewDidScroll(_ scrollView:UIScrollView){
        if scrollView.contentOffset.y <= 0{
            pullDownHUDView.alpha =  viewModel.isPaginatable ? 1 : 0
        }else{
            pullDownHUDView.alpha = 0
        }
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


