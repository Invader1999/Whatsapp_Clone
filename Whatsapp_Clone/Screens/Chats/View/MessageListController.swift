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
        tableView.backgroundColor = .clear
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
    
    private lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInset = .init(top: 0, left: 0, bottom: 60, right: 0)
        tableView.scrollIndicatorInsets = .init(top: 0, left: 0, bottom: 60, right: 0)
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let backgroundImageView:UIImageView = {
        let backgroundImageView = UIImageView(image:.chatbackground)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundImageView
    }()
    
    private func setUpViews(){
        view.addSubview(backgroundImageView)
        view.addSubview(tableView)
        
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    private func setUpMessageListeners(){
        let delay = 200
        viewModel.$messages
            .debounce(for: .milliseconds(delay), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &subscriptions)
        
        viewModel.$scrollToBottomRequest
            .debounce(for: .milliseconds(delay), scheduler: DispatchQueue.main)
            .sink { [weak self] scrollRequest in
                if scrollRequest.scroll{
                    self?.tableView.scrollToLastRow(at: .bottom, animated: scrollRequest.isAnimated)
                }
            }
            .store(in: &subscriptions)
            
    }

}


extension MessageListController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        let message = viewModel.messages[indexPath.row]
        cell.contentConfiguration = UIHostingConfiguration{
            switch message.type{
            case .text:
                BubbuleTextView(item: message)
            case .video,.photo:
                BubbleImageView(item:message)
            case .audio:
                BubbleVoiceView(item: message)
            case .admin(let adminType):
                switch adminType {
                case .channelCreation:
                    ChannelCreationTextView()
                    
                    if viewModel.channel.isGroupChat{
                        AdminMessageTextView(channel: viewModel.channel)
                            
                    }
                default:
                    Text("UNKOWN")
                }
            }

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// This is the funationality to scroll to bottom in table view
private extension UITableView{
    func scrollToLastRow(at scrollPosition:UITableView.ScrollPosition,animated:Bool){
        guard numberOfRows(inSection: numberOfSections - 1) > 0 else {return}
        
        let lastSectionIndex = numberOfSections - 1
        let lastRowIndex = numberOfRows(inSection: lastSectionIndex) - 1
        let lastRowIndexPath = IndexPath(row: lastRowIndex, section: lastSectionIndex)
        scrollToRow(at: lastRowIndexPath, at: scrollPosition, animated: animated)
    }
}

#Preview{
    MessageListView(ChatRoomViewModel(.placeholder))
        .ignoresSafeArea()
}


