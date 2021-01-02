import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Colors

Color kWhiteColor = Color(0xFFFFFFFF);
Color kRefresh = Color(0xFFF6F6F6);
Color kLightGreyColor = Color(0xFFFAFAFA);
Color kBlackColor = Color(0xFF323136);
Color kBlackColorHome = Color(0xFF323136);
Color kRedBoton = Color(0xFFFF7074);
Color kRedBotonAlert = Color(0xFFFF2C2C);
Color kUnderLineColor = Color(0x4D000000);
Color kBlackColorOpacity = Color(0xFFADB2B5);
Color kCategoryBorderColor = Color(0xFF707070);
Color kNumeroDiapositiva = Color(0xFFDADADA);
Color kDiapositivaColor = Color(0xFFD9EB88);
Color kBotonWifiColor = Color(0xFFB2CD33);
Color kGreenManda2Color = Color(0xFFB2CD33);
Color kGreenColor = Color(0xFFD4F2D7);
Color kTransparent = Color(0xF00000000);
Color kPinkColor = Color(0xFFFFE1DA);
Color kOrangeColor = Color(0xFFFA8064);
Color kTutorialColor = Color(0xFF969696);
Color kGreenTutorial = Color(0xFFD4F2D7);
Color kGreenInactive = Color(0xffE3E8CA);
Color kGreenActive = Color(0xffC3D184);
Color kRedActive = Color(0xFFCD3333);
Color kRedInActive = Color(0xFFE8CACA);

/// Agregados por SF para vista tentativa de Tarjetas
Color kShadowGreyColor = Color(0x08000000);
Color kDisabledButtonColor = Color(0xFFB7B9B9);
Color kShadowGreenColor = Color(0x5016A19A);

//TextStyles

TextStyle kTextFormFieldTittleTextStyle = TextStyle(
  color: kBlackColor,
  fontSize: 15,
  fontWeight: FontWeight.w400,
);

TextStyle estilo = TextStyle(
  fontFamily: 'SF',
  fontWeight: FontWeight.w400,
);

TextStyle kTextFormFieldTextStyle = TextStyle(
  fontWeight: FontWeight.w300,
  color: kBlackColor,
  fontSize: 15,
);

TextStyle kTextFormFieldHintTextStyle = TextStyle(
  fontWeight: FontWeight.w300,
  color: kBlackColorOpacity,
  fontSize: 15,
);

TextStyle kButtonTextStyle = TextStyle(
  color: kWhiteColor,
  fontSize: 15,
  fontWeight: FontWeight.w400,
);

TextStyle kNumeroDiapositivaTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: kNumeroDiapositiva,
);

TextStyle kTituloDiapositivaTextStyle = TextStyle(
  fontSize: 31,
  fontWeight: FontWeight.w500,
);

TextStyle kSinWifiTextStyle = TextStyle(
  fontWeight: FontWeight.w400,
  fontSize: 17,
  color: kBlackColor,
);

TextStyle kSinWifiTituloTextStyle = TextStyle(
  fontWeight: FontWeight.w400,
  fontSize: 18,
  color: kBlackColor,
);

TextStyle kTextFormFieldHintTextStyleInicioSesion = TextStyle(
  fontWeight: FontWeight.w400,
  color: kBlackColorOpacity,
  fontSize: 16,
);

TextStyle kTituloInicioSesion =
    TextStyle(fontSize: 31, fontWeight: FontWeight.w500, color: kBlackColor);
TextStyle ksubtituloInicioSesion = TextStyle(
  fontWeight: FontWeight.w400,
  fontSize: 12,
  color: kBlackColor.withOpacity(0.5),
);
TextStyle kCrearCuenta = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w600, color: kGreenManda2Color);
TextStyle kInicioSesion = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w600, color: kGreenManda2Color);
TextStyle kOlvidoInicioSesion =
    TextStyle(fontSize: 13, fontWeight: FontWeight.w400);
TextStyle kNoCuenta = TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
TextStyle kLabelTextStyle = TextStyle(
  color: kBlackColor,
  fontSize: 16,
);
TextStyle kLabelPedido = TextStyle(
  fontSize: 15,
);

//Border
BorderRadius kRadiusButton = BorderRadius.circular(9);
BorderRadius kRadiusAll = BorderRadius.circular(14);
BorderRadius kRadiusAdmins = BorderRadius.circular(16);
BorderRadius kRadiusQ2Formulario = BorderRadius.circular(20);

BorderRadius kRadiusCircular = BorderRadius.circular(45);

BorderRadius kRadiusOnlyTop = BorderRadius.only(
    topRight: Radius.circular(14), topLeft: Radius.circular(14));

//

String tyc = """
TÉRMINOS Y CONDICIONES
MATT Manda2

Por favor, lea cuidadosamente el siguiente texto. Por el uso de la Aplicación, usted acepta los Términos y Condiciones y la Política de Privacidad aquí contenidos.

1. Definiciones:

Cada definición incluye el término correspondiente en cualquier género (femenino o masculino) y número (plural o singular):

1.1. Compañía: Se entenderá como “La Rosa Lingerie S.A.S.”, sociedad comercial colombiana, constituida y actualmente existente, con NIT No. “901276602 - 7” y domicilio en la Cámara de Comercio de Medellín para Antioquia.

1.2. Aplicación: Programa informático denominado “MATT.manda2” desarrollado y administrado por la Compañía.

1.3. Usuario: Hace referencia, indistintamente, al Usuario Solicitante y al Usuario Proveedor.

1.4. Usuario Solicitante: Se entenderá como la persona natural o jurídica que se vincula a la Aplicación con la finalidad de solicitar la gestión de uno o varios encargos.

1.5. Usuario Proveedor: Se entenderá como la persona natural o jurídica que se vincula a la Aplicación con la gestionar uno o varios encargos por cuenta de uno o varios Usuarios Solicitantes.

1.6. Cookies: Se entiende como cualquier cadena de texto que pide autorización para alojarse en el disco duro de la computadora. Si el usuario acepta, entonces el explorador agrega el texto en un archivo pequeño con la finalidad de notificarnos cuando el usuario visita nuestra Aplicación. La información recogida por este medio es utilizada para crear perfiles anónimos para desarrollar, fabricar y comercializar productos, y puede ser tratada por la Compañía o sus afiliados. Esta información no incluye y nunca se combina con datos de carácter personal que permitan identificar a una persona determinada o cualquier información que pueda ser considerada sensible o que pueda comprometer la privacidad de los Usuarios.

1.7. Encargo: Se entenderá por encargo el objeto de cada uno de los contratos celebrados por los Usuarios entre sí a través de la Aplicación.

1.8. Función de la Aplicación: Se entenderá conforme con lo dispuesto en la cláusula 3 (“Uso de la Aplicación”) de estos Términos y Condiciones.


2. Alcance:

Los presentes “Términos y Condiciones” regulan el acceso a la Aplicación, la Función de la Aplicación, y la relación entre la Aplicación y los Usuarios.
El registro en la Aplicación implica adoptar la calidad de Usuario y la aceptación de los Términos y Condiciones vigentes.


3. Función de la Aplicación y responsabilidad de la Compañía:

Mediante la Aplicación, la Compañía pone a disposición de los Usuarios un espacio digital para el encuentro de oferta y demanda de la gestión de un Encargo. De este modo, el Usuario Solicitante podrá contratar al Usuario Proveedor, por medio de la Aplicación, para que éste gestione su Encargo, a cambio de una remuneración.

La Compañía no gestiona directamente los Encargos, pues su actividad consiste en poner a disposición de los Usuarios la Aplicación para que puedan celebrar un contrato de mandato entre ellos como partes exclusivas del mismo.

En consecuencia, la Compañía no es parte del contrato de mandato de gestión del Encargo. Por la disposición de la Aplicación a favor de los Usuarios, la Compañía retiene un porcentaje del monto pagado por el Usuario Solicitante al Usuario Proveedor por la gestión del Encargo.

Entre la Compañía y los Usuarios Proveedores no existe una relación laboral, ni de prestación de servicios, ni de agencia comercial, sin perjuicio de que el Usuario Proveedor pueda diputar a la Compañía para recibir el pago de la remuneración por parte del Usuario Solicitante.

Las obligaciones que surjan de la relación de mandato que haya entre los Usuarios, así como la responsabilidad derivada de su incumplimiento o de su cumplimiento imperfecto o tardío comprometerán exclusivamente el patrimonio de los Usuarios, bajo el entendido de que la Compañía no participa jurídicamente de dicha relación. La obligación y responsabilidad de la Compañía se limitan exclusivamente al funcionamiento y la estabilidad de la Aplicación.


4. Exclusión de la aplicación de la Ley 1369 de 2009:

Conforme con lo dispuesto por el numeral 11 del artículo 3 de la Ley 1369 de 2009, la ejecución del encargo del Usuario Solicitante por parte del Usuario Proveedor es una práctica de autoprestación, no regulada por la normativa aplicable al servicio de mensajería contenida en la referida ley.


5. Obligaciones de la Compañía:

Las obligaciones de la Compañía comprenden: (i) Administrar la Aplicación y mantenerla en estado de servir; (ii) Ejecutar el soporte lógico, de programación y operación para el funcionamiento de las cuentas de los Usuarios; (iii) Dar soporte y asistencia a los Usuarios en relación con el uso y la función de la Aplicación; (iv) Poner a disposición de los Usuarios, a través de los presente Términos y Condiciones, una regulación supletiva de su relación de mandato, sin perjuicio de que las Usuarios puedan exceptuarla o modificarla; y, (v) Poner a disposición de los Usuarios un canal digital a través del que puedan tramitar las reclamaciones que surjan con ocasión de la ejecución de su relación.

5.1. Responsabilidad: Las obligaciones de la Compañía en relación con la Aplicación, su funcionamiento y su puesta a disposición de los Usuarios son de medios y no de resultado. En el mismo sentido, los Usuarios accederán a la Aplicación en el estado en que se encuentre.


6. Obligaciones de los Usuarios:

Las obligaciones de los Usuarios en relación con la Compañía comprenden:

(i) Leer los presentes Términos y Condiciones;

(ii) Informarse suficientemente sobre la Función de la Aplicación, las obligaciones de la Compañía y el límite de su responsabilidad;

(iii) Usar apropiadamente la Aplicación y abstenerse de ejecutar sobre la misma ingeniería inversa o modificaciones;

(iv) Pagar la remuneración que corresponda, según estos Términos y Condiciones, por el uso de la Aplicación;

(v) Usar la Aplicación y cumplir con sus obligaciones de buena fe en relación con la Compañía y los demás Usuarios;

(vi) Proveer información completa, veraz, transparente, oportuna, verificable, comprensible, precisa e idónea a la Compañía y a los demás Usuario;

(vii) Usar la Aplicación directa y personalmente, absteniéndose de permitir el uso de cuenta por parte de terceros; (viii) Reportar oportunamente a la Compañía los errores o daños que perciban en la Aplicación y abstenerse de aprovechar dichos errores o daños en su beneficio;

(ix) En caso de exceptuar o modificar la regulación supletiva de su relación que la Compañía pone a su disposición a través de estos Términos y Condiciones, abstenerse de pactar objeto ilícito, en cualquier de sus modalidades, de regular su relación en forma incompatible con la Función de la Aplicación, y de modificar las obligaciones y derechos de la Compañía;

(x) Mantener indemne o indemnizar a la Compañía frente a cualquier reclamación que efectúe un Usuario Proveedor a un Usuario Solicitante o viceversa con ocasión de la ejecución o inejecución de las obligaciones resultantes de los contratos que celebren; y,

(xi) Mantener indemne o indemnizar a la Compañía frente a cualquier reclamación que efectúe un tercero por la ejecución o inejecución de las obligaciones resultantes de los contratos que los Usuarios celebren.

6.1. Responsabilidad de los Usuarios: Los Usuarios responderán sin límite frente a la Compañía y los demás Usuarios por los daños y perjuicios ocasionados por su incumplimiento de las obligaciones previstas en esta cláusula y aquellas que sean derivadas, conexas o complementarias de las mismas, conforme con lo dispuesto por el artículo 1603 del Código Civil colombiano.

6.2. Efecto relativo de los acuerdos entre los Usuarios respecto de la Compañía. En caso de exceptuar o modificar la regulación supletiva de su relación que la Compañía pone a su disposición de los Usuarios a través de estos Términos y Condiciones, éstos declaran y aceptan que no modificarán los derechos y obligaciones de la Compañía y que, en caso de hacerlo, tales modificaciones no surtirán efecto en relación con ésta.


7. Remuneración:

Conforme con lo dispuesto por la cláusula anterior, los Usuarios se obligan al pago de la siguiente remuneración en las condiciones previstas en esta cláusula:

7.1. Condición suspensiva: La obligación de pagar la remuneración a favor de la Compañía se causará con la celebración entre un (1) Usuario Solicitante y un (1) Usuario Proveedor de un (1) contrato de mandato.

7.2. Determinación del monto: El monto de la remuneración pagadera a la Compañía corresponderá al VEINTICINCO POR CIENTO (25%) del monto de la remuneración que el Usuario Solicitante se obligue a pagar al Usuario Proveedor con ocasión de la realización del Encargo que sea objeto del contrato que estos celebren a través de la Aplicación.

7.3. Forma de pago: La remuneración de la Compañía podrá ser pagada en una de las siguientes formas, según sea el caso:

a) En caso de que el Usuario Proveedor dipute a la Compañía para recibir el pago por parte del Usuario Solicitante, aquél autoriza a la Compañía para que retenga del monto recibido un monto igual al que corresponda a la remuneración de la Compañía. En este sentido, la Compañía sólo deberá trasferir al Usuario Proveedor el monto remanente después de retener su remuneración.

b) En caso de que el Usuario Proveedor reciba directamente el pago de su remuneración por parte del Usuario Solicitante, el Usuario Proveedor deberá pagar a la Compañía la remuneración.

7.4. Periodo de liquidación: Cada catorcena la Compañía liquidará las cuentas correspondientes a cuánto ha recibido por cuenta de la diputación efectuada por cada uno de los Usuarios Proveedores frente a cuánto deben pagarle dichos Usuarios Proveedores por los pagos que hayan recibido directamente de los Usuarios Solicitantes, con el fin de determinar quién debe pagar a quién y cuánto. El monto resultante de esta liquidación resultará pagadero a la parte que corresponda y con cargo a quién deba efectuarlo dentro del día hábil siguiente. En esta liquidación, la Compañía podrá incluir cualquier cargo que deba hacerse al Usuario Proveedor con ocasión de los reembolsos que deban efectuarse a los Usuarios Solicitantes, conforme con las condiciones aplicables a los contratos entre los Usuarios.

7.5. Impuestos aplicables: La remuneración pagadera a la Compañía causará los impuestos a que haya lugar conforme con las leyes aplicables.


8. Derechos de autor y licencia de acceso:

Todo el material informático, gráfico, publicitario, fotográfico, de multimedia relacionados con la Aplicación son de propiedad exclusiva de la Compañía y están protegidos por las normas de propiedad intelectual aplicables.

Queda prohibido todo acto de copia, reproducción, modificación, transformación, creación de trabajos derivados, venta o distribución, exhibición de los contenidos, de cualquier manera o por cualquier medio, sin el permiso previo y por escrito de la Compañía, como titular de dichos derechos. En ningún caso estos Términos y Condiciones confieren derechos, licencias o autorizaciones para realizar los actos anteriormente descritos. Cualquier uso no autorizado constituirá una violación de los presentes Términos y Condiciones y de las normas vigentes sobre propiedad intelectual.

La Compañía otorga a los Usuarios una licencia y derecho personal, intransferible y no exclusivo para ver y usar la Aplicación en un computador controlado por el Usuario. La licencia que se otorga es únicamente para uso personal e intransferible. Esta licencia no se extiende a terceros y termina automáticamente ante el incumplimiento del Usuario de cualquiera de las previsiones de estos Términos y Condiciones. La Compañía otorga al Usuario una licencia y derecho personal e intransferible y no exclusivo para utilizar el código objeto (no el código fuente) del software y siempre que no copie, modifique, cree, distribuya, reproduzca ni exhiba un trabajo derivado de ello, invierta el proceso, invierta el montaje o de algún modo intente descubrir algún código de acceso, vender, ceder, sublicenciar, prestar garantía o transferir cualquier derecho en el software. El usuario se obliga por los presentes Términos y Condiciones a no modificar el software de la Aplicación de ninguna manera.


9. Condiciones de acceso y uso:

El uso de la Aplicación requiere del registro previo. Con el registro, el Usuario declara y garantiza que los datos otorgados son datos son completos, veraces y actualizados. Con el registro se otorga al Usuario un usuario de acceso y éste debe elegir una contraseña, respecto de cuya custodia será entera y exclusivamente responsable. En caso de que el Usuario perciba o sospeche del acceso de un tercero no autorizado, deberá tomar medidas de reacción y comunicarlo inmediatamente a la Compañía.

Con el registro para acceder a la Aplicación, los Usuarios declaran y garantizan ser personas hábiles para contratar, en caso de ser personas naturales, según la normatividad civil vigente en Colombia, o estar legalmente constituidos, ser actualmente existentes y estar debidamente representados para contratar, en caso de ser personas jurídicas, según la normativa comercial vigente en Colombia. Los Usuarios no podrán transferir su cuenta a un tercero ni autorizar el uso de su cuenta por otro.

La Compañía se reserva el derecho de suspender la cuenta o cancelar el registro de los Usuarios por violación a los Términos y Condiciones, uso ilegal o fraudulento.


10. Errores de la aplicación y fallas técnicas:

La Compañía efectuará sus mejores esfuerzos para mantener la Aplicación disponible y en estado de servir para los Usuarios. En caso de evidenciar un error en la Aplicación, los Usuarios tienen la obligación de reportarlo oportunamente a la Compañía y tienen prohibido aprovecharse de las vulnerabilidades detectadas. En cualquier caso, la Compañía no garantiza la disponibilidad ni continuidad de la Aplicación debido a fallas técnicas.


11. Regulación supletiva del contrato de mandato celebrado entre los Usuarios:

11.1. Partes: Es mandante el Usuario Solicitante y mandatario, el Usuario Proveedor.

11.2. Objeto: Por medio del contrato, el Usuario Solicitante contrata al Usuario Proveedor para la gestión de un Encargo.

11.2.1. Límites del objeto: El Encargo estará limitado en las condiciones del objeto transportable, si aplica; en el área de cobertura; y en otros límites, según se indica a continuación:

(a) Límites físicos, dimensiones y valor: El Usuario Solicitante podrá encargar diligencias que recaigan sobre objetos cuyas dimensiones sean iguales o menores a un (1) metro de largo por cincuenta (50) centímetros de ancho y un (1) metro de alto. El peso deberá ser igual o inferior a treinta (30) kilogramos. En caso de que el objeto sea dinero en efectivo, deberá ser inferior a novecientos mil pesos colombianos (COP\$900.000).

(b) Prohibiciones: El Usuario Solicitante no podrá encargar gestiones que recaigan sobre joyas, títulos valores, objetos ilegales (incluyendo, pero sin limitarse a, estupefacientes, armas, sustancias inflamables), químicos cuya manipulación implique riesgos, animales.

(c) Zona de cobertura: La zona de cobertura de la Aplicación es todo el Valle de Aburra.

11.3. Obligaciones del Usuario Solicitante: Por medio del presente contrato, el Usuario Solicitante se obliga para con el Usuario Proveedor a:

(a) Cumplir con las condiciones del objeto, según la cláusula anterior.

(b) Informar suficientemente sobre dichas condiciones y cualquiera otra que resulte relevante para la ejecución del encargo.

(c) Declarar el valor real del objeto sobre el que recae el encargo.

(d) Entregar el objeto al Usuario Proveedor en buenas condiciones o declarar su estado, en caso de que sus condiciones no sean óptimas.

(e) Entregar el objeto al Usuario Proveedor debidamente embalado en un empaque apto para resistir las condiciones de ejecución normales del encargo.

(f) Informar suficientemente sobre el lugar de destino del objeto en caso de el encargo incluya su conducción hacia un lugar distinto.

(g) Informar suficientemente sobre la identidad de la persona que recibiría el objeto del encargo en caso de que sea distinta al Usuario Solicitante, garantizando que dicha persona cumpla con las obligaciones que le correspondan.

(h) Al recibir el objeto del encargo, verificar su estado y reclamar oportunamente en caso de identificar alguna anomalía. En caso de que se abstenga de reclamar, se presumirá que recibió el objeto en buen estado.

(i) Ofrecer remuneraciones razonables y abstenerse de abusar de su derecho y posición en relación con el Usuario Proveedor.


11.4. Obligaciones del Usuario Proveedor:

(a) Cumplir con el encargo aceptado, en las condiciones negociadas. Con todo, como regla general, el Usuario Proveedor deberá completar el encargo dentro de las veinticuatro (24) horas siguientes a su inicio. Cuando se trate de encargos que recaigan sobre objetos, el tiempo empezará a contarse a partir de la entrega que efectúe el Usuario Solicitante al Usuario Proveedor.

(b) Recibir el objeto del encargo y verificar su estado.

(c) Informar al Usuario Solicitante de cualquier novedad que se presente durante la ejecución del encargo.

(d) Mantener vigentes los permisos necesarios para ejecutar las actividades que sean medio para la ejecución del encargo.

(e) Adoptar las medidas necesarias para mantener la integridad del objeto del encargo y su propia integridad personal.

11.5. Responsabilidad del Usuario Solicitante:

El Usuario Solicitante asume la responsabilidad por todos los daños y perjuicios que le cause a la Compañía, al Usuario Proveedor y a terceros en caso de encargar gestiones que recaigan sobre cosas prohibidas o peligrosas. Adicionalmente, el Usuario Solicitante debe garantizar que las cosas estén empacadas de manera óptima de tal forma que no sea susceptible de generar daños a la Compañía, al Usuario Proveedor ni a terceros.

En caso de el encargo no pueda ser ejecutado por causa imputable al Usuario Solicitante, este deberá responder por el pago total de la tarifa ofrecida y por los gastos adicionales que se ocasionen.

11.6. Responsabilidad del Usuario Proveedor:

El Usuario Proveedor responderá por los daños ocasionados en los objetos sobre los que recaigan el Encargo desde el momento en que los reciba. Esta responsabilidad sólo cesará a la terminación del Encargo, según lo contratado y no se extenderá los daños sobre objetos peligros o prohibidos, conforme con la ley aplicable o estos Términos y Condiciones. El Usuario Proveedor tampoco será responsable por los daños resultantes del vicio propio de los objetos sobre los que recaiga el encargo. Se entenderá que un objeto adolece de un vicio propio cuando tenga dentro de sí el germen de su propia destrucción. Estas responsabilidades en ningún caso podrán ser trasladadas al patrimonio de la Compañía.

11.6.1. Límites a la responsabilidad del Usuario Proveedor:

Con todo, el Usuario Proveedor solo responderá frente al Usuario Solicitante hasta un monto igual al del ciento por ciento (100%) del valor declarado del objeto por pérdida total del mismo. En caso de avería o daño parcial, el Usuario Proveedor responderá por la proporción de dicha avería o daño parcial aplicado sobre el valor total declarado.

11.7. Oferta del precio, aceptación y celebración del contrato: El Usuario Solicitante deberá determinar el precio que ofrece en pago como contraprestación por la realización del encargo. En caso de que el Usuario Proveedor lo acepte, sin que los Usuarios se pongan de acuerdo en condiciones distintas a las establecidas en esta cláusula, se entenderá que los Usuarios celebran su contrato de mandato con observancia de estas normas supletivas.

11.8. Forma de pago: El Usuario Solicitante pagará al Usuario Proveedor la remuneración conforme con las alternativas previstas en los Términos y Condiciones de uso de la Aplicación.

11.9. Reclamaciones: El Usuario Solicitante tiene la obligación de revisar el objeto del encargo al momento de su recepción. Una vez el objeto sea entregado se dará por cumplido y terminado el contrato de mandato. En caso de tener una reclamación por un defecto que no sea evidente, Usuario Solicitante puede comunicarse al correo matt.movilidad@gmail.com en un término de 2 días.

11.10. Políticas de cancelación de encargos:

El Usuario Solicitante podrá cancelar el encargo en cualquier momento antes de que el Usuario Proveedor reciba el objeto del mismo.


12. Reembolsos:

En virtud de la Ley 1480 de 2011, la Compañía realizará el reembolso de su remuneración o de la remuneración del Usuario Proveedor, según corresponda, en los siguientes casos:

12.1. Garantía legal: En caso de que no sea posible la realización del Encargo de manera definitiva, por causa imputable a la Compañía o al Usuario Proveedor, la Compañía o el Usuario Proveedor, según se trate de la remuneración del uno o del otro, reembolsará lo pagado por el Usuario Solicitante, en los tiempos y condiciones previstos por la Ley 1480 de 2011 y su decreto reglamentario, para el ejercicio de la garantía legal.

12.2. Reversión del pago: Si el pago se efectúa a través de la Aplicación por medio de cualquier instrumento de pago electrónico, los participantes del proceso de pago reversarán dicho pago cuando el Usuario Solicitante haya sido condiciones establecidas por el artículo 51 de la Ley 1480 de 2011 y su decreto reglamentario.

12.3. Derecho de retracto: Habida cuenta de las condiciones de tiempo en que deben ejecutarse los encargos, en ningún caso se cumpliría con las condiciones previstas por la Ley 1480 de 2011, para que esta figura proceda.


13. Cesión:

La Compañía podrá ceder en cualquier momento la Aplicación o los Términos y Condiciones de la misma. Los Usuarios no podrán ceder los contratos celebrados a través de la aplicación o los presentes Términos y Condiciones.


14. Integridad y divisibilidad:

Los presentes Términos y Condiciones representan en su totalidad eL acuerdo de la Compañía con los Usuarios. En caso de que una o más de las disposiciones contenidas en este documento sean consideradas inexistentes, viciadas de nulidad o ineficaces en cualquier aspecto, la existencia, validez, legalidad, exigibilidad o eficacia del resto de las disposiciones del presente documento no se verán afectadas por dicha circunstancia.


15. Modificaciones:

La Compañía se reserva la facultad de efectuar modificaciones a los presentes Términos y Condiciones, sin necesidad de avisar previamente a los Usuarios. Con todo, cualquier modificación que se efectúe en uso de esta atribución deberá ser debidamente publicada.


16. Notificaciones – PQRS:

Cualquier petición, queja, reclamo o solicitud podrá ser enviada a matt.movilidad@gmail.com


17. Ley aplicable:

Los presentes Términos y Condiciones, así como los actos jurídicos celebrados a través de la Aplicación se regirán por la ley de la República de Colombia.

""";
String pp = '''
POLÍTICAS DE PRIVACIDAD
MATT Manda2

Objeto. Informar a los Usuarios y al público en general sobre el tratamiento de los datos personales a través de la aplicación MATT Manda2 (“Aplicación”), en cumplimiento de la Ley 1581 de 2012 y en el Decreto reglamentario 1377 de 2013.
 
Responsable del tratamiento. El responsable del tratamiento de datos personales es la sociedad LA ROSA LINGERIE S.A.S. (la “Empresa”), sociedad legalmente constituida bajo las leyes colombianas e identificada con el NIT No. 901276602 – 7. En su calidad de responsable de tratamiento de datos informa a los titulares que su domicilio es la ciudad de Medellín, Colombia, en la dirección CR 37 7 13 P 1, Medellín, Antioquia, su teléfono es 3108325760, y el correo electrónico en el cual pueden ser atendidas las consultas y/o reclamos es matt.movilidad@gmail.com.

Tratamiento y finalidad de los datos. El tratamiento al cual serán sometidos los datos personales se limitará a su recolección, almacenamiento, uso, circulación y supresión, con la finalidad de garantizar el adecuado funcionamiento de la Aplicación y realizar publicidad, mercadeo, promoción, comunicación, investigación, transferencia o cualquier otra actividad complementaria inherente al desarrollo legítimo del objeto social de la Empresa.

Recolección y almacenamiento de datos personales. La Empresa en su calidad de responsable y encargado de tratamiento de datos, recolectará la información de los titulares a través de la Aplicación. La mencionada información será almacenada en bases de datos pertenecientes a la Empresa que serán custodiados de acuerdo a los requisitos de seguridad exigidas por la ley.

Derechos del titular. El titular tendrá derecho a:

Conocer, actualizar y rectificar los datos personales que se encuentren en poder de la Empresa según el procedimiento establecido en esta política.

Solicitar prueba de la autorización cuando esta sea requisito para el tratamiento de conformidad con el artículo 10 de la Ley 1581 de 2012.

Solicitar ser informado del uso que se les ha dado a sus datos personales.

Revocar la autorización que le fue concedida a la Empresa para el tratamiento de datos personales y solicitar la supresión de cualquier dato.

Acceder de forma gratuita a los datos personales que se encuentren el poder de la Empresa.

Procedimientos para la protección de datos personales. En cumplimiento a las disposiciones de la Ley 1581 de 2012, las solicitudes de consulta y reclamo serán atendidas a través del correo electrónico matt.movilidad@gmail.com. 

Para el procedimiento de consulta o reclamo, el titular de los datos deberá hacer llegar una solicitud al correo electrónico informado indicando el nombre, identificación, datos de contacto, motivo de la solicitud y firma.

El término para contestar la solicitud de consulta será de diez (10) días hábiles. Cuando no sea posible responder la solicitud en dicho término, la Empresa deberá informar al titular del motivo por el cual no será posible cumplir con el término y la fecha en que se responderá a la solicitud que, en cualquier caso, no será mayor a cinco (5) días hábiles después del vencimiento del primer término.

El término para contestar la solicitud de reclamo será de quince (15) días hábiles. Cuando no sea posible responder la solicitud en dicho término, la Empresa deberá informar al titular del motivo por el cual no será posible cumplir con el término y la fecha en que se responderá a la solicitud que, en cualquier caso, no será mayor a ocho (8) días hábiles después del vencimiento del primer término.

VIGENCIA. La presente Política de Tratamiento de Datos personales rige a partir de su publicación en la Aplicación por un término indefinido.

AVISO DE PRIVACIDAD

Para LA ROSA LINGERIE S.A.S. (la “Empresa”) es muy importante la protección de los datos personales de todos sus Usuarios, por esta razón la empresa, en cumplimiento de la Ley 1581 de 2012 y el Decreto reglamentario 1377 de 2013, se permite informales que el tratamiento al cual serán sometidos los datos personales de los titulares que sean recaudados por la Empresa se limitará a su recolección, almacenamiento, uso, circulación y supresión con la finalidad de ejecutar el adecuado funcionamiento de la Aplicación Matt Manda2 y realizar publicidad, mercadeo, promoción, comunicación, investigación, transferencia o cualquier otra actividad complementaria inherente al desarrollo legítimo del objeto social de la empresa.

Así mismo, comunicamos que los derechos de todos los titulares de datos que se encuentren en nuestras bases son:

Conocer, actualizar y rectificar los datos personales que se encuentren en poder de la Empresa según el procedimiento establecido en la Política de Tratamiento de datos personales.
Solicitar prueba de la autorización cuando esta sea requisito para el tratamiento de conformidad con el artículo 10 de la Ley 1581 de 2012.
Solicitar ser informado del uso que se les ha dado a sus datos personales.
Revocar la autorización que le fue concedida a la Empresa para el tratamiento de datos personales y solicitar la supresión de cualquier dato.
Acceder de forma gratuita a los datos personales que se encuentren el poder de la Empresa.

Lo invitamos a conocer nuestra Política de Tratamiento de datos personales en la página www.catapulta.app/manda2.html o comunicándose al teléfono 3108325760 en Medellín, en el correo electrónico matt.movilidad@gmail.com o en la dirección CR 37 7 13 P 1, en la ciudad de Medellín.


''';
