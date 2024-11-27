import 'package:flutter/material.dart';

class TermsConditionScreen extends StatelessWidget {
  const TermsConditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Función para regresar vista
    _onBack() {
      Navigator.pop(context);
      return true;
    }

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // llamo a la funcion de regresar
              _onBack();
            },
          ),
          title: GestureDetector(
            onTap: () {
              // llamo a la funcion de regresar
              _onBack();
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Términos y condiciones',
              ),
            ),
          ),
        ),
        body:  SingleChildScrollView(
          child:  Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 30,
            ),
            child:const  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Términos y Condiciones entre Chinchin y sus usuarios.',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'A continuación se describen los términos y condiciones que rigen el uso de la página Web de SOLUCIONES FINANCIERAS Chinchin Business, C. A., identificada con el número de Registro de Información Fiscal (R.I.F.) J-413198282, Sociedad Mercantil constituida y domiciliada en Caracas, inscrita por ante el Registro Mercantil Cuarto de la Circunscripción Judicial del Distrito Federal y Estado Miranda, en lo sucesivo denominada Chinchin, sitio de Internet bajo el dominio "http://www.pagochinchin.com". En esta página Web se encuentra una descripción de los distintos productos y servicios que ofrece Chinchin al público en general, y su uso está sujeto al cumplimiento por parte del usuario de los términos y condiciones que se indican a continuación, así como de las condiciones particulares que puedan complementarlas, en relación con algunos de los servicios y contenidos de esta página Web. El usuario se obliga a leer cuidadosamente esta sección, así como las política de uso que se publican en esta página Web, antes de continuar su recorrido en este sitio y de hacerlo, se entenderá que conoce estas condiciones generales, que está de acuerdo con el contenido y los términos de las mismas y que las acepta expresamente.',
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Términos y limitaciones de uso',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Esta página Web es sólo para uso personal y privado del usuario.',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                    'Los contenidos de esta página Web, a saber: textos, imágenes, lemas, archivos de audio y de video, botones, archivos de software, combinaciones de colores, así como la estructura, selección, ordenación y presentación de sus contenidos, se encuentran protegidos por las normas sobre Derecho de Autor, quedando prohibida su reproducción, distribución, comunicación pública y transformación, sin la autorización previa y por escrito de Chinchin; por otra parte, las marcas comerciales, logotipos y marcas de servicio, que aparecen en esta página Web, son propiedad de Chinchin y/o de terceras personas, con las cuales Chinchin ha suscrito convenios que le permiten su uso. Los usuarios tienen prohibido usar dichas marcas para cualquier fin incluyendo, sin limitar, su uso como distintivo en otras páginas o sitios en la red internacional de Internet, a menos que se cuente con el consentimiento previo y por escrito de Chinchin o de dichos terceros propietarios de las marcas.'),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Los equipos utilizados por el usuario para acceder a ésta página Web, son de su exclusiva responsabilidad; dichos equipos deberán cumplir con los requerimientos, indicaciones y especificaciones técnicas recomendadas por Chinchin para el acceso a esta página. Chinchin no será responsable por el buen funcionamiento, idoneidad, capacidad y compatibilidad de dichos equipos con esta página Web.',
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'CHINCHIN no garantiza de forma alguna el servicio ininterrumpido o libre de error a través de esta página Web.',
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Los productos y servicios incluidos en esta página Web, están dirigidos a los usuarios domiciliados en la República Bolivariana de Venezuela; en consecuencia, el envío de solicitudes de contratación de cualquiera de los productos y servicios incluidos en la presente Web por parte del usuario que no cumpla con el requisito antes indicado, no será procesada. El usuario queda informado y acepta, que la remisión de una solicitud de contratación de cualquiera de los productos y servicios incluidos en la presente Web, no supone el establecimiento de una relación comercial con Chinchin, hasta tanto dicho usuario no cumpla con todos los requisitos establecidos por Chinchin en los contratos que regulan dichos productos y servicios, todo ello de conformidad con lo establecido en la legislación vigente.',
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Links con otras páginas web',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Esta página Web permite el enlace con otros sitios o páginas Web operadas por personas naturales o jurídicas distintas a Chinchin; tales vínculos han sido suministrados única y exclusivamente para la comodidad de los usuarios. Queda expresamente entendido que Chinchin no tiene el derecho a modificar, actualizar o controlar el contenido de un sitio enlazado desde su página Web. El usuario conviene y acepta que dichos sitios enlazados pueden contener disposiciones que difieran de las presentes condiciones generales; en este sentido, Chinchin no será responsable por dichas disposiciones y expresamente se libera y desconoce todo tipo de responsabilidad que se relacione con éstas. El hecho de que Chinchin facilite el enlace con otras páginas Web, no constituye una autorización, cesión, patrocinio o afiliación con respecto a dichos sitios, o con respecto a sus propietarios, titulares o proveedores. Queda expresamente entendido, que el acceso a dichas páginas será por cuenta y riesgo del usuario, quien deberá evaluar la veracidad, exactitud, integridad o utilidad de cualquier opinión, información, asesoría y contenidos disponibles a través del sitio enlazado. Chinchin prohíbe establecer enlaces no autorizados a su página Web; por lo cual, se reserva el derecho de desconectar dichos enlaces no autorizados.',
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Compatibilidad de programas y navegadores',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'El usuario acepta y reconoce que la presente página ha sido diseñada para funcionar sólo con algunos programas y navegadores actualizados, y que su funcionamiento puede ser mejor con unos navegadores que con otros. En tal sentido, el usuario declara y acepta no tener derecho a efectuar reclamo alguno por accesibilidad desde computadores que no posean el software adecuado, o por el mejor o peor desempeño de su navegador dentro de esta página.',
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Exención de responsabilidad de CHINCHIN por los contenidos publicados en la página web',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Los contenidos publicados en esta página Web, pueden contener inexactitudes o imprecisiones, por lo que Chinchin se libera y desconoce cualquier tipo de responsabilidad sobre el particular; igualmente, Chinchin no garantiza que los contenidos publicados en el sitio corresponden a información completa o actualizada, por lo cual, el usuario se compromete a verificar con Chinchin o con el banco del cual es cliente afiliado, la información que allí se expresa, a través de cualquiera de sus agencias y sucursales. Ninguna información publicada en la página Web, constituye una recomendación, opinión favorable o sugerencia para que se contraten los productos y/o servicios allí descritos. Algunas de las informaciones publicadas en la página, contienen declaraciones a futuro que están sujetas a riesgos y cambios; en virtud de ello, se advierte a los usuarios que tales apreciaciones tienen validez únicamente con efectos a la fecha en la que se hacen. Queda expresamente entendido que Chinchin no asumirá obligación alguna de actualizar, modificar o adaptar dichas declaraciones o apreciaciones.',
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'CHINCHIN no asume ninguna responsabilidad por los contenidos suministrados por los usuarios y se reserva el derecho de retirar aquellos que considere ofensivos, injuriosos, difamatorios, obscenos, discriminatorios, que promuevan conductas delictuosas o que den origen a disturbios de naturaleza civil o que en general transgredan la legislación vigente. A los efectos de preservar los posibles derechos de propiedad industrial o de derecho de autor de cualquier persona que considere que se ha producido una violación de sus legítimos derechos por la publicación de un determinado contenido en la página Web, ésta deberá notificar dicha circunstancia a Chinchin, aportando la documentación que demuestre la existencia de dicho derecho.',
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Modificación de los contenidos publicados en la página web',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'CHINCHIN podrá modificar los contenidos de la página Web en cualquier momento y sin necesidad de previo aviso sobre el particular; igualmente, Chinchin podrá realizar mejoras o cambios a su página Web, sin necesidad de consentimiento previo de los usuarios, y sin que ello implique necesariamente una modificación de las presentes condiciones generales.',
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Acceso a las áreas protegidas mediante claves de acceso',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'El acceso y/o el uso de secciones de esta página Web, protegidas mediante el uso claves de acceso, está restringida únicamente a los usuarios autorizados por Chinchin a tal efecto, en virtud de la afiliación por parte de dichos usuarios a los servicios cuyo uso se limitó a través de este mecanismo. Las personas no autorizadas que intenten acceder a dichas secciones, quedarán sujetas a las sanciones previstas en la legislación vigente, sin perjuicio de la posibilidad de que Chinchin les bloquee el acceso a dicha página.',
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Comisiones por el uso de los servicios disponibles en la página web',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'El acceso a la página Web de Chinchin está exento del pago de comisiones por parte de los usuarios; sin limitar la posibilidad de que algunos de los servicios que Chinchin pone a disposición de sus clientes a través de ese medio, representen algún costo para el usuario y/o para el banco del cual éste sea cliente directo. Las comisiones derivadas de la utilización de estos servicios, serán las indicadas en los tarifarios de Chinchin, informados oportunamente al cliente afiliado.',
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Transmisión de Información Personal',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Chinchin no exigirá a los usuarios el registro de su información personal para acceder a la página; ahora bien, en el supuesto que algún usuario acepte proporcionar a Chinchin cualquier tipo de información personal a través de la página Web, está será utilizada únicamente para aquellos fines que Chinchin establezca a tal efecto, los cuales serán especificados en el formulario electrónico correspondiente. En este caso, el usuario se compromete a suministrar información verdadera y exacta acerca de sí mismo. Chinchin se compromete a mantener la confidencialidad de la información personal del usuario, en los términos y condiciones expuestos en las políticas de privacidad, que se publican en esta página Web.',
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Condiciones de seguridad',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Chinchin procurará que la página Web cumpla en todo momento con los estándares de calidad y seguridad existentes en el mercado en lo concerniente a la confidencialidad, integridad y autenticidad de la información suministrada por el usuario. Queda expresamente entendido que la información suministrada por el usuario esta encriptada bajo el Protocolo SSL (Secure Socket Layer), por lo que solo podrá ser interpretada por los servidores de Chinchin.',
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Infracciones a las presentes condiciones generales',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Chinchin se reserva el derecho de proceder a través de los recursos que tiene disponibles conforme a la ley, en contra de cualquier usuario que infrinja lo dispuesto en estas condiciones generales y en la legislación vigente sobre la materia; sin perjuicio de la posibilidad de bloquear el acceso de dicho infractor a esta página Web, según se dispone en clausulas anteriores.',
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Política Anti-spam',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'En el supuesto que el usuario haya proporcionado a Chinchin su dirección de correo electrónico a través de la página Web, la empresa podrá enviarle información que pueda ser de su interés, sin que dicha práctica se considere un correo no autorizado; en este caso, el usuario podrá solicitar a Chinchin la no remisión de dicha información, en los términos establecidos en la política de privacidad.',
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Violaciones a la seguridad de la página web',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Se prohíbe a los usuarios violar la seguridad de la página Web de Chinchin, incluyendo, pero no limitándose a: a) acceder a datos que estén destinados únicamente a Chinchin; b) entrar en un servidor o cuenta cuyo acceso no le esté autorizado; c) evaluar o probar la vulnerabilidad del sistema o la red de Chinchin; d) intentar o impedir el acceso de cualquier usuario a la página; e) enviar al sitio Web de Chinchin cualquier clase de software malicioso o programa de código hostil o intrusivo, tales como, sin limitarse a ello, virus, troyanos, gusanos, spyware, entre otros; f) bloquear el acceso a la página a los demás usuarios; y h) perpetrar cualquier infracción o delito definido en la Ley Especial Contra Delitos Informáticos o en cualquier otra norma que la sustituya o resulte aplicable a esta materia. La sanción por el incumplimiento de esta obligación, será la establecida en las leyes, sin perjuicio de la facultad de Chinchin de bloquear el acceso de dicho usuario a su página.',
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Exención de la responsabilidad de CHINCHIN',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Además de los supuestos de exención de responsabilidad previstos en otras cláusulas de estas condiciones generales y en otras secciones de esta página Web, Chinchin no garantiza ni se responsabiliza por los daños directos e indirectos, incluyendo, pero sin limitarse a ello, a aquellos que se traduzcan en pérdidas de utilidades, costos para contratar servicios o pérdidas de oportunidades, que surjan o se relacionen con: El uso de la información suministrada por un usuario, por parte de terceras personas distintas a Chinchin, que hubieren decodificado dicha información mediante el uso de sistemas informáticos. Daños ocasionados a los equipos y/o programas de los usuarios por la posible contaminación de software malicioso o programas de código hostil o intrusivo, tales como, sin limitarse a ello, virus, troyanos, gusanos, spyware, entre otros. La interrupción o suspensión de los servicios disponibles en esta página Web o el acceso a la misma, por mantenimiento, fallas en el sistema, fallas del servicio eléctrico, telefónico, por razones de orden técnico o de cualquier otra índole y retrasos, deficiencias o imposibilidad en cuanto al acceso a la página, debido a circunstancias que estén fuera del control de Credicard.',
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Modificación de estas condiciones generales y la política de privacidad',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Chinchin se reserva el derecho de modificar las presentes condiciones generales en cualquier momento, entrando en vigencia dichas modificaciones al vencimiento del plazo de un mes calendario contado a partir de su publicación en esta página Web; en virtud de lo antes expuesto, el usuario se compromete a revisar periódicamente esta sección así como las otras secciones que conforman esta página Web, para estar informado de tales modificaciones y el acceso a esta página Web a partir de la entrada en vigencia de las nuevas condiciones de uso, será considerada como una aceptación a estas condiciones.',
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Disposiciones Finales',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'En todo lo no previsto en estas condiciones generales, se aplicará lo dispuesto en la Ley de Mensajes de Datos y Firmas Electrónicas; en la Ley Especial Contra Delitos Informáticos, en el Decreto con Fuerza de Ley de Reforma de la Ley General de Bancos y Otras Instituciones Financieras; en el Código de Comercio y en cualesquiera otras leyes, decretos, resoluciones, instructivos o normas dictadas por las autoridades competentes. Estas condiciones generales se regirán e interpretarán de conformidad con el derecho vigente en la República Bolivariana de Venezuela. Toda controversia o diferencia, que verse sobre la existencia, extensión, interpretación y cumplimiento de estos Términos y Condiciones, será resuelta prioritariamente mediante Arbitraje en la Ciudad de Caracas, en idioma Español, en cualquier Institución elegida de común acuerdo por las partes que se especialice en Medios Alternativos de Resolución de Conflictos y Arbitraje en la República Bolivariana de Venezuela, de acuerdo con las disposiciones de la Ley de Arbitraje Comercial, el Reglamento de Arbitraje de la Comisión de las Naciones Unidas para el Derecho Mercantil Internacional (CNUDMI) y el Reglamento General del Centro de Arbitraje elegido por las partes. El Tribunal Arbitral estará compuesto por tres (3) árbitros, los cuales decidirán conforme a Derecho. Toda notificación en virtud de este convenio podrá realizarse en el domicilio fiscal de la empresa.',
                )
              ],
            ),
          ),
        ));
  }
}