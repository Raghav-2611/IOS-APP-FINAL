import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBAction func signupTapped(_ sender: UIButton) {
        let signupVC = SignupViewController()
        navigationController?.pushViewController(signupVC, animated: true)
    }


    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBAction func loginTapped(_ sender: UIButton) {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
        else { return }

        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Login error:", error.localizedDescription)
                return
            }

            print("Login success")
            self.goToHome()
        }
    }

    func goToHome() {
        let homeVC = HomeViewController()
        self.view.window?.rootViewController = homeVC
        self.view.window?.makeKeyAndVisible()
    }
}
