#HackBooks - Javi Alzueta

Práctica del curso de Funddamentos iOS - KeepCoding

##Parte Obligatoria (*rama master*)

####Métodos *isKindOfClass:* y *isMemberOfClass:*:<br/>
Ambos métodos se utilizan para saber si un objeto pertenece a una clase y devuelven un booleano a *YES* en caso afirmativo.<br/>
La diferencia entre ambos es que *isKindOfClass:* devuelve *YES* también si el objeto pertenece a una subclase de aquella con la que se está comparando y sin embargo *isMemberOfClass:*, en ese caso devuelve *NO*.

####Sobre el *Modelo*:<br/>
Dónde he decidido guardar tanto el *JSON* como las *imágenes de portada* y los *PDFs*:<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- **JSON**: carpeta *Documents*.<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- **Imágenes**: carpeta *Documents*.<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- **PDFs**: carpeta *Documents*.<br/>
He elegido la carpeta *Documents* del Sandbox de la App porque no quiero que desaparezcen del Sandbox bajo ningún concepto. 

####Sobre la *Tabla de Libros*:<br/>
He organizado el modelo *library* de la siguiente manera:<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Una *lista* con todos los libros -> **booksArray**<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Una *lista* con todos los tags -> **tagsArray**<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Un *diccionario* en el que almaceno para cada *tag* una lista de los libros que tienen ese *tag*. De esta manera, accedo a los libros de cada sección de la tabla a través del *tag* correspondiente mediante *"getObjectForKey:"* -> **booksForTagDict**<br/>
<br/>
Así, cuando se pulsa el botón favorito para uno de los libros, lo que hago es añadir/eliminar el tag *"Favorite"* de su lista de tags y actualizar ese libro en la *library*.<br/>
<br/>
Cuando la App pasa a segundo plano, en el método **applicationDidEnterBackground** del *AppDelegate*, convierto el modelo del *FLGLibraryTableViewController* (es decir *library*) a un JSON y actualizo en el Sandbox el fichero con el nuevo JSON obtenido después del uso de la App.<br/>
<br/>
Se podría guardar constantemente el modelo *library* en memoria del dispositivo, a cada cambio (descarga de un nuevo PDF, modificación del estado de *"favorito"* de uno de los libros...), pero estaríamos accediendo constantemente al disco de forma innecesaria. <br/>
He preferido esperar al momento en el que la App pasa a segundo plano, como paso previo al cierre de la misma, para **guardar el estado del objeto library** en memoria ya que no es necesario hacerlo, puesto que se puede ir actualizando el modelo de *FLGLibraryTableViewController*, ya sea a través de *protocolos de delegado* o de envío de *notificaciones* desde el resto de controllers.<br/>
<br/>
Para el **envío de información desde el FLGBookViewController a FLGLibraryTableViewController**, he optado por utilizar **Notificaciones**.<br/>
Se podría haber utilizado un protocolo de delegado, pero he elegido las notificaciones por el siguiente motivo: Para el envío de información entre el *FLGLibraryTableViewController* y el *FLGBookViewController* (es decir, en sentido inverso) he optado por utilizar un protocolo de delegado sobre todo para simplificar la *universalización* de la App. Así, he establecido a *FLGBookViewController* como delegado de *FLGLibraryTableViewController*, por lo que no he podido hacer a *FLGLibraryTableViewController* delegado de *FLGBookViewController*, estableciendo ese *"cruce de delegados"*, ya que se producía un *"import cíclico de sus ficheros de cabecera"*.<br/>
Podía haber sacado las declaraciones de los protocolos a una clase aparte, pero me ha parecido más claro hacerlo así.<br/>
<br/>
Sobre la **actualización de la tabla** mediante *"reloadData"*, , no creo que sea una *"aberración"* desde el punto de vista del rendimiento, ya que se van a recargar unas pocas celdas (unas pocas más de las que están en la vista) y los recursos de las celdas ya se encuentran alojados en el sandbox de la App.<br/>
Si la recarga de la tabla supusiera un consumo alto de datos de conexión o de recursos del dispositivo, por ejemplo porque se descargan siempre las imágenes desde servidor, la cosa cambiaría.</br>
En ese caso se podría optar por recargar únicamente la celda del libro que ha cambiado. Para recargar los datos de celdas concretas existe el método de las UITableView *"reloadRowsAtIndexPaths"*.<br/>
Para el caso que nos ocupa, tendríamos que tener cierto cuidado, ya que abría que recargar todas las celdas que contienen al libro cuyo estado ha sido modificado (puede existir en varias secciones diferentes). Además, al hacer/deshacer un libro como favorito nos estaría cambiando el número de rows de la seccion favoritos e incluso nos podrían estar cambiando el número de secciones (en el caso de que eliminemos la seccion favoritos si no hay libros en ella).

####Sobre el *Controlador de PDF*:<br/>
Para actualizar el PDF que se está mostrando cualdo el usuario pulsa sobre un elemento de *FLGLibraryTableViewController*, utilizo notificaciones. *FLGLibraryTableViewController* envía una notificación de cambio de libro y *FLGPdfViewController* la recibe porque se suscribe a dicha notificación.


##Extras (*rama extra*)

####Funcionalidades *extra* antes de subir al App Store:
1. Se me ocurre que se le podría añadir un indicador, tanto en la lista de libros como en el detalle del libro que le dijera al usuario si el libro ya ha sido descargado y está en memoria o si se debe descargar antes de poder abrirlo.
2. Se podría comprobar si el dispositivo tiene conexión de datos para *deshabilitar* las celdas de los documentos que no se encuentren en memoria. Así el usuario sabría que esos documentos no estána accesibles, aunque si le demos paso a ver el detalle del documento.
3. Se podría añadir la capacidad de añadir/eliminar libros de la sección *Favorites* desde la propia tabla de libros, sin necesidad de tener que abrir la vista de detlle del libro (versión iPhone).
4. Vendría muy bien que la App tuviera indicadores del estado de las descargas y que estas se hicieran en segundo plano.
5. Creo que sería conveniente que el listado de libros/documentos en servidor pudiera ir variando, de manera que se realizara la consulta al servidor cada vez que se iniciara la App y se descargaran las modificaciones.
6. Sería un buen gestor de documentación para una empresa si tuviese una gestión de usuarios con diferentes perfiles para que, en función del perfil, se tuviera acceso a unos PDFs o a otros.
7. Se podría ampliar la App hacia la gestión de diferentes tipos de recursos, no solo PDFs. Se podrían añadir imágenes, videos, Epubs...

Creo que si completaramos la App con todas las funcionalidades de los puntos anteriores, podría ser vendible a empresas para la gestión interna de documentación, a escuelas/colegios/universidades para la distribución de material docente, a profesionales (abogados, medicos...) para el envío de informes, documentos a clientes...

De todos estos puntos, **he podido abordar el punto 1, el punto 3 y la realización de las descargas en segundo plano con GCD correspondiente al punto 4**.</br>
He intentado resolver la visualización de los PDFs descargados con vfrReader, pero no he sido capaz de visualizar PDFs descargados, solo PDFs que se encuentran en el *MainBundle*.

Seguiré intentando hacer uso de la librería vfrReader...





