//
//  DetailsViewController.swift
//  RxSwiftDemo
//
//  Created by Subhra Roy on 22/06/21.
//

import UIKit
import Combine
import Foundation

enum TextInputError: Error {
    case justInputError
}

class DetailsViewController: UIViewController {
    
    @IBOutlet weak private var toggleSwitch: UISwitch!
    @IBOutlet weak private var tapButton: UIButton!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var descriptionTxt: UITextField!
    
    private var detailsViewModel: DetailsViewModel
    @Published var itemName: String = ""
    @Published private var canSendMessage: Bool = false
   // @Published private var canFocusOnTextField: Bool = false
   
    private var cancellables = Set<AnyCancellable>()
    
    init?(coder: NSCoder,
          detailsViewModel: DetailsViewModel) {
        self.detailsViewModel = detailsViewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with a user.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        itemName = self.detailsViewModel.item.title
        self.tapButton.isEnabled = false
         $canSendMessage.assign(to: \.isEnabled, on: self.tapButton)
                              .store(in: &cancellables)
      //  $canFocusOnTextField.assign(to: \.text, on: self.descriptionTxt)
        
        $itemName.sink(receiveCompletion: { (completion) in
                        switch completion {
                            case .failure(let error): print("Something went wrong: \(error)")
                            case .finished: print("Received Completion")
                        }
                    }, receiveValue: { [weak self] (note) in
                        print("Received value:  \(note)")
                        self?.descriptionLabel.text = note
                    })
                    .store(in: &cancellables)
        
    }
    
    @IBAction func didTapOnButton(_ sender: Any) {
        print("Button is enable")
        if !self.descriptionTxt.isFocused { self.descriptionTxt.becomeFirstResponder() }
    }
    
    @IBAction func didChangeSwitch(_ sender: Any) {
        if let switchControl: UISwitch = sender as? UISwitch {
            canSendMessage = switchControl.isOn
            //canFocusOnTextField = switchControl.isOn
        }
    }
    
    @IBAction func didChangeTextOnEdit(_ sender: Any) {
        if let textField: UITextField = sender as? UITextField {
            itemName = textField.text ?? ""
        }else{
          //  itemName = Subscribers.Completion<TextInputError>.failure(.justInputError)
        }
    }
    
//    var validateItemName: AnyPublisher<String, Never>{
//        return $itemName
//                .compactMap { note -> String? in
//                    return note
//                }
//                .filter{ $0.count > 0}
//                .eraseToAnyPublisher()
//    }
//
  
    
    deinit {
        cancellables.removeAll()
    }
   
}

extension DetailsViewController : UITextFieldDelegate{
    
}



extension Notification.Name{
    static let textDidChange = Notification.Name(rawValue: "Update_Text")
}

struct DetailsViewModel {
    var item: Product
    let combineNotification: NotificationCenter
    
    
    init(item: Product,
         notification: NotificationCenter) {
        self.item = item
        self.combineNotification = notification
    }
        
}
