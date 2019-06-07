//
//  JokeDetailViewController.swift
//  DadJokes
//
//  Created by Thomas Cacciatore on 6/3/19.
//  Copyright © 2019 Thomas Cacciatore. All rights reserved.
//

import UIKit

class JokeDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAppearance()
    }
    
    func updateViews() {
        guard let dadJoke = joke else { return }
        DispatchQueue.main.async {
            self.textView.text = dadJoke.joke
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isFree == true {
            createTextView.isHidden = true
            createJokeButton.isHidden = true
            
            if let _ = joke {  // if our joke variable is fed from PrepareForSegue, hide buttons for read-only
                updateViews()

                navigationItem.rightBarButtonItem = nil
                
                
                createTextView.isHidden = true
                createJokeButton.isHidden = true
            }
        } else {
            
            textView.isHidden = true
            saveJokeButton.isHidden = true
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    func setAppearance() {
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 16
        
        createTextView.layer.borderColor = UIColor.black.cgColor
        createTextView.layer.borderWidth = 1
        createTextView.backgroundColor = .white
        createTextView.layer.cornerRadius = 16
        
        saveJokeButton.layer.borderWidth = 1
        saveJokeButton.layer.borderColor = UIColor.black.cgColor
        saveJokeButton.layer.cornerRadius = 12
        saveJokeButton.backgroundColor = AppearanceHelper.darkBlue
        
        createJokeButton.layer.borderWidth = 1
        createJokeButton.layer.borderColor = UIColor.black.cgColor
        createJokeButton.layer.cornerRadius = 12
        createJokeButton.backgroundColor = AppearanceHelper.darkBlue
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let edittedJoke = textView.text, !edittedJoke.isEmpty else { return }
        
        if let joke = joke,
           detailSegueBool == true {
            
            jokeController?.update(joke: joke, with: edittedJoke)
        } else {
            
            guard let dadJoke = self.jokeController?.joke else { return }
            self.jokeController?.createJoke(with: dadJoke.joke)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func getJokeTabPressed(_ sender: Any) {
    
        jokeController?.fetchJoke(completion: { (error) in
            if let error = error {
                NSLog("Error fetching Joke: \(error)")
                return
            }
            guard let dadJoke = self.jokeController?.joke else { return }
            DispatchQueue.main.async {
                self.joke = dadJoke
            }
        })
    }
    
    @IBAction func createJokeButtonTapped(_ sender: Any) {

        guard let createdJoke = createTextView.text, !createdJoke.isEmpty else { return }
        jokeController?.createPrivateJoke(with: createdJoke)

        self.navigationController?.popViewController(animated: true)

    }
    
    // footer table view which eliminatew empty spaces.
    // snazzy up the tqble-view black and white
    // dribble.com for inspiration.
  
    
    // MARK: - Properties
   
    func editJoke() {
        print("EDIT TEXT VIEW TOUCHED")
        jokeController?.createJoke(with: textView.text)
        //editJoke()
        
    }
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var saveJokeButton: UIButton!
    @IBOutlet var createTextView: UITextView!
    @IBOutlet var createJokeButton: UIButton!
    
    
    var joke: DadJoke? {
        didSet {
            updateViews()
        }
    }
    var jokeController: JokeController?
    var detailSegueBool: Bool?
    var isFree: Bool?

}
