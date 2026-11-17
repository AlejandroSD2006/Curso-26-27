<?php

class MapaCiudades
{
 var $numciudades;
 var $mdata;
 var $mdis;
 
 function __construct($nomficherociudades,$nomficherodis)
 {
  echo "<br> Instanciando mapa ciudades ";
  $this->leerCiudades($nomficherociudades);  
  $this->leerDistancias($nomficherodis);  
  echo "<br> Ciudades y distancias cargadas";    
 }
 
 
 private function leerCiudades($nomfichero)
 {     
  
  $df=fopen($nomfichero,"r");
  if(!$df)
  {
    die("Error al abrir archivo $nomfichero");
  }
 
  $this->mdata=array();
  $this->numciudades=0;
  while(!feof($df)) // Mientras no lleguemos al final del archivo
  {
   $linea=fgets($df);   
   if(strlen($linea)>5)  // Generamos vector asociado a la linea si tiene suficiente longitud 
   {
    $vtmp=explode(",",$linea);  // Formato: codigo, nombre, latitud, longitud
    $codigo=(int)$vtmp[0];
    $nombre=$vtmp[1];
    $latitud=$vtmp[2];
    $longitud=$vtmp[3];
    $this->mdata[$codigo]=array($nombre,$latitud,$longitud);  
    $this->numciudades++;
   }
  } 
  
  fclose($df);  
 }
 
 
 private function leerDistancias($nomfichero)
 {
  $k=0;
  
  $df=fopen($nomfichero,"r");
  if(!$df)
  {
    die("Error al abrir archivo $nomfichero");
  }
 
  $this->mdis=array();  
  while(!feof($df)) // Mientras no lleguemos al final del archivo
  {
   $linea=fgets($df);
   if(strlen($linea)>3)  // Generamos vector asociado a la linea si tiene suficiente longitud 
   {
    $vtmp=explode(",",$linea);  // Formato: codigo, nombre, latitud, longitud
    $c1=$vtmp[0];
    $c2=$vtmp[1];
    $dis=$vtmp[2];
    $keya=$c1."-".$c2;    
    $keyb=$c2."-".$c1;    
    $this->mdis[$keya]=$dis;
    $this->mdis[$keyb]=$dis;
    $k++;
   }
  }
  fclose($df);    
 }

 public function getNombreCiudad($codigo)
 {
  $sol="---";
  if(array_key_exists($codigo,$this->mdata))
  {
   $sol=$this->mdata[$codigo][0];
  }
  return $sol;
 } 
 
 
 
 
 public function getDistanciaCiudades($code1,$code2)
 {
  $sol=1000000;
  $mikey=sprintf("%02d-%02d",$code1,$code2); // Generamos el key
  if(array_key_exists($mikey,$this->mdis))
  {
   $sol=$this->mdis[$mikey];
  }
  return $sol; 
 }


}


?>