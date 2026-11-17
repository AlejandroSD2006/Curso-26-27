<?php

 include_once("lib/general.php");
 include_once("lib/obj_mapa.php");
 include_once("lib/obj_ruta.php");
 include_once("lib/obj_solver.php");

 $cad=makeCabeceraHTML();
 
 
 
 
 /*
 *  AJUSTE DE LOS PARAMETROS DEL SIMULADOR"
 */
 
 $numitera=1500;  // Numero de iteraciones/epocas del simulador
 $tambase=200;  // Poblacion de los "padres"
 $tamhijos=200;   // Hijos que se generan en cada iteracion/epoca
 $promociones=(int)$tambase/10;   // Cuantos padres se sustituyen por los mejores hijos en cada epoca/iteracion , debe ser inferer al n� de hijos
 
 
 $nmutaciones_init=200;  // Numero de mutaciones m�ximas al inicializar los padres
 $nmutaciones_hijos=5;  // Numero de mutaciones maximas para generar un hijo
 
  
  
  

 // Instanciamos la clase MAPA, con las ciudades y distancias entre ciudades
 $mapa=new MapaCiudades("ciudades.csv","distancias.csv");
  
 
 // Vector con codigos de las ciudades a visitar
 $vciudades=array(8,11,14,18,21,23,48);
 $numciudades=count($vciudades);
 
 // Instanciamos la clase Solver
 
 $misolver=new Solver($numciudades,$tambase,$tamhijos);
 $misolver->setMapaCiudades($mapa);
 
 // Activamos en el simulador las ciudades del vector de arriba
 for($k=0;$k<$numciudades;$k++)
 {
  $code=$vciudades[$k];
  $nomciudad=$mapa->getNombreCiudad($code);  
  echo "\n<br> Activando ciudad ( $code ) $nomciudad";
  $misolver->activarCiudad($code);
 }


  // Desactivar el debug de rutas tras comprobar que va todo ok
 $misolver->setDebugRutas(0);
 
 // Ejecutamos el simulador
 
 $misolver->run($numitera,$nmutaciones_init,$nmutaciones_hijos,$promociones);
 
 die();
 


?>