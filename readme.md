#HackBooks - Javi Alzueta

Práctica del curso de Funddamentos iOS - KeepCoding


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
Además **he implementado la visualización de los PDFs descargados con vfrReader**.






