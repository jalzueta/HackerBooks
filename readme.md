#HackBooks - Javi Alzueta

Práctica del curso de Funddamentos iOS - KeepCoding

**Métodos *isKindOfClass:* y *isMemberOfClass:*:**<br/>
Ambos métodos se utilizan para saber si un objeto pertenece a una clase y devuelven un booleano a *YES* en caso afirmativo.<br/>
La diferencia entre ambos es que *isKindOfClass:* devuelve *YES* también si el objeto pertenece a una subclase de aquella con la que se está comparando y sin embargo *isMemberOfClass:*, en ese caso devuelve *NO*.

**Sobre el *Modelo*:**<br/>
Dónde he decidido guardar tanto el *JSON* como las *imágenes de portada* y los *PDFs*:<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- **JSON**: carpeta *Documents*.<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- **Imágenes**: carpeta *Documents*.<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- **PDFs**: carpeta *Documents*.<br/>
He elegido la carpeta *Documents* del Sandbox de la App porque no quiero que desaparezcen del Sandbox bajo ningún concepto. 