//
//  LoginViewController.swift
//  Tinder
//
//  Created by Marco on 8/24/15.
//  Copyright (c) 2015 Marco. All rights reserved.
//
//
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    var parseModel = ParseModel.singleton
    
    // variável para controlar a 1a execução do programa
    var firstRun = false
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var textUser: UITextField!
    
    @IBOutlet weak var textPassword: UITextField!
    
    @IBOutlet weak var labelLoginResult: UILabel!
    
    @IBAction func buttonLogin (sender: AnyObject) {
        
        if hasEmptyText () == false {
            parseModel.login (textUser.text, password: textPassword.text) {
                (completion, error) in
                
                // retorna nil se não conseguiu criar o objeto
                if completion == nil {
                    
                    // tenta pegar o erro do sistema. se não conseguir, dá uma
                    // mensagem de erro geral
                    if let errorString = error!.userInfo? ["error"] as? String {
                        self.labelLoginResult.text = errorString
                    } else {
                        self.labelLoginResult.text = "Error in login"
                    }
                    
                } else {
                    self.labelLoginResult.text = "Successful login!"
                    
                    self.getUsersListAndGoToSegue (self.textUser.text)
                }
                
                self.stopLoading ()
            }
        }
    }
    
    @IBAction func buttonSignup (sender: AnyObject) {
        
        if hasEmptyText () == false {
            parseModel.registerNewUser (textUser.text, password: textPassword.text) {
                (completion, error) in
                
                // retorna false quando dá erro
                if completion == false {
                    if let errorString = error!.userInfo? ["error"] as? String {
                        self.labelLoginResult.text = errorString
                    } else {
                        self.labelLoginResult.text = "Error: can't create user"
                    }
                    
                } else {
                    self.labelLoginResult.text = "User created with success!"
                
                    self.firstRun = true
                    
                    self.getUsersListAndGoToSegue (self.textUser.text)
                }
                
                self.stopLoading ()
            }
        }
    }
    
    func startLoading () {
        activityIndicator.startAnimating ()
        
        // desabilita os cliques e outros eventos
        // porém, se fizer isso, trava tudo e não dá pra voltar
        UIApplication.sharedApplication ().beginIgnoringInteractionEvents ()
    }
    
    func stopLoading () {
        self.activityIndicator.stopAnimating ()
        
        UIApplication.sharedApplication ().endIgnoringInteractionEvents ()
    }
    
    func hasEmptyText () -> Bool {
        
        var error = false
        
        // verifica se existe texto vazio. em caso contrário, faz o login
        if textUser.text == "" {
            labelLoginResult.text = "Please type your username"
            
            textUser.becomeFirstResponder ()
            
            error = true
        } else if textPassword.text == "" {
            labelLoginResult.text = "Please type your password"
            
            textPassword.becomeFirstResponder ()
            
            error = true
        } else {
            self.view.endEditing (true)
            
            labelLoginResult.text = ""
            
            startLoading ()
            
            error = false
        }
        
        return error
    }
    
    // ocorre quando a pessoa clica na tela
    // serve para tirar o teclado e não atrapalhar a UX
    override func touchesBegan (touches: Set <NSObject>, withEvent event: UIEvent) {
        
        // pára de editar, o que significa que o teclado desaparece
        self.view.endEditing (true)
    }
    
    // called when 'return' key pressed. return NO to ignore.
    // é chamado quando o user aperta o botão <enter> do teclado do app
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        // muda o foco da caixa de texto de acordo com a que está selecionado
        if textUser.isFirstResponder () == true {
            textPassword.becomeFirstResponder ()
        } else if textPassword.isFirstResponder () == true {
            self.view.endEditing (true)
        }
        
        return true
    }
    
    override func viewDidAppear (animated: Bool) {
        super.viewDidAppear (animated)
        
        // checa se já fez login e vai automaticamente pra próxima tela caso já
        // exista um usuário no sistema (será o último que fez o login). caso
        // dê nil, significa que não existe nenhum usuário salvo no sistema
        
        if let actualUser = parseModel.autoLogin () {
            // primeiro preenche os dados, depois chama o segue. se chamar o segue
            // antes, a tabela vai aparecer vazia pois ele só pega os dados depois
            
            startLoading ()
            
            getUsersListAndGoToSegue (actualUser.username!)
        }
    }
    
    func getUsersListAndGoToSegue (actualUser : String) {
        // pega a lista de usuários com o mesmo nome e a lista de
        // relacionamentos. insere os valores que não existirem
        // só depois que é feito isso é que é chamado o segue
        
        parseModel.getUsersList () {
            (result) in
            
            for var i = 0; i < result.count; i++ {
                
                // pula o user que tem o nome igual pois ele não precisa
                // ser inserido na planilha de relacionamentos
                if result [i] == actualUser {
                    continue
                } else {
                    
                }
            }
            
            self.performSegueWithIdentifier ("segueLoginToConnection", sender: nil)
        }
    }
    
    // quando for preparar pra segue, passa a lista de usuários pra aparecer na
    // tableview da tela seguinte
    override func prepareForSegue (segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // caso seja a 1a execução, o programa vai rodar de maneira diferente, indo antes
        // para a tela de config e só depois pra de conexão
        
        if segue.identifier == "segueLoginToConnection" && firstRun == true {
            let destination = segue.destinationViewController as! UINavigationController
            
            let targetDestination = destination.topViewController as! ConnectionViewController
            
            // envia para o view controller seguinte a informação de que é a 1a execução
            targetDestination.firstRun = true
        }
        
        self.stopLoading ()
    }
    
    @IBAction func unwindPostImageToUserLoginViewController (segue: UIStoryboardSegue) {
        
        // caso queira fazer alguma coisa na volta da tela de fotos
        
//        if let sourceViewController = segue.sourceViewController as? PostImageViewController {
//            // toda vez que o programa voltar para essa tela, é preciso zerar a lista para que ele
//            // não pegue o resultado de execuções anteriores
//            
//            listOfCheckedUsers = []
//            currentUser = ""
//            
//            // retira da memória as informações sobre o último user logado
//            PFUser.logOut ()
//            
//            textUser.text = ""
//            textPassword.text = ""
//        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear (animated)
        
        // caso existisse uma navigation controller, ele iria precisar desaparecer nessa tela
        // self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear (animated)
        
        //self.navigationController?.navigationBarHidden = false
    }
    
    override func viewDidLoad () {
        super.viewDidLoad ()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning () {
        super.didReceiveMemoryWarning ()
        // Dispose of any resources that can be recreated.
    }
}
