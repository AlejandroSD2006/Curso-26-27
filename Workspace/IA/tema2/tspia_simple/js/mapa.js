function Ciudad(codigo,label,longitud,latitud)
{
 this.codigo=codigo;
 this.label=label;
 this.lon=longitud;
 this.lat=latitud; 
}



function calcularDistanciaCiudades(lat1, lon1, lat2, lon2) 
{
    const RADIO_TIERRA_KM = 6371; // Radio medio de la Tierra en kilómetros

    // Convertir grados a radianes
    const dLat = (lat2 - lat1) * Math.PI / 180;
    const dLon = (lon2 - lon1) * Math.PI / 180;

    // Convertir las latitudes de origen y destino a radianes
    const lat1Rad = lat1 * Math.PI / 180;
    const lat2Rad = lat2 * Math.PI / 180;

    // Aplicar la fórmula de Haversine
    const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
              Math.sin(dLon / 2) * Math.sin(dLon / 2) * Math.cos(lat1Rad) * Math.cos(lat2Rad);
              
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

    // Distancia final en kilómetros
    return RADIO_TIERRA_KM * c;
}










function Mapa(nmaxcity)
{
 console.log("Instanciando mapa");
 this.ncity=0;
 this.nmaxcity=nmaxcity;
 this.vciudades=new Array(nmaxcity); 
 this.vdistancias=new Array(nmaxcity);

 

 this.addCiudad=function(objciudad) 
 {
  console.log("Añadiendo obj ciudad . .. ");
  var pos=vciudades.length;
  this.vciudades[pos]=objciudad;
  this.ncity++;
 }
 
 
 this.calcularMatrizDistancias=function()
 {
  var i,j;
  var dis,c1,c2;
  console.log("Calculando matriz de distancias");
  for(i=0;i<ncity;i++) //
  {
   this.vdistancias[i]=new Array(ncity);
   for(j=i+1;j<ncity;j++)
   {
    console.log("Calculando distancia ciudad "+i+" a "+j);
    c1=this.vciudades[i];
    c2=this.vciudades[j];
    dis=calcularDistanciaCiudades(c1.lat,c1.lon,c2.lat,c2.lon);
    this.vdistancias[i][j]=dis;
    this.vdistancias[j][i]=dis;
    console.log(" -> "+dis);       
   }   
  }
 }

 
 
}

