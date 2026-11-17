const NMAXCITY=60 // Numero maximo de ciudades
/*
* Objeto ruta, se le pasa_
*
*  -num ciudades
*  -numero rutas iniciales
*  -numrutas generadas en cada epoca/iteracion del algoritmo
*  
*/

function Solver(dimruta,nrbase,nrgen)
{
 var k,j;
 this.ncity=dimruta; // Numero ciudades de la ruta
 this.nrbase=nrbase;
 this.nrgen=nrgen;
 this.vciudades=new Array(dimruta);
 this.numciudades=dimruta;
 this.vrutasbase= new Array(nrbase);
 this.vrutasgen= new Array(nrhijo);
 this.mdistancias=new Array(NMAXCITY);
 
  
 // Inicializamos array de rutas base
 for(k=0;k<nrbase;k++)
 {
  this.vrutasbase[k]=new Ruta(dimruta);
 }
 
 // Inicializamos array de rutas hijas
 for(k=0;k<nrgen;k++)
  {
   this.vrutasgen[k]=new Ruta(dimruta);
  }
  
 // Inicializamos matriz de conectividad de las ciudades
 for(k=0;k<NMAXCITY;k++)
 {
  this.mdistancias[k]=new Array(NMAXCITY);
  for(j=0;j<NMAXCITY;j++)
      this.mdistancias[k][j]=INIFINITO; // Distancia infinita entre ciudad k->j
 }
  

 // Añade codigo de ciudad a la ruta del TSP
 this.addCiudad=function(codigo)
 {
  var posciudad;
  posciudad=this.vciudades.length;
  this.vciudades[posciudad]=codigo; 
 }
 
 // Una vez añadidas ciudades, calculamos la matriz de conectividad entre ciudades
 this.calcularMatrizDistancias()
 {
  var i,j;
  var midis=100;
  var codigo1,codigo2; 
  for(i=0;i<this.ncity;i++)
  {
   codigo1=this.vciudades[i];
   for(j=0;j<this.ncity;j++)
   {    
    codigo2=this.vciudades[j];
    this.mdistancias[k][i]=midis;
   }
  }
 
 }
 
 
 

}

