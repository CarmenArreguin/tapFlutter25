import 'package:flutter/material.dart';
import 'package:tap2025/models/popular_model.dart';
import 'package:tap2025/network/api_popular.dart';

class PopularScreen extends StatefulWidget {
  const PopularScreen({super.key});

  @override
  State<PopularScreen> createState() => _PopularScreenState();
}

class _PopularScreenState extends State<PopularScreen> {

  ApiPopular? apiPopular;

  @override
  void initState() {
    super.initState();
    apiPopular = ApiPopular();
    apiPopular!.getPopularMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      //Si vemos un Builder significa que siempre va haber un widget que tenemos que regresar. Es decir, una pantalla visual.
      body: FutureBuilder(
        future: apiPopular!.getPopularMovies(),
        builder: (context, snapshot) {
          //Si sí tiene datos entonces va a existir.
          if(snapshot.hasData){
            //List View normal es porque sabemos cuantos elementos va haber en la lista.
            //Se usa un ListView.builder cuando no sabemos cuantos elementos habrá.
            return ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 10),
              separatorBuilder: (context, index) => SizedBox(height: 10,),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index){
                //return Text(snapshot.data![index].title);
                return ItemPopular(snapshot.data![index]);
              },
            );
          } else {
            //Uno de los errores que pasa: puede ser que estaba ejecutandose y perdió la conexión, entonces marcará error.
            if(snapshot.hasError){
              return Center(child: Text(snapshot.error.toString()),);
            } else {
              return Center(child: CircularProgressIndicator(),);
            }
          }
        },
      ),
    );
  }

  Widget ItemPopular(PopularModel popular){
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      //Contenedor multiple, es una línea.
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          FadeInImage(
            placeholder: AssetImage('assets/loading.gif'), 
            image: NetworkImage(popular.backdropPath)
          ),
          Container(
            height: 70,
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: ListTile(
              //Método anónimo.
              onTap: ()=>Navigator.pushNamed(context, '/detail', arguments: popular),
              title: Text(popular.title, style: TextStyle(color: Colors.white),),
              trailing: Icon(Icons.chevron_right, size: 30,),
            )
          )
        ],
      ),
    );
  }
}