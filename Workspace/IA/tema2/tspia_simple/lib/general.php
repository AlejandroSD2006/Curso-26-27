<?php

define("INFINITO",10e10);

function makeCabeceraHTML()
{
    $txt="<HTML>";
    $txt.="\n<HEAD>";
    $txt.="\n<META HTTP-EQUIV='X-UA-COMPATIBLE' CONTENT='IE=8;'>"; 
    $txt.="\n<META HTTP-EQUIV='Content-Type'    CONTENT='text/html;charset=ISO-8859-1' >"; 
    $txt.="\n<META HTTP-EQUIV='Cache-control'   CONTENT='no-cache'> ";
    $txt.="\n<META NAME='viewport'  CONTENT='width=device-width,initial-scale=1.0'  >"; 
    
    $txt.="\n<TITLE> Ejercicio TSP </TITLE>";
    //Hojas de estilos
    $txt.="\n<LINK rel='stylesheet' type='text/css' href='css/hoja.css'>"; 
    
    //Scripts en js
    
    $txt.="\n<script language='javascript'  src='js/mapa.js'></script>"; 
    $txt.="\n<script language='javascript'  src='js/ruta.js'></script>"; 
    
    $txt.="\n<script language='javascript'  src='js/codigo.js'></script>"; 
    $txt.="\n<script language='javascript'  src='js/solver.js'></script>"; 
    $txt.="\n<script language='javascript'  src='js/simulacion.js'></script>"; 

    $txt.="\n</HEAD>";
    $txt.="\n<BODY>\n"; 
    return $txt; 

}





function leerCSV($nomfichero)
{

 $df=fopen($nomfichero,"r");
 if(!$df)
 {
  die("Error al abrir archivo $nomfichero");
 }
 
 $mdatos=array();
 
 while(!feof($df)) // Mientras no lleguemos al final del archivo
 {
  $linea=fgets($df);
  if(strlen($linea)>5)  // Generamos vector asociado a la linea si tiene suficiente longitud 
  {
   $vtmp=explode(",",$linea);
   $mdatos[]=$vtmp;
  }
 }
 
 fclose($df);
 return $mdatos;
}





/*
* Calcula distancia en metros entre dos longitudes- latitudes
*/
function calcularDistancia($lat1, $lon1, $lat2, $lon2) 
{
    $radioTierra = 6371; // Radio medio de la Tierra en kilómetros

    $dLat = deg2rad($lat2 - $lat1);
    $dLon = deg2rad($lon2 - $lon1);

    $a = sin($dLat / 2) * sin($dLat / 2) +
         cos(deg2rad($lat1)) * cos(deg2rad($lat2)) *
         sin($dLon / 2) * sin($dLon / 2);

    $c = 2 * atan2(sqrt($a), sqrt(1 - $a));
    $distancia = $radioTierra * $c;

    return $distancia * 1000; // Retorna en metros

}






?>