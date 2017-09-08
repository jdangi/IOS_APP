//
//  chatTableViewController.swift
//  run 2 gether
//
//  Created by shahad albalawi on 7/21/17.
//  Copyright © 2017 Shahd Alblu. All rights reserved.
//
//refrence https://www.letsbuildthatapp.com/
import UIKit
import Firebase

class chatTableViewController: UITableViewController {

       let cellId = "cellId"
    
  //  @IBOutlet weak var titlev: UINavigationItem!
    var users = [User]()
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUser()
        
        observeMesssges()
      
      
        
       //self.navigationItem.titleView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController) ))
      
    }
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    func observeMesssges(){
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
       
              if let dictionary = snapshot.value as? [String: Any]{
                let message = Message()
                message.setValuesForKeys(dictionary)
                //self.messages.append(message)
               
                if let chatpartnerId = message.chatPartnerId() {
                    
                self.messagesDictionary[chatpartnerId] = message
                self.messages = Array(self.messagesDictionary.values)
                }
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()})
                
            }
                     })
    }
   //func showChatController(){
    
   // let Chatlogcontrol = chatlogcontrol()
   // navigationController?.pushViewController(Chatlogcontrol, animated: true)
//   }
    
    func fetchUser (){
    
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
        
            if let dictionary = snapshot.value as? [String: Any]{
            let user = User()
                user.setValuesForKeys(dictionary)
                
                if user.uid != Auth.auth().currentUser?.uid {
            self.users.append(user)
                }
                ////
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()})
            //print (user.email!)
            }
           //print(snapshot)
            
        }, withCancel: nil)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

  //  override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
   //     return 0
  //  }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                     // Configure the cell...
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)

        
        let user = users[indexPath.row]
         
        
        cell.textLabel?.text = user.username
      
        cell.imageView?.image = UIImage(named:"icon")
        
        
     /*
        
        let timeLabel:UILabel = {
            let label = UILabel()
            label.text = ""
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = UIColor.lightGray
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        cell.addSubview(timeLabel)
     
        timeLabel.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: 20 ).isActive = true
        timeLabel.topAnchor.constraint(equalTo: cell.topAnchor, constant: 10).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo:  (cell.textLabel?.heightAnchor)!).isActive = true
        
       let dateform = DateFormatter()
        var date = Date()
        
        for (toId, message) in messagesDictionary{
            if (toId == user.uid){
                cell.detailTextLabel?.text = message.text
                date = Date(timeIntervalSince1970: message.timestamp as! TimeInterval )
                dateform.dateFormat = "hh:mm:ss a"
            timeLabel.text = dateform.string(from: date)
               // print(Date(timeIntervalSince1970: message.timestamp as! TimeInterval ))
                //timeLabel.text = stringFromTimeInterval(interval: message.timestamp as! TimeInterval)
            }else{
                cell.detailTextLabel?.text = " "
            }
        }

        */
       // var message: Message? {
       //     didSet {
         //       if let toId = message?.toId {
          //      let ref =
            //    Database.database().reference().child("users").child(toId)
           //         ref.observe(.value, with: { (snapshot) in
             //           if let dictionary = snapshot.value as? [String: Any]{
              //          self.te}
             //           })
           //     }
          //  }
     //   }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        let user = self.users[indexPath.row]
        
        
        let ChatLogControl = chatlogcontrol(collectionViewLayout: UICollectionViewLayout())
            ChatLogControl.user = user
            self.navigationController?.pushViewController(ChatLogControl, animated: true)
        
        
    }
  
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
