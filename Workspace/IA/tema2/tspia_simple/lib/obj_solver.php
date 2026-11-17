<?php

 class Solver
 {  
  var $mimapa;
  var $nciudades;
  var $dimbase;
  var $dimhijos;
  var $vnodosbase;
  var $vnodoshijos;
  var $vciudades;
  var $debugrutas;
 
  function __construct($_nciudades,$numnodosbase,$numnodoshijos)
  {
   echo "\n Instanciando Solver . . . ";
  
   $this->mimapa=null;
   $this->nciudades=$_nciudades;
   $this->dimbase=$numnodosbase;
   $this->dimhijos=$numnodoshijos;
   $this->vnodosbase=array();
   $this->vnodoshijos=array();   
   $this->vciudades=array();
   $this->debugrutas=1;
   
   // Creamos los nodos base
   for($k=0;$k<$numnodosbase;$k++)
   {
    $this->vnodosbase[$k]=new Ruta($_nciudades);    
   }
   
   // Creamos los nodos hijos
   for($k=0;$k<$numnodoshijos;$k++)
   {
    $this->vnodoshijos[$k]=new Ruta($_nciudades);    
   }
          
   echo "\n OK Solver . . . ";
  }
  
  
  
  public function setMapaCiudades($objmapa)
  {
   $this->mimapa=$objmapa;
  }
  
  public function setDebugRutas($valor)
  {
   $this->debugrutas=$valor;
  }
  
  
  // Añade ciudad al final del vector
  public function activarCiudad($codigo)
  {
   $this->vciudades[]=$codigo;
   if(count($this->vciudades)>$this->nciudades)
   {
    die("Error, vector de ciudades desbordado");
   }
  }
  
  public function updateDistanciaRuta($objruta)
  {
   $total=0.0;  
   for($k=0;$k<$this->nciudades-1;$k++) 
   {
    $code1=$objruta->getCiudadPosicion($k);
    $code2=$objruta->getCiudadPosicion($k+1);
    $total+=$this->mimapa->getDistanciaCiudades($code1,$code2);
   }
   // Añadimos distancia de la ultima posicion a la 0 para cerrar la ruta
   $code1=$objruta->getCiudadPosicion(0);
   $code2=$objruta->getCiudadPosicion($this->nciudades-1);      
   $total+=$this->mimapa->getDistanciaCiudades($code1,$code2);
   $objruta->setGanancia($total);
  }
    
  private function getPosPeorNodoBase()
  {
   $maximo=-10000000;
   $pos=-1;
   for($k=0;$k<$this->dimbase;$k++)
   {
     if($this->vnodosbase[$k]->getGanancia()>$maximo) // Nodo actual peor
     {
      $maximo=$this->vnodosbase[$k]->getGanancia();
      $pos=$k;
     }
   }
   return $pos;  
  }  
  
  private function getPosMejorNodoHijo()
  {
    $minimo=10000000;
    $pos=-1;
    for($k=0;$k<$this->dimhijos;$k++)
    {
      if($this->vnodoshijos[$k]->getGanancia()<$minimo) // Nodo actual peor
      {
        $minimo=$this->vnodoshijos[$k]->getGanancia();
        $pos=$k;
      }
    }
    return $pos;  
  }  
        
 private function mostrarRutaBaseCiudades($pos)
 {
   $total=0.0;  
   $objruta=$this->vnodosbase[$pos];
   $cad="<br>";
   for($k=0;$k<$this->nciudades;$k++) 
   {
     $code=$objruta->getCiudadPosicion($k);
     $nombre=$this->mimapa->getNombreCiudad($code);
     $cad.=$nombre;
     $cad.=($k<$this->nciudades)? " -> ":" ";
   }
   $code=$objruta->getCiudadPosicion(0);
   $nombre=$this->mimapa->getNombreCiudad($code);
   $cad.=$nombre;
   echo $cad;
 }    
  
  
  
  
  
  /*
  *
  *  Bucle principal
  *
  */
  
  function run($itera_max,$nmut_iniciales,$nmut_hijos,$numeropromoitera)
  {
   
   if($this->mimapa==null)
   {
    die("\n <br>Error. Mapa de ciudades no encontrado");
   }
 
   echo "\n Ejecutando modelo . . . ";  
   $itera_actual=1;
   $dimbase=$this->dimbase;
   $dimhijos=$this->dimhijos;
   $nciudades=$this->nciudades;
   $nmutaciones=0;
   $mejor_km_itera=10e10;
   $mejor_nodo_base=-1;
   $pospeorbase=0;
   $posmejorhijo=0;
   
   if($numeropromoitera>=$dimhijos)
   {
        die("\n ERROR: Los hijos que promocionan ($numeropromoitera) no pueden ser superior a la poblacion de hijos ($dimhijos)");
   }
   
   // Inicializamos la poblacion base
   echo "\n<br> Inicializando poblacion base";
   for($k=0;$k<$dimbase;$k++) 
   {
     $minodo=$this->vnodosbase[$k];
     $minodo->copiarCiudadesDesdeVector($this->vciudades); // Copiamos las ciudades activadas a la ruta
     $mutaciones=rand(1,$nmut_iniciales);
     $minodo->mutar($mutaciones); // Barajamos el gen un numero aleatorio entre 5 y 100
     $minodo->mostrar("<br> Ruta base inicial [$k]:");   
   }

   while($itera_actual<=$itera_max)
   {
    if($this->debugrutas)
    {
     echo "<br><br>";
     echo "<br>===========================================================";
     echo "<br>             Iteracion $itera_actual                       ";
     echo "<br>===========================================================";
    }
    for($k=0;$k<$dimbase;$k++)
    {
     $minodobase=$this->vnodosbase[$k];
     $this->updateDistanciaRuta($minodobase); // Actualizo la distancia del nodo
     if($this->debugrutas)
     {
       $minodobase->mostrar("<br> BASE [$k]:");           
     }
     if($minodobase->getGanancia()<$mejor_km_itera)
     {
      $mejor_km_itera=$minodobase->getGanancia();
      $mejor_nodo_base=$k;      
     }
    }
    echo "<br>ITERA[$itera_actual] : MEJOR NODO BASE pos=$mejor_nodo_base Ganancia=$mejor_km_itera";
    // Genero los hijos, eligiendo aleatoriamente genes base y mutándolos
    for($k=0;$k<$dimhijos;$k++)
    {
     $minodohijo=$this->vnodoshijos[$k]; // Seleccio el hijo k-simo
     $keybase=rand(0,$dimbase-1); // Selecciono al padre de forma aleatoria
     $minodobase=$this->vnodosbase[$keybase];
     $minodohijo->clonar($minodobase); // Copio la ruta del padre al hijo
     $nmutaciones=rand(1,$nmut_hijos);
     $minodohijo->mutar($nmutaciones);
     $this->updateDistanciaRuta($minodohijo); // Actualizo la distancia del nodo              
     if($this->debugrutas)
     {
      $minodobase->mostrar("<br> HIJO [$k]:");           
     }
    }

    if($this->debugrutas)
    {    
      echo "<br><br> Pasamos a reemplazar los $numeropromoitera peores bases con los mejores hijos: <br>";
    }
    // Paso a hacer el proceso de seleccion. Selecciono los k mejores hijos y reemplazo los k base peores
    for($k=0;$k<$numeropromoitera;$k++)
    {
      $pospeorbase=$this->getPosPeorNodoBase();
      $posmejorhijo=$this->getPosMejorNodoHijo();
      if($this->debugrutas)
      {      
        $ganbase=$this->vnodosbase[$pospeorbase]->getGanancia();
	$ganhijo=$this->vnodoshijos[$posmejorhijo]->getGanancia();
        echo "<br> Reemplazando padre pos $pospeorbase (G=$ganbase) con hijo en pos $posmejorhijo (G=$ganhijo)";
      }
      $minodobase=$this->vnodosbase[$pospeorbase];
      $minodohijo=$this->vnodoshijos[$posmejorhijo]; 
      $minodobase->clonar($minodohijo); // Copio el mejor hijo en el mejor padre.
      // Una vez copiado, he de "desechar" el hijo para que no se repita en la elección, poniendo coste infinito.
      $minodohijo->setGanancia(INFINITO);        
    }
           
    $itera_actual++;         
   }
   echo "<br><br>======================================================= ";
   echo "Poblacion base final: ";
   for($k=0;$k<$dimbase;$k++)
   {
       $minodobase=$this->vnodosbase[$k];
       $this->updateDistanciaRuta($minodobase); // Actualizo la distancia del nodo
       if($this->debugrutas)
       {
         $minodobase->mostrar("<br> BASE [$k]:");           
       }
       if($minodobase->getGanancia()<$mejor_km_itera)
       {
        $mejor_km_itera=$minodobase->getGanancia();
        $mejor_nodo_base=$k;      
       }
  }
  echo "<br><br> MEJOR NODO ENCONTRADO pos=$mejor_nodo_base Ganancia=$mejor_km_itera <br><br>";
  $this->vnodosbase[$mejor_nodo_base]->mostrar(" GANADOR:");
  $this->mostrarRutaBaseCiudades($mejor_nodo_base);
  
  
   
   
  }
 
 
 }


?>