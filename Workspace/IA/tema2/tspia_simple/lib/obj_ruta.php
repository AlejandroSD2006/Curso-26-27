<?php

class Ruta
{
 var $dim; // Numero de ciudades
 var $ganancia; // Ganancia
 var $vdatos;  // Vector con los codigos de ciudades
 
 function __construct($midim)
 {  
  
  $this->dim=$midim;  
  $this->ganancia=0.0;
  $this->vdatos=array();
  for($k=0;$k<$midim;$k++)
  {
    $this->vdatos[$k]=-1; // Inicializamos a valor -1
  }  
 }
 
 function setDim($num)
 {
  $this->dim=$num;
 }
  
 
 function clonar($rutabase)
  {
   $dim=$this->dim;
   $dim2=$rutabase->dim;
   if($dim!=$dim2)
   {
    die(" Error en ruta al clonar ruta: Dimensiones distintas $dim vs $dim2");
   }
   for($k=0;$k<$dim;$k++)
   {
     $this->vdatos[$k]=$rutabase->vdatos[$k];
   }  
   $this->ganancia=$rutabase->ganancia;
  }
  
 function setGanancia($newgan)
 {
  $this->ganancia=$newgan;
 } 
 
 function getGanancia()
 {
  return $this->ganancia;
 }
 
 function getCiudadPosicion($pos)
 {
  return $this->vdatos[$pos];
 }
 
 function setCiudadPos($pos,$val)
 {
  $this->vdatos[$pos]=$val;
 }
 
 function copiarCiudadesDesdeVector($v)
 {
   $dim=$this->dim;
   if(count($v)!=$dim)
   {
    die("\n Error al copiar ciudades desde vector. dimensiones distintas");
   }
      
   for($k=0;$k<$dim;$k++)
    {
      $this->vdatos[$k]=$v[$k];
    }  
 }
 
 
 
 function mostrar($txt)
 {
  $cad=$txt;
  for($k=0;$k<$this->dim;$k++)
  {
    $cad.=sprintf("%02d ",$this->vdatos[$k]);    
  } 
  $cad.=sprintf(" -> %5.3f km  ",$this->ganancia);    
  echo $cad;
 }
     
       
 function mutar($ncambios)
 {
  $pos1=0;
  $pos2=0;
  $dim=$this->dim;
  for($k=0;$k<$ncambios;$k++)
  {
   $pos1=rand(0,$dim-1);
   $pos2=rand(0,$dim-1);
    $tmp=$this->vdatos[$pos1];
    $this->vdatos[$pos1]=$this->vdatos[$pos2];
    $this->vdatos[$pos2]=$tmp;
  } 
 }
 
}
 


?>