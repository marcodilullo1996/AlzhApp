//
//  EmergencyContactsViewController.swift
//  prova
//
//  Created by Emanuel Di Nardo on 06/12/2018.
//  Copyright © 2018 Marco Di Lullo. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class EmergencyContactsViewController: UIViewController {
    
    @IBOutlet var customNavigationItem: UINavigationItem!
    @IBOutlet var contactTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customNavigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEmergencyContact))

        // Do any additional setup after loading the view.
    }
    
    @objc func addEmergencyContact() {
        let cnPicker = CNContactPickerViewController()
        cnPicker.delegate = self
        self.present(cnPicker, animated: true, completion: nil)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EmergencyContactsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Database.shared.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let contact = Database.shared.contacts[indexPath.row]
        cell.textLabel?.text = "\(contact.name) \(contact.surname)"
        cell.detailTextLabel?.text = contact.phoneNumber
        
        return cell
    }
    
    private func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Database.shared.contacts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            Database.shared.save(element: Database.shared.contacts, forKey: "EmergencyContacts")
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            Database.shared.contacts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            Database.shared.save(element: Database.shared.contacts, forKey: "EmergencyContacts")
        }
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = Database.shared.contacts[indexPath.row]
        if let url = URL(string: "tel://\(contact.phoneNumber)"),
            UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

extension EmergencyContactsViewController: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        for contact in contacts {
            let contact = Contact.init(name: contact.givenName, surname: contact.familyName, phoneNumber: contact.phoneNumbers.first!.value.stringValue)
            Database.shared.contacts.append(contact)
            Database.shared.save(element: Database.shared.contacts, forKey: "EmergencyContacts")
        }
        contactTableView.reloadData()
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        print("Cancel Contact Picker")
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let contact = Contact.init(name: contact.givenName, surname: contact.familyName, phoneNumber: contact.phoneNumbers.first!.value.stringValue)
        Database.shared.contacts.append(contact)
        Database.shared.save(element: Database.shared.contacts, forKey: "EmergencyContacts")
        contactTableView.reloadData()
    }
    
}
