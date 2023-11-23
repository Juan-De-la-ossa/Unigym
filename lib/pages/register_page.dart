import 'package:applogin/components/my_button.dart';
import 'package:applogin/components/my_textfield.dart';
import 'package:applogin/components/square_tile.dart';
import 'package:applogin/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
    final Function()? onTap;
    const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
    //text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

    //Sing user up method
    void singUserUp() async {
      // show loading circle
      showDialog(
        context: context, 
        builder:(context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

      //Try creating the user
      try{
        //check is password is confirmed
        if (passwordController.text == confirmpasswordController.text) {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text, 
        password: passwordController.text,
        );
        } else {
          //Show error message, password dont match
          showErroMessage("Las contraseñas no coinciden!");
        }
        // pop the loading circle 
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {

        // pop the loading circle 
        Navigator.pop(context);
        //show error mesagge
        showErroMessage(e.code);
      }

    }

    //error mesagge to user
    void showErroMessage(String message){
      showDialog(
        context: context, 
        builder:(context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              message,
              style:const TextStyle(color: Colors.white),
              ),
              ), 
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 224, 224, 224),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),

                  //logo
                Image.asset('lib/images/Unigymcolor.png',
                height: 180,
                
                ),
          
                const SizedBox(height: 10),
          
                Text('¿Que esperas para unirte?',
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                ),
              ),
              
                const SizedBox(height: 25),
                
              //lets create account for you
              Text('Crea tu cuenta ahora',
              style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                ),
              ),
          
                const SizedBox(height: 25),
                
              //email texfield
              MyTextField(
                  controller: emailController,
                  hintText: 'Correo',
                  obscureText: false,
                ),
          
                const SizedBox(height: 20),
          
              //password texfield
              MyTextField(
                  controller: passwordController,
                  hintText: 'Contraseña',
                  obscureText: true,
                ),
          
                const SizedBox(height: 20),

              //confirm password texfield
              MyTextField(
                  controller: confirmpasswordController,
                  hintText: 'Confirmar Contraseña',
                  obscureText: true,
                ),
          

                const SizedBox(height: 20),
          
              //sing in bugtton
                MyButton(
                  text: "Registrarse",
                  onTap: singUserUp,
                ),
          
                const SizedBox(height: 20),
          
              //or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(children: [
                    Expanded(
                      child: Divider(
                    thickness: 0.5,
                    color: Colors.grey[400],
                  ),
                  ),
                
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'Iniciar sesión con',
                      style: TextStyle(color: Colors.grey[700]),
                      ),
                  ),
                  Expanded(
                    child: Divider(
                    thickness: 0.5,
                    color: Colors.grey[400],
                  ),
                  ),
                  ],
                  ),
                ),
          
              const SizedBox(height: 50),
          
              //google and apple button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
          
                  //google button
                  SquareTile(
                    onTap: () => AuthService().signInWithGoogle(),
                    imagePath: 'lib/images/Google.png'
                    ),
          
                  SizedBox(width: 25),
          
          
                  //apple button
                  
                ],
                ),
          
                const SizedBox(height: 25),
          
              //not a member?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('¿Ya tienes una cuenta?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      'Iniciar sesión',
                    style: TextStyle(
                      color: Color.fromARGB(255, 167, 3, 3), fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                ),
            ]),
          ),
        ),
      ),
    );
  }
}