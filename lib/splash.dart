import 'package:cuaca/home.dart';
import 'package:flutter/material.dart';


class splash extends StatelessWidget {
  const splash({super.key});

  @override
  Widget build(BuildContext context) {
  
    Size size = MediaQuery.of(context).size;
   return Scaffold(
      body: Container(
width: size.width,
height: size.height,

color: Colors.blueGrey,

child: Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Image.asset("assets/rain.png"),
      const SizedBox(height: 30,),
      GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
        },
        child: Container(
          height: 50,
          width: size.width *0.7 ,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: const Center(
            child: Text("get started", style: TextStyle(color: Colors.white, fontSize: 17),),
          ),
        ),
      )
    ],
  ),
),
      ),
      );
    
  }
}