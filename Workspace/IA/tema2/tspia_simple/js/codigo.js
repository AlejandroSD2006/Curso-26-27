const INFINITO=10000000;
const NMAXCITY=60;
var stmp=new String();
var MapaTSP=new Mapa(NMAXCITY);


function $(o) 
{
	return document.getElementById(o);
}


// Devuelve entero aleatorio entre 0 y valmax-1
function getEnteroAleatorio(valmax) 
{
  return Math.floor(Math.random() * valmax);
}



function registrarCiudad(code,nombre,latitud,longitud)
{
 var miciudad;
 miciudad=new Ciudad(code,nombre,latitud,longitud);
 MapaTSP.addCiudad(miciudad);
 console.log("Registrada ciudad "+nombre+" codigo="+code); 
}



function toggleCiudad(codciudad)
{
 var midiv,nomdiv;
 var micb,nomcb;
 nomdiv="div_"+codciudad;
 nomcb="cb_"+codciudad;
 midiv=$(nomdiv);
 micb=$(nomcb);
 if(midiv.className=="divcity") // Normal, la seleccionamos
 {
  midiv.className="divcitysel";
  micb.checked=1;
  VCIUDADES[codciudad][3]=1; // Marcamos la ciudad como candidata para simular
 }
 else
 {
  midiv.className="divcity";
  micb.checked=0;
  VCIUDADES[codciudad][3]=0; // Desmarcamos la ciudad como candidata para simular
 }
}



function copiarCiudadesSeleccionadas()
{
 var vtmp;
 for(const codigo in VCIUDADES)
 {   
   vtmp=VCIUDADES[codigo];
   if(vtmp[3]==1) // Se selecciono la ciudad, añadimos el codigo de ciudad a VCSEL
   {
    VCSEL.push(codigo);
    console.log(" Ciudad "+vtmp[0]+" copiada ");
   }  
 }

}






