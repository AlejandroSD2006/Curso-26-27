
function Ruta(dimruta)
{
 console.log("Instanciando objeto ruta dim="+dimruta);
 this.dim=dimruta;
 this.gain=-INFINITO;
 this.vdata=new Array(dimruta);
 this.vdata.fill(-1);
 
 this.setCiudad=function(pos,codigo)
 {
  this.vdata[pos]=codigo; 
 }
 
 this.getCiudad=function(pos)
 {
  return this.vdata[pos];
 }
 
 this.updateGain=function(newgain)
 {
  this.gain=newgain;
 }
 
 // Intercambiamos dos posiciones aleatorias las veces indicadas como parametro
 this.barajar=function(numveces)
 {
  var k=0;
  var pos1,pos2,valtmp;
  while(k<numveces)
  {
   pos1=getEnteroAleatorio(this.dim);
   pos2=getEnteroAleatroio(this.dim);
   if(pos1!=pos) // Intercambiamos
   {
    valtmp=this.vdata[pos1];
    this.vdata[pos1]=this.vdata[pos2];
    this.vdata[pos2]=valtmp;
    k++;
   }  
  }
 }
 
 this.mostrar=function(texto)
 {
  var k;
  console.log(texto);
  for(k=0;k<this.dim;k++)
  {
   console.log(k +"->"+this.vdata[k]);
  } 
 }
 
 
}

