//
//  AddItemTableViewController.swift
//  checklist
//
//  Created by Rigoberto Dominguez Garcia on 21/10/22.
//

import UIKit

protocol AddItemViewControllerDelegate: AnyObject {
    func itemDetailViewControllerdidCancel(
        _ controller: ItemDetailViewController)
    func itemDetailViewController(
        _ controller: ItemDetailViewController,
        didFinishAdding item: ChecklistItem)
    func itemDetailViewController(
        _ controller: ItemDetailViewController,
        didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    weak var delegate: AddItemViewControllerDelegate?
    
    var itemToEdit: ChecklistItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        if let (item) = itemToEdit {
            // temporaryConstant now contains the unwrapped value of the
            // optional variable. temporayConstant is only available from
            // within this if block
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
        }
        
    }
    
    // MARK: Actions
    
    @IBAction func cancel(){
        delegate?.itemDetailViewControllerdidCancel(self)
    }
    
    @IBAction func done(){
        
        if let item = itemToEdit {
            item.text = textField.text!
            delegate?.itemDetailViewController(self, didFinishEditing: item)
        } else {
            let item = ChecklistItem(text: textField.text!)
            
            delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // MARK: Table View Delegates
    
    override func tableView (
    _ tableView: UITableView,
    willSelectRowAt indexPath: IndexPath
    ) -> IndexPath? {
        return nil
    }
    
    // MARK: - Text Field Delegate
    
    func textField (
        _ textField: UITextField,
        shouldChangeCharactersIn range : NSRange,
        replacementString string: String
    ) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range,in:oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        if newText.isEmpty{
            doneBarButton.isEnabled = false
        } else {
            doneBarButton.isEnabled = true
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
      doneBarButton.isEnabled = false
      return true
    }


}