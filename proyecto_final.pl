:- use_module(library(pce)).
:- use_module(library(pce_style_item)).
:- pce_image_directory('./images').
:- use_module(library(interpolate)).

resource(portada, image, image('portada.jpg')).
resource(fondo, image, image('fondo.jpg')).
resource(salida, image, image('salida.jpg')).
iniciar:-win_window_pos([show(false)]),abrir.
abrir:-
	new(Menu, dialog('Sistema Experto para la Supervicion de Peso')),
	new(LblTitle, label(nombre, 'Sistema Experto para el Control Calorico y de Ingesta', font('Time','Roman',19))),
	new(LblInstrucciones, label(nombre, 'Para comenzar, dar click en el boton: Realizar Test:', font('Time','Roman', 18))),
	new(Salir, button('SALIR', and(message(Menu,destroy), message(Menu, free)))),
	new(BtnInicia, button('REALIZAR TEST', and(message(@prolog, datos_usuario), message(Menu, destroy), message(Menu, free)))),
	nueva_imagen(Menu, portada),
	send(Menu, append(LblTitle)),
	send(Menu, display, LblTitle, point(50,80)),
	send(Menu, display, BtnInicia, point(280,250)),
	send(Menu, display, LblInstrucciones, point(70,150)),
	send(Menu, display, Salir, point(20,400)),
	send(Menu, open_centered).

% Solicitamos sus datos al usuario
datos_usuario:-
	new(Datos , dialog('Supervision de Peso')),
    new(LblTitulo, label(nombre, 'Sistem Experto para el', font('Time','Roman',16))),
    new(LblTitulo2, label(nombre, 'Control Calorico y de Ingesta', font('Time','Roman',16))),
	new(LblDatos, label(nombre, 'Datos Personales', font('Time','Roman',16))),

	nueva_imagen(Datos, fondo),
	send(Datos, display, LblTitulo, point(100,80)),
        send(Datos, display, LblTitulo2, point(70,100)),
	send(Datos, display, LblDatos, point(120,155)),

	/* Creacion de los campos para la recuperacion de datos*/
	new(Nombre, text_item(nombre, '')),
	new(Sexo, menu(sexo, cycle)),
	new(Edad, menu(edad, cycle)),
	new(Ejercicio, menu(ejercicio, cycle)),
	new(Altura,text_item('Altura (cm.)', '')),
	new(Peso,text_item('Peso (kg.)', '')),

	/*listas de respuestas validas*/
	Respuestas_validas_sexo = ['Hombre','Mujer'],
	send_list(Sexo, append, Respuestas_validas_sexo),

	Respuestas_validas_edad = ['Nino','Joven','Adulto'],
	send_list(Edad, append, Respuestas_validas_edad),

	Respuestas_validas_ejercicio = ['Sedentarismo','Ligero','Moderado','Alto','Intenso'],
	send_list(Ejercicio, append, Respuestas_validas_ejercicio),

	/*generamos el diseÃ±o del grupo de preguntas*/
	/*generamos un grupo de elementos de las respuestas solo por cuestiones de alineacion y diseno*/
	send(Datos, display, Nombre, point(65,220)),
	send(Datos, display, Sexo, point(82,250)),
	send(Datos, display, Edad, point(82,290)),
	send(Datos, display, Ejercicio, point(65,330)),
	send(Datos, display, Altura, point(65,370)),
	send(Datos, display, Peso, point(65,410)),

	new(Boton_evaluar,button('EVALUAR' , and(message(@prolog,evaluar,
	Nombre ? selection,
	Sexo ? selection,
	Edad ? selection,
	Ejercicio ? selection,
	Altura ? selection,
	Peso ? selection), message(Datos, destroy), message(Datos, free)))),

	new(Boton_cancelar, button('CANCELAR', and(message(@prolog, iniciar), message(Datos, destroy), message(Datos, free)))),
	send(Datos, display, Boton_evaluar, point(100, 450)), /*mandamos el boton al dialogo Datos*/
	send(Datos, display, Boton_cancelar, point(200, 450)),
	send(Datos, open_centered).

/*EVALUAR*/

evaluar(Nombre, Sexo, Edad, Ejercicio, Altura, Peso):-
	new(RESPUESTA, dialog('Supervicion de Peso - Resultados')),
	new(LblTitulo, label(nombre, 'Sistema Experto para Control\nCalorico y de Ingesta', font('Time','Roman',20))),
	new(LblHola, label(nombre, 'Hola ', font('Time', 'Roman', 22))),
	new(Titulo1, label(nombre, Nombre, font('Time','Roman',22))),
	new(Titulo2, label(nombre, 'Nuestra recomendacion es:', font('Time','Roman',18))),
	new(Btn_regresar, button('REGRESAR', and(message(@prolog, iniciar), message(RESPUESTA, destroy), message(RESPUESTA, free)))),
	new(Btn_salir, button('SALIR', and(message(RESPUESTA, destroy), message(RESPUESTA, free)))),
	new(Nota1, text('Nota: Acuda con su medico bariatra o nutriologo de\nconfianza para dar un seguimiento profesional a su\nsituacion personal.')),
	new(Nota2, text('Recuerda realizar 30 minutos de ejercicio diariamente.')),
	send(Nota1, font, bold),
        send(Nota1, colour, red),
        send(Nota2, font, bold),
        send(Nota2, colour, red),

        get(Sexo, value, Sexo),
        get(Edad, value, Edad),
        get(Peso, value, Peso),
        get(Nombre, value, Nombre),
        get(Altura, value, Altura),
        get(Ejercicio, value, Ejercicio),

	(
        (abrir_conexion, ingresar_registro(Nombre,Altura,Peso,_IMC,Sexo,Edad,Ejercicio,_Tipo,_F),cerrar_conexion),


		/* ---------------------------------------- MENSAJES PARA RESULTADOS DE NINO HOMBRE ----------------------------------------- */
	    si_h_pb_n_sed(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1 , label(nombre, 'Estado: Peso Bajo', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria más\nProteina, Frutas y Verduras.', font('Time', 'Roman', 18)));
	    si_h_pn_n_sed(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Peso Normal', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteina, Frutas y Verduras', font('Time', 'Roman', 18)));
	    si_h_sp_n_sed(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Sobrepeso', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Incrementar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
	    si_h_obst1_n_sed(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Obesidad I', font('Time', 'Roman', 18))),
                new(Salida2 , label(nombre, 'Integrar dentro de su dieta diaria más\nFrutas y Verduras.', font('Time', 'Roman', 18)));
	    si_h_obst2_n_sed(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Obesidad II', font('Time', 'Roman', 18))),
                new(Salida2 , label(nombre, 'Integrar dentro de su dieta diaria más\nFrutas y Verduras.', font('Time', 'Roman', 18)));
	    si_h_obst3_n_sed(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Obesidad III', font('Time', 'Roman', 18))),
                new(Salida2 , label(nombre, 'Integrar dentro de su dieta diaria más\nFrutas y Verduras.', font('Time', 'Roman', 18)));
	    si_h_pb_n_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Peso Bajo', font('Time', 'Roman', 18))),
                new(Salida2 , label(nombre, 'Integrar dentro de su dieta diaria mas\nGrasas, Proteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
	    si_h_pn_n_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Peso Normal', font('Time', 'Roman', 18))),
                new(Salida2 , label(nombre, 'Integrar dentro de su dieta diaria\nAzucares, Proteinas, frutas y Verduras.', font('Time', 'Roman', 18)));
	    si_h_sp_n_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Sobrepeso', font('Time', 'Roman', 18))),
                new(Salida2 , label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
	    si_h_obst1_n_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Obesidad I', font('Time', 'Roman', 18))),
                new(Salida2 , label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
	    si_h_obst2_n_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Obesidad I', font('Time', 'Roman', 18))),
                new(Salida2 , label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
	    si_h_obst3_n_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Obesidad III', font('Time', 'Roman', 18))),
                new(Salida2 , label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
	    si_h_pb_n_ejmoderado(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Peso Bajo', font('Time', 'Roman', 18))),
                new(Salida2 , label(nombre, 'Integrar dentro de su dieta diaria\nAzucares, Grasas, Proteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_pn_n_ejmoderado(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Peso Normal', font('Time', 'Roman', 18))),
                new(Salida2 , label(nombre, 'Integrar dentro de su dieta diaria Azucares,\nGrasas, Proteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_sp_n_ejmoderado(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Sobrepeso', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_obst1_n_ejmoderado(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo I', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_obst2_n_ejmoderado(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo II', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_obst3_n_ejmoderado(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo III', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_pb_n_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Bajo', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nAzucares, Grasas, Proteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_pn_n_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Normal', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nGrasas, Proteinas, Frutas y Ferduras.', font('Time', 'Roman', 18)));
            si_h_sp_n_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Sobrepeso', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_obst1_n_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo I', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_obst2_n_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo II', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_obst3_n_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo III', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_pb_n_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Bajo', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nAzucares, Grasas, Proteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_pn_n_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Normal', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nAzucares, Grasas, Proteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_sp_n_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Sobrepeso', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nGrasas, Proteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_obst1_n_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo I', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_obst2_n_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Obesidad Tipo II', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_obst3_n_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo III', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));

			/* ---------------------------------------- MENSAJES PARA RESULTADOS DE JOVEN HOMBRE ----------------------------------------- */

			si_h_pb_j_sed(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1 , label(nombre, 'Estado: Peso Bajo', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria más\nProteina, Frutas y Verduras.', font('Time', 'Roman', 18)));
			si_h_pn_j_sed(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Peso Normal', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteina, Frutas y Verduras', font('Time', 'Roman', 18)));
			si_h_sp_j_sed(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Sobrepeso', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Incrementar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
			si_h_obst1_j_sed(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Obesidad I', font('Time', 'Roman', 18))),
                new(Salida2 , label(nombre, 'Integrar dentro de su dieta diaria más\nFrutas y Verduras.', font('Time', 'Roman', 18)));
			si_h_obst2_j_sed(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Obesidad II', font('Time', 'Roman', 18))),
                new(Salida2 , label(nombre, 'Integrar dentro de su dieta diaria más\nVerduras y Proteina.', font('Time', 'Roman', 18)));
			si_h_obst3_j_sed(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Obesidad III', font('Time', 'Roman', 18))),
                new(Salida2 , label(nombre, 'Integrar dentro de su dieta diaria más\nVerduras y Proteina.', font('Time', 'Roman', 18)));
			si_h_pb_j_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Peso Bajo', font('Time', 'Roman', 18))),
                new(Salida2 , label(nombre, 'Integrar dentro de su dieta diaria mas\nProteinas, Grasas y Verduras.', font('Time', 'Roman', 18)));
			si_h_pn_j_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Peso Normal', font('Time', 'Roman', 18))),
                new(Salida2 , label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, frutas y Verduras.', font('Time', 'Roman', 18)));
			si_h_sp_j_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Sobrepeso', font('Time', 'Roman', 18))),
                new(Salida2 , label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
			si_h_obst1_j_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Obesidad I', font('Time', 'Roman', 18))),
                new(Salida2 , label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
			si_h_obst2_j_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Obesidad I', font('Time', 'Roman', 18))),
                new(Salida2 , label(nombre, 'Integrar dentro de su dieta diaria\nVerduras y Proteinas.', font('Time', 'Roman', 18)));
			si_h_obst3_j_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Obesidad III', font('Time', 'Roman', 18))),
                new(Salida2 , label(nombre, 'Integrar dentro de su dieta diaria \nVerduras y Proteinas.', font('Time', 'Roman', 18)));
			si_h_pb_j_ejmoderado(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Peso Bajo', font('Time', 'Roman', 18))),
                new(Salida2 , label(nombre, 'Integrar dentro de su dieta diaria\nGrasas, Proteínas y Frutas.', font('Time', 'Roman', 18)));
            si_h_pn_j_ejmoderado(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Peso Normal', font('Time', 'Roman', 18))),
                new(Salida2 , label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_sp_j_ejmoderado(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Sobrepeso', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_obst1_j_ejmoderado(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo I', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_obst2_j_ejmoderado(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo II', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_obst3_j_ejmoderado(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo III', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas y Verduras.', font('Time', 'Roman', 18)));
            si_h_pb_j_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Bajo', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nAzucares, Proteínas y Verduras.', font('Time', 'Roman', 18)));
            si_h_pn_j_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Normal', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_sp_j_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Sobrepeso', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_obst1_j_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo I', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_obst2_j_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo II', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_obst3_j_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo III', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas y Verduras.', font('Time', 'Roman', 18)));
            si_h_pb_j_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Bajo', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nGrasas, Proteínas y Verduras.', font('Time', 'Roman', 18)));
            si_h_pn_j_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Normal', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_sp_j_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Sobrepeso', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_obst1_j_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo I', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_obst2_j_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Obesidad Tipo II', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_obst3_j_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo III', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));

/* ---------------------------------------- MENSAJES PARA RESULTADOS DE ADULTO HOMBRE ----------------------------------------- */

si_h_pb_a_sed(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1 , label(nombre, 'Estado: Peso Bajo', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria más\nProteina, Frutas y Verduras.', font('Time', 'Roman', 18)));
	    si_h_pn_a_sed(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Peso Normal', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteina, Frutas y Verduras', font('Time', 'Roman', 18)));
	    si_h_sp_a_sed(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Sobrepeso', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Incrementar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
	    si_h_obst1_a_sed(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Obesidad I', font('Time', 'Roman', 18))),
                new(Salida2 , label(nombre, 'Integrar dentro de su dieta diaria más\nProteinas y Verduras.', font('Time', 'Roman', 18)));
	    si_h_obst2_a_sed(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Obesidad II', font('Time', 'Roman', 18))),
                new(Salida2 , label(nombre, 'Integrar dentro de su dieta diaria más\nProteinas y Verduras.', font('Time', 'Roman', 18)));
	    si_h_obst3_a_sed(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Obesidad III', font('Time', 'Roman', 18))),
                new(Salida2 , label(nombre, 'Integrar dentro de su dieta diaria más\nFrutas y Verduras.', font('Time', 'Roman', 18)));
	    si_h_pb_a_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Peso Bajo', font('Time', 'Roman', 18))),
                new(Salida2 , label(nombre, 'Integrar dentro de su dieta diaria mas\nGrasas, Proteinas y Verduras.', font('Time', 'Roman', 18)));
	    si_h_pn_a_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Peso Normal', font('Time', 'Roman', 18))),
                new(Salida2 , label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, frutas y Verduras.', font('Time', 'Roman', 18)));
	    si_h_sp_a_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Sobrepeso', font('Time', 'Roman', 18))),
                new(Salida2 , label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
	    si_h_obst1_a_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Obesidad I', font('Time', 'Roman', 18))),
                new(Salida2 , label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
	    si_h_obst2_a_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Obesidad I', font('Time', 'Roman', 18))),
                new(Salida2 , label(nombre, 'Integrar dentro de su dieta diaria\nProteinas y Verduras.', font('Time', 'Roman', 18)));
	    si_h_obst3_a_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Obesidad III', font('Time', 'Roman', 18))),
                new(Salida2 , label(nombre, 'Integrar dentro de su dieta diaria\nProteinas y Verduras.', font('Time', 'Roman', 18)));
	    si_h_pb_a_ejmoderado(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Peso Bajo', font('Time', 'Roman', 18))),
                new(Salida2 , label(nombre, 'Integrar dentro de su dieta diaria\nGrasas, Proteínas y Frutas.', font('Time', 'Roman', 18)));
            si_h_pn_a_ejmoderado(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
                new(Salida1, label(nombre, 'Estado: Peso Normal', font('Time', 'Roman', 18))),
                new(Salida2 , label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_sp_a_ejmoderado(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Sobrepeso', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_obst1_a_ejmoderado(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo I', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas y Verduras.', font('Time', 'Roman', 18)));
            si_h_obst2_a_ejmoderado(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo II', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas y Verduras.', font('Time', 'Roman', 18)));
            si_h_obst3_a_ejmoderado(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo III', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas y Verduras.', font('Time', 'Roman', 18)));
            si_h_pb_a_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Bajo', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nGrasas, Proteínas y Verduras.', font('Time', 'Roman', 18)));
            si_h_pn_a_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Normal', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Ferduras.', font('Time', 'Roman', 18)));
            si_h_sp_a_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Sobrepeso', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_obst1_a_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo I', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_obst2_a_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo II', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas y Verduras.', font('Time', 'Roman', 18)));
            si_h_obst3_a_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo III', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_pb_a_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Bajo', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_pn_a_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Normal', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_sp_a_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Sobrepeso', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_obst1_a_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo I', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
            si_h_obst2_a_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Obesidad Tipo II', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas y Verduras.', font('Time', 'Roman', 18)));
            si_h_obst3_a_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,_Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo III', font('Time', 'Roman', 18))),
                new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas  y Verduras.', font('Time', 'Roman', 18)));


	    /* ---------------------------------------- MENSAJES PARA RESULTADOS DE NINA MUJER ----------------------------------------- */
	    si_m_n_pb_sed(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Bajo', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nGrasas, Azucares y Frutas.', font('Time', 'Roman', 18)));
	    si_m_n_pn_sed(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Normal', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteina y Verduras.', font('Time', 'Roman', 18)));
	    si_m_n_sp_sed(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Sobrepeso', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nVerduras, Frutas y Proteina.', font('Time', 'Roman', 18)));
	    si_m_n_ob1_sed(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo I', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_n_ob2_sed(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo II', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_n_ob3_sed(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo III', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_n_pb_ejligero(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Bajo', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nGrasas y Proteina.', font('Time', 'Roman', 18)));
	    si_m_n_pn_ejligero(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Normal', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nGrasas y Frutas.', font('Time', 'Roman', 18)));
	    si_m_n_sp_ejligero(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Sobrepeso', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Grasas.', font('Time', 'Roman', 18)));
	    si_m_n_ob1_ejligero(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo I', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Proteina.', font('Time', 'Roman', 18)));
	    si_m_n_ob2_ejligero(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo II', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_n_ob3_ejligero(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo III', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_n_pb_ejligero(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Bajo', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nGrasas y Proteina.', font('Time', 'Roman', 18)));
	    si_m_n_pn_ejligero(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Normal', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nGrasas y Frutas.', font('Time', 'Roman', 18)));
	    si_m_n_sp_ejligero(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Sobrepeso', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Grasas.', font('Time', 'Roman', 18)));
	    si_m_n_ob1_ejligero(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo I', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Proteina.', font('Time', 'Roman', 18)));
	    si_m_n_ob2_ejligero(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo II', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_n_ob3_ejligero(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo III', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_n_pb_ejmod(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Bajo', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nGrasas y Azucares.', font('Time', 'Roman', 18)));
	    si_m_n_pn_ejmod(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Normal', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas y Grasas.', font('Time', 'Roman', 18)));
	    si_m_n_sp_ejmod(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Sobrepeso', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Proteinas.', font('Time', 'Roman', 18)));
	    si_m_n_ob1_ejmod(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo I', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nVerduras y Proteina.', font('Time', 'Roman', 18)));
	    si_m_n_ob2_ejmod(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo II', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_n_ob3_ejmod(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo III', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_n_pb_ejalto(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Bajo', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nGrasas y Proteinas.', font('Time', 'Roman', 18)));
	    si_m_n_pn_ejalto(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Normal', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas y Grasas.', font('Time', 'Roman', 18)));
	    si_m_n_sp_ejalto(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Sobrepeso', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas y  Frutas.', font('Time', 'Roman', 18)));
	    si_m_n_ob1_ejalto(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo I', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_n_ob2_ejalto(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo II', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_n_ob3_ejalto(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo III', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Proteinas.', font('Time', 'Roman', 18)));
	    si_m_n_pb_ejintenso(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Bajo', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas y Azucares.', font('Time', 'Roman', 18)));
	    si_m_n_pn_ejintenso(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Normal', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas y Grasas.', font('Time', 'Roman', 18)));
	    si_m_n_sp_ejintenso(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Sobrepeso', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas y  Frutas.', font('Time', 'Roman', 18)));
	    si_m_n_ob1_ejintenso(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo I', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas y Grasas.', font('Time', 'Roman', 18)));
	    si_m_n_ob2_ejintenso(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo II', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Proteinas.', font('Time', 'Roman', 18)));
	    si_m_n_ob3_ejintenso(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo III', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nVerduras y Proteinas.', font('Time', 'Roman', 18)));

		/* ---------------------------------------- MENSAJES PARA RESULTADOS DE JOVEN MUJER ----------------------------------------- */
	    si_m_j_pb_sed(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo)->
	        new(Salida1, label(nombre, 'Estado: Peso Bajo', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_j_pn_sed(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo)->
	        new(Salida1, label(nombre, 'Estado: Peso Normal', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_j_sp_sed(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo)->
	        new(Salida1, label(nombre, 'Estado: Sobrepeso', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_j_ob1_sed(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo)->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo I', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_j_ob2_sed(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo)->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo II', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_j_ob3_sed(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo)->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo III', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_j_pb_ejligero(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo)->
	        new(Salida1, label(nombre, 'Estado: Peso Bajo', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nGrasas, Proteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_j_pn_ejligero(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo)->
	        new(Salida1, label(nombre, 'Estado: Peso Normal', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_j_sp_ejligero(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo)->
	        new(Salida1, label(nombre, 'Estado: Sobrepeso', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_j_ob1_ejligero(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo)->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo I', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_j_ob2_ejligero(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo)->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo II', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_j_ob3_ejligero(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo)->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo III', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_j_pb_ejmod(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo)->
	        new(Salida1, label(nombre, 'Estado: Peso Bajo', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nAzucares, Grasas, Proteinas, Frutas\ny Verduras.', font('Time', 'Roman', 18)));
	    si_m_j_pn_ejmod(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo)->
	        new(Salida1, label(nombre, 'Estado: Peso Normal', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nAzucares, Grasas, Proteinas, Frutas\ny Verduras.', font('Time', 'Roman', 18)));
	    si_m_j_sp_ejmod(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo)->
	        new(Salida1, label(nombre, 'Estado: Sobrepeso', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nGrasas, Proteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_j_ob1_ejmod(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo)->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo I', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_j_ob2_ejmod(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo)->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo II', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_j_ob3_ejmod(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo)->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo III', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_j_pb_ejalto(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo)->
	        new(Salida1, label(nombre, 'Estado: Peso Bajo', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas y Azucares.', font('Time', 'Roman', 18)));
	    si_m_j_pn_ejalto(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo)->
	        new(Salida1, label(nombre, 'Estado: Peso Normal', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nGrasas y Proteinas.', font('Time', 'Roman', 18)));
	    si_m_j_sp_ejalto(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo)->
	        new(Salida1, label(nombre, 'Estado: Sobrepeso', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas y Frutas.', font('Time', 'Roman', 18)));
	    si_m_j_ob1_ejalto(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo)->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo I', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_j_ob2_ejalto(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo)->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo II', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas y Frutas.', font('Time', 'Roman', 18)));
	    si_m_j_ob3_ejalto(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo)->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo III', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas y Frutas.', font('Time', 'Roman', 18)));
	    si_m_j_pb_ejintenso(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo)->
	        new(Salida1, label(nombre, 'Estado: Peso Bajo', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas y Azucares.', font('Time', 'Roman', 18)));
	    si_m_j_pn_ejintenso(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo)->
	        new(Salida1, label(nombre, 'Estado: Peso Normal', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nGrasas y Proteinas.', font('Time', 'Roman', 18)));
	    si_m_j_sp_ejintenso(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo)->
	        new(Salida1, label(nombre, 'Estado: Sobrepeso', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas y Frutas.', font('Time', 'Roman', 18)));
	    si_m_j_ob1_ejintenso(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo)->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo I', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas y Grasas.', font('Time', 'Roman', 18)));
	    si_m_j_ob2_ejintenso(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo)->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo II', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas y Frutas.', font('Time', 'Roman', 18)));
	    si_m_j_ob3_ejintenso(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo)->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo III', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas y Verduras.', font('Time', 'Roman', 18)));

		/* ---------------------------------------- MENSAJES PARA RESULTADOS DE ADULTA MUJER ----------------------------------------- */
	    si_m_a_pb_sed(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Bajo', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nGrasas y Azucares.', font('Time', 'Roman', 18)));
	    si_m_a_pn_sed(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Normal', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteina y Frutas.', font('Time', 'Roman', 18)));
	    si_m_a_sp_sed(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Sobrepeso', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Proteina.', font('Time', 'Roman', 18)));
	    si_m_a_ob1_sed(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo I', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_a_ob2_sed(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo II', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nVerduras y Proteinas.', font('Time', 'Roman', 18)));
	    si_m_a_ob3_sed(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo III', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_a_pb_ejligero(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Bajo', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nGrasas y Azucares.', font('Time', 'Roman', 18)));
	    si_m_a_pn_ejligero(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Normal', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas y Frutas.', font('Time', 'Roman', 18)));
	    si_m_a_sp_ejligero(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Sobrepeso', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Proteinas.', font('Time', 'Roman', 18)));
	    si_m_a_ob1_ejligero(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo I', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Proteina.', font('Time', 'Roman', 18)));
	    si_m_a_ob2_ejligero(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo II', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_a_ob3_ejligero(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo III', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_a_pb_ejmod(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Bajo', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frtuas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_a_pn_ejmod(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Normal', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas Frutas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_a_sp_ejmod(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Sobrepeso', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Proteinas.', font('Time', 'Roman', 18)));
	    si_m_a_ob1_ejmod(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo I', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nVerduras y Proteina.', font('Time', 'Roman', 18)));
	    si_m_a_ob2_ejmod(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo II', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_a_ob3_ejmod(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo III', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_a_pb_ejalto(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Bajo', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas, Verduras y Proteinas.', font('Time', 'Roman', 18)));
	    si_m_a_pn_ejalto(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Normal', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frtuas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_a_sp_ejalto(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Sobrepeso', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Verduras y  Frutas.', font('Time', 'Roman', 18)));
	    si_m_a_ob1_ejalto(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo I', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_a_ob2_ejalto(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo II', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_a_ob3_ejalto(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo III', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Proteinas.', font('Time', 'Roman', 18)));
	    si_m_a_pb_ejintenso(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Bajo', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas y Grasas.', font('Time', 'Roman', 18)));
	    si_m_a_pn_ejintenso(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Peso Normal', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas, Frutas y Grasas.', font('Time', 'Roman', 18)));
	    si_m_a_sp_ejintenso(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Sobrepeso', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas y  Frutas.', font('Time', 'Roman', 18)));
	    si_m_a_ob1_ejintenso(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo I', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nProteinas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_a_ob2_ejintenso(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo II', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nFrutas y Verduras.', font('Time', 'Roman', 18)));
	    si_m_a_ob3_ejintenso(Sexo, Edad, Ejercicio, Altura, Peso, _Tipo) ->
	        new(Salida1, label(nombre, 'Estado: Obesidad Tipo III', font('Time', 'Roman', 18))),
	        new(Salida2, label(nombre, 'Integrar dentro de su dieta diaria\nVerduras, Frutas y Proteinas.', font('Time', 'Roman', 18)));


            /*EL SIGUIENTE MENSAJE SIEMPRE VA HASTA EL FINAL PORQUE ES EL QUE SALDRA SI NO ENCUENTRA NINGUNA COINCIDENCIA CON LAS REGLAS*/
            new(Salida1, text('Sus caracteristicas fisicas no coinciden con un\ncriterio razonable para recomendarle algun tipo\n
			       de ingesta, se recomienda encarecidamente buscar\natencion medica especial para resolver su situacion')),
	    send(Salida1, font, bold)
	)
,
        nueva_imagen(RESPUESTA, salida),
        send(RESPUESTA, display, LblTitulo, point(360,20)),
	send(RESPUESTA, display, LblHola, point(360, 100)),
        send(RESPUESTA, display, Titulo1, point(420,100)),
        send(RESPUESTA, display, Salida1, point(360,180)),
        send(RESPUESTA, display, Titulo2, point(360,220)),
        send(RESPUESTA, display, Salida2, point(360,250)),
        send(RESPUESTA, display, Nota2, point(360, 335)),
        send(RESPUESTA, display, Nota1, point(360, 380)),
        send(RESPUESTA, display, Btn_regresar, point(550,450)),
        send(RESPUESTA, display, Btn_salir, point(450,450)),
        send(RESPUESTA , open_centered).

% Cargar imagen de fondo
nueva_imagen(Ventana, Imagen):- new(Figura, figure),
                                new(Bitmap, bitmap(resource(Imagen),@on)),
                                send(Bitmap, name, 1),
                                send(Figura, display, Bitmap),
                                send(Figura, status, 1),
                                send(Ventana, display,Figura,point(15,15)).

%PARTE DE LOGICA Y REGLAS DE OPERACION.
masa_corporal(Altura, Peso, X, Y, IMC, Tipo):-
        atom_number(Altura, Y),
        atom_number(Peso, X),
        IMC is round(X / (Y / 100) ^ 2),
        clasificacion(IMC, Tipo).

% CLASIFICACION DEL ESTADO DE ACUERDO AL IMC
clasificacion(Resultado,Clasificacion):-Resultado < 18.5 ,
                                        Clasificacion = 'peso bajo',!.
clasificacion(Resultado,Clasificacion):-Resultado >=  18.5, Resultado =< 24.9,
                                        Clasificacion = 'peso normal',!.
clasificacion(Resultado,Clasificacion):-Resultado >=  25,Resultado =< 29.9,
                                        Clasificacion = 'sobrepeso',!.
clasificacion(Resultado,Clasificacion):-Resultado >=  30,Resultado =< 34.9,
                                        Clasificacion = 'obesidad grado I',!.
clasificacion(Resultado,Clasificacion):-Resultado >=  35,Resultado =< 39.9,
                                        Clasificacion = 'obesidad grado II',!.
clasificacion(Resultado,Clasificacion):-Resultado >=  40,
                                        Clasificacion = 'obesidad grado III',!.

%///OPERACIONES CON BASE DE DATOS////////
abrir_conexion:-
                odbc_connect('prolog', _,
                        [ user('root'),
                          password(''),
                          alias(prolog),
                          open(once)
                         ]).
cerrar_conexion:-odbc_disconnect('prolog').

ingresar_registro(Nombre,Altura,Peso,Imc,Sexo,Edad,Ejercicio,Tipo,F):-
masa_corporal(Altura, Peso, X, Y, Imc, Tipo),
odbc_query('prolog',
'INSERT INTO registro_medico (ALTURA,PESO,IMC,SEXO,EDAD,EJERCICIO,NOMBRE,CLASIFICACION)
VALUES	($Altura , $Peso ,$Imc, $Sexo , $Edad, $Ejercicio, "$Nombre", "$Tipo")',
affected(F)
),
write('REGISTRADO EN LA BASE DE DATOS')
.

/* Si la persona es hombre, tiene peso bajo, es nino y es sedentario, entonces, deberia comer
proteina, frutas y verduras.*/
si_h_pb_n_sed(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Nino',
    Ejercicio == 'Sedentarismo',
    Tipo == 'peso bajo').

/* Si la persona es hombre, tiene peso normal, es nino y es sedentario, entonces, deberia comer
frutas, verduras y proteina.*/
si_h_pn_n_sed(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Nino',
    Ejercicio == 'Sedentarismo',
    Tipo == 'peso normal').

/* Si la persona es hombre, tiene sobrepeso, es nino y es sedentario, entonces, deberia comer
mas frutas y verduras.*/
si_h_sp_n_sed(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Nino',
    Ejercicio == 'Sedentarismo',
    Tipo == 'sobrepeso').

/* Si la persona es hombre, tiene obesidad I, es nino y es sedentario, entonces, deberia comer
frutas y verduras.*/

si_h_obst1_n_sed(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Nino',
    Ejercicio == 'Sedentarismo',
    Tipo == 'obesidad grado I').

/* Si la persona es hombre, tiene obesidad II, es nino y es sedentario, entonces, deberia comer
frutas y verduras.*/
si_h_obst2_n_sed(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Nino',
    Ejercicio == 'Sedentarismo',
    Tipo == 'obesidad grado II').

/* Si la persona es hombre, tiene obesidad III, es nino y es sedentario, entonces, deberia comer
frutas y verduras.*/
si_h_obst3_n_sed(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Nino',
    Ejercicio == 'Sedentarismo',
    Tipo == 'obesidad grado III').

/* Si la persona es hombre, tiene peso bajo, es nino y hace ejercicio ligero, entonces, deberia
comer grasas, proteinas, frutas y verduras.*/
si_h_pb_n_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Nino',
    Ejercicio == 'Ligero',
    Tipo == 'peso bajo').

/* Si la persona es hombre, tiene peso normal, es nino y hace ejercicio ligero, entonces, deberia
comer azucares, proteinas, frutas y verduras.*/
si_h_pn_n_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Nino',
    Ejercicio == 'Ligero',
    Tipo == 'peso normal').

/* Si la persona es hombre, tiene sobrepeso, es nino y hace ejercicio ligero, entonces, deberia
comer proteinas, frutas y verduras.*/
si_h_sp_n_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Nino',
    Ejercicio == 'Ligero',
    Tipo == 'sobrepeso').

/* Si la persona es hombre, tiene obesidad I, es niÃ±o y hace ejercicio ligero, entonces, deberia
comer frutas y verduras.*/
si_h_obst1_n_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Nino',
    Ejercicio == 'Ligero',
    Tipo == 'obesidad grado I').

/* Si la persona es hombre, tiene obesidad II, es nino y hace ejercicio ligero, entonces, deberia
comer frutas y verduras.*/
si_h_obst2_n_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Nino',
    Ejercicio == 'Ligero',
    Tipo == 'obesidad grado II').

/* Si la persona es hombre, tiene obesidad III, es nino y hace ejercicio ligero, entonces, deberia
comer frutas y verduras.*/
si_h_obst3_n_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Nino',
    Ejercicio == 'Ligero',
    Tipo == 'obesidad grado III').

/* Si la persona es hombre, tiene peso bajo, es nino y hace ejercicio moderado, entonces, deberia
comer azucares, grasas, proteÃ­nas, frutas y verduras.*/
si_h_pb_n_ejmoderado(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Nino',
    Ejercicio == 'Moderado',
    Tipo == 'peso bajo').

/* Si la persona es hombre, tiene peso normal, es nino y hace ejercicio moderado, entonces,
deberia comer azucares, proteinas, frutas y verduras.*/
si_h_pn_n_ejmoderado(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Nino',
    Ejercicio == 'Moderado',
    Tipo == 'peso normal').

/* Si la persona es hombre, tiene sobrepeso, es nino y hace ejercicio moderado, entonces,
deberia comer proteinas, frutas y verduras.*/
si_h_sp_n_ejmoderado(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Nino',
    Ejercicio == 'Moderado',
    Tipo == 'sobrepeso').

/* Si la persona es hombre, tiene obesidad I, es nino y hace ejercicio moderado, entonces,
deberia comer frutas y verduras.*/
si_h_obst1_n_ejmoderado(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Nino',
    Ejercicio == 'Moderado',
    Tipo == 'obesidad grado I').

/* Si la persona es hombre, tiene obesidad II, es nino y hace ejercicio moderado, entonces,
deberia comer frutas y verduras*/
si_h_obst2_n_ejmoderado(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Nino',
    Ejercicio == 'Moderado',
    Tipo =='obesidad grado II').

/* Si la persona es hombre, tiene obesidad III, es nino y hace ejercicio moderado, entonces,
deberia comer frutas y verduras*/
si_h_obst3_n_ejmoderado(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Nino',
    Ejercicio == 'Moderado',
    Tipo == 'obesidad grado III').

/* Si la persona es hombre, tiene peso bajo, es nino y hace ejercicio alto, entonces, deberia
comer azucares, grasas, proteinas, frutas y verduras.*/
si_h_pb_n_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Nino',
    Ejercicio == 'Alto',
    Tipo == 'peso bajo').

/* Si la persona es hombre, tiene peso normal, es nino y hace ejercicio alto, entonces, deberia
comer grasas, proteinas, frutas y verduras.*/
si_h_pn_n_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Nino',
    Ejercicio == 'Alto',
    Tipo == 'peso normal').

/* Si la persona es hombre, tiene sobrepeso, es nino y hace ejercicio alto, entonces, deberia
comer proteinas, frutas y verduras.*/
si_h_sp_n_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Nino',
    Ejercicio == 'Alto',
    Tipo == 'sobrepeso').

/* Si la persona es hombre, tiene obesidad I, es nino y hace ejercicio alto, entonces, deberia
comer frutas y verduras.*/
si_h_obst1_n_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Nino',
    Ejercicio == 'Alto',
    Tipo == 'obesidad grado I').

/* Si la persona es hombre, tiene obesidad II, es nino y hace ejercicio alto, entonces, deberia
comer frutas y verduras*/
si_h_obst2_n_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Nino',
    Ejercicio == 'Alto',
    Tipo == 'obesidad grado II').

/* Si la persona es hombre, tiene obesidad III, es nino y hace ejercicio alto, entonces, deberia
comer frutas y verduras*/
si_h_obst3_n_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Nino',
    Ejercicio == 'Alto',
    Tipo == 'obesidad grado III').

/* Si la persona es hombre, tiene peso bajo, es nino y hace ejercicio intenso, entonces, deberia
comer azucares, grasas, proteinas, frutas y verduras.*/
si_h_pb_n_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Nino',
    Ejercicio == 'Intenso',
    Tipo == 'peso bajo').

/* Si la persona es hombre, tiene peso normal, es nino y hace ejercicio intenso, entonces, deberia
comer azucares, grasas, proteinas, frutas y verduras.*/
si_h_pn_n_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Nino',
    Ejercicio == 'Intenso',
    Tipo == 'peso normal').

/* Si la persona es hombre, tiene sobrepeso, es nino y hace ejercicio intenso, entonces, deberia
comer grasas, proteinas, frutas y verduras.*/
si_h_sp_n_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Nino',
    Ejercicio == 'Intenso',
    Tipo == 'sobrepeso').

/* Si la persona es hombre, tiene obesidad I, es nino y hace ejercicio intenso, entonces, deberi
comer proteinas, frutas y verduras.*/
si_h_obst1_n_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Nino',
    Ejercicio == 'Intenso',
    Tipo == 'obesidad grado I').

/* Si la persona es hombre, tiene obesidad II, es nino y hace ejercicio intenso, entonces, deberia
comer proteinas, frutas y verduras*/
si_h_obst2_n_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Nino',
    Ejercicio == 'Intenso',
    Tipo == 'obesidad grado II').

/* Si la persona es hombre, tiene obesidad III, es nino y hace ejercicio intenso, entonces, deberia
comer proteinas, frutas y verduras*/
si_h_obst3_n_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Nino',
    Ejercicio == 'Intenso',
    Tipo == 'obesidad grado III').

/*-- FIN DE LAS REGLAS DEL NInO-HOMBRE --*/

/*-- INICIO DE LAS REGLAS DEL JOVEN-HOMBRE --*/

/* Si la persona es hombre, tiene peso bajo, es joven y es sedentario, entonces, deberia comer
proteina, frutas y verduras.*/
si_h_pb_j_sed(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Joven',
    Ejercicio == 'Sedentarismo',
    Tipo == 'peso bajo').

/* Si la persona es hombre, tiene peso normal, es joven y es sedentario, entonces, deberia comer
frutas, verduras y proteina.*/
si_h_pn_j_sed(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Joven',
    Ejercicio == 'Sedentarismo',
    Tipo == 'peso normal').

/* Si la persona es hombre, tiene sobrepeso, es joven y es sedentario, entonces, deberia comer
mas frutas y verduras.*/
si_h_sp_j_sed(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Joven',
    Ejercicio == 'Sedentarismo',
    Tipo == 'sobrepeso').

/* Si la persona es hombre, tiene obesidad I, es joven y es sedentario, entonces, deberia comer
frutas y verduras.*/

si_h_obst1_j_sed(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Joven',
    Ejercicio == 'Sedentarismo',
    Tipo == 'obesidad grado I').

/* Si la persona es hombre, tiene obesidad II, es joven y es sedentario, entonces, deberia comer
frutas y verduras.*/
si_h_obst2_j_sed(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Joven',
    Ejercicio == 'Sedentarismo',
    Tipo == 'obesidad grado II').

/* Si la persona es hombre, tiene obesidad III, es joven y es sedentario, entonces, deberia comer
frutas y verduras.*/
si_h_obst3_j_sed(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Joven',
    Ejercicio == 'Sedentarismo',
    Tipo == 'obesidad grado III').

/* Si la persona es hombre, tiene peso bajo, es joven y hace ejercicio ligero, entonces, deberia
comer grasas, proteinas, frutas y verduras.*/
si_h_pb_j_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Joven',
    Ejercicio == 'Ligero',
    Tipo == 'peso bajo').

/* Si la persona es hombre, tiene peso normal, es joven y hace ejercicio ligero, entonces, deberia
comer azucares, proteinas, frutas y verduras.*/
si_h_pn_j_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Joven',
    Ejercicio == 'Ligero',
    Tipo == 'peso normal').

/* Si la persona es hombre, tiene sobrepeso, es joven y hace ejercicio ligero, entonces, deberia
comer proteinas, frutas y verduras.*/
si_h_sp_j_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Joven',
    Ejercicio == 'Ligero',
    Tipo == 'sobrepeso').

/* Si la persona es hombre, tiene obesidad I, es niÃ±o y hace ejercicio ligero, entonces, deberia
comer frutas y verduras.*/
si_h_obst1_j_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Joven',
    Ejercicio == 'Ligero',
    Tipo == 'obesidad grado I').

/* Si la persona es hombre, tiene obesidad II, es joven y hace ejercicio ligero, entonces, deberia
comer frutas y verduras.*/
si_h_obst2_j_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Joven',
    Ejercicio == 'Ligero',
    Tipo == 'obesidad grado II').

/* Si la persona es hombre, tiene obesidad III, es joven y hace ejercicio ligero, entonces, deberia
comer frutas y verduras.*/
si_h_obst3_j_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Joven',
    Ejercicio == 'Ligero',
    Tipo == 'obesidad grado III').

/* Si la persona es hombre, tiene peso bajo, es joven y hace ejercicio moderado, entonces, deberia
comer azucares, grasas, proteÃ­nas, frutas y verduras.*/
si_h_pb_j_ejmoderado(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Joven',
    Ejercicio == 'Moderado',
    Tipo == 'peso bajo').

/* Si la persona es hombre, tiene peso normal, es joven y hace ejercicio moderado, entonces,
deberia comer azucares, proteinas, frutas y verduras.*/
si_h_pn_j_ejmoderado(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Joven',
    Ejercicio == 'Moderado',
    Tipo == 'peso normal').

/* Si la persona es hombre, tiene sobrepeso, es joven y hace ejercicio moderado, entonces,
deberia comer proteinas, frutas y verduras.*/
si_h_sp_j_ejmoderado(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Joven',
    Ejercicio == 'Moderado',
    Tipo == 'sobrepeso').

/* Si la persona es hombre, tiene obesidad I, es joven y hace ejercicio moderado, entonces,
deberia comer frutas y verduras.*/
si_h_obst1_j_ejmoderado(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Joven',
    Ejercicio == 'Moderado',
    Tipo == 'obesidad grado I').

/* Si la persona es hombre, tiene obesidad II, es joven y hace ejercicio moderado, entonces,
deberia comer frutas y verduras*/
si_h_obst2_j_ejmoderado(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Joven',
    Ejercicio == 'Moderado',
    Tipo =='obesidad grado II').

/* Si la persona es hombre, tiene obesidad III, es joven y hace ejercicio moderado, entonces,
deberia comer frutas y verduras*/
si_h_obst3_j_ejmoderado(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Joven',
    Ejercicio == 'Moderado',
    Tipo == 'obesidad grado III').

/* Si la persona es hombre, tiene peso bajo, es joven y hace ejercicio alto, entonces, deberia
comer azucares, grasas, proteinas, frutas y verduras.*/
si_h_pb_j_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Joven',
    Ejercicio == 'Alto',
    Tipo == 'peso bajo').

/* Si la persona es hombre, tiene peso normal, es joven y hace ejercicio alto, entonces, deberia
comer grasas, proteinas, frutas y verduras.*/
si_h_pn_j_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Joven',
    Ejercicio == 'Alto',
    Tipo == 'peso normal').

/* Si la persona es hombre, tiene sobrepeso, es joven y hace ejercicio alto, entonces, deberia
comer proteinas, frutas y verduras.*/
si_h_sp_j_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Joven',
    Ejercicio == 'Alto',
    Tipo == 'sobrepeso').

/* Si la persona es hombre, tiene obesidad I, es joven y hace ejercicio alto, entonces, deberia
comer frutas y verduras.*/
si_h_obst1_j_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Joven',
    Ejercicio == 'Alto',
    Tipo == 'obesidad grado I').

/* Si la persona es hombre, tiene obesidad II, es joven y hace ejercicio alto, entonces, deberia
comer frutas y verduras*/
si_h_obst2_j_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Joven',
    Ejercicio == 'Alto',
    Tipo == 'obesidad grado II').

/* Si la persona es hombre, tiene obesidad III, es joven y hace ejercicio alto, entonces, deberia
comer frutas y verduras*/
si_h_obst3_j_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Joven',
    Ejercicio == 'Alto',
    Tipo == 'obesidad grado III').

/* Si la persona es hombre, tiene peso bajo, es joven y hace ejercicio intenso, entonces, deberia
comer azucares, grasas, proteinas, frutas y verduras.*/
si_h_pb_j_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Joven',
    Ejercicio == 'Intenso',
    Tipo == 'peso bajo').

/* Si la persona es hombre, tiene peso normal, es joven y hace ejercicio intenso, entonces, deberia
comer azucares, grasas, proteinas, frutas y verduras.*/
si_h_pn_j_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Joven',
    Ejercicio == 'Intenso',
    Tipo == 'peso normal').

/* Si la persona es hombre, tiene sobrepeso, es joven y hace ejercicio intenso, entonces, deberia
comer grasas, proteinas, frutas y verduras.*/
si_h_sp_j_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Joven',
    Ejercicio == 'Intenso',
    Tipo == 'sobrepeso').

/* Si la persona es hombre, tiene obesidad I, es joven y hace ejercicio intenso, entonces, deberi
comer proteinas, frutas y verduras.*/
si_h_obst1_j_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Joven',
    Ejercicio == 'Intenso',
    Tipo == 'obesidad grado I').

/* Si la persona es hombre, tiene obesidad II, es joven y hace ejercicio intenso, entonces, deberia
comer proteinas, frutas y verduras*/
si_h_obst2_j_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Joven',
    Ejercicio == 'Intenso',
    Tipo == 'obesidad grado II').

/* Si la persona es hombre, tiene obesidad III, es joven y hace ejercicio intenso, entonces, deberia
comer proteinas, frutas y verduras*/
si_h_obst3_j_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Joven',
    Ejercicio == 'Intenso',
    Tipo == 'obesidad grado III').

/*-- FIN DE LAS REGLAS DEL JOVEN-HOMBRE --*/

/*-- INICIO DE LAS REGLAS DEL ADULTO-HOMBRE --*/

/* Si la persona es hombre, tiene peso bajo, es adulto y es sedentario, entonces, deberia comer
proteina, frutas y verduras.*/
si_h_pb_a_sed(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Adulto',
    Ejercicio == 'Sedentarismo',
    Tipo == 'peso bajo').

/* Si la persona es hombre, tiene peso normal, es adulto y es sedentario, entonces, deberia comer
frutas, verduras y proteina.*/
si_h_pn_a_sed(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Adulto',
    Ejercicio == 'Sedentarismo',
    Tipo == 'peso normal').

/* Si la persona es hombre, tiene sobrepeso, es adulto y es sedentario, entonces, deberia comer
mas frutas y verduras.*/
si_h_sp_a_sed(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Adulto',
    Ejercicio == 'Sedentarismo',
    Tipo == 'sobrepeso').

/* Si la persona es hombre, tiene obesidad I, es adulto y es sedentario, entonces, deberia comer
frutas y verduras.*/

si_h_obst1_a_sed(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Adulto',
    Ejercicio == 'Sedentarismo',
    Tipo == 'obesidad grado I').

/* Si la persona es hombre, tiene obesidad II, es adulto y es sedentario, entonces, deberia comer
frutas y verduras.*/
si_h_obst2_a_sed(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Adulto',
    Ejercicio == 'Sedentarismo',
    Tipo == 'obesidad grado II').

/* Si la persona es hombre, tiene obesidad III, es adulto y es sedentario, entonces, deberia comer
frutas y verduras.*/
si_h_obst3_a_sed(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Adulto',
    Ejercicio == 'Sedentarismo',
    Tipo == 'obesidad grado III').

/* Si la persona es hombre, tiene peso bajo, es adulto y hace ejercicio ligero, entonces, deberia
comer grasas, proteinas, frutas y verduras.*/
si_h_pb_a_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Adulto',
    Ejercicio == 'Ligero',
    Tipo == 'peso bajo').

/* Si la persona es hombre, tiene peso normal, es adulto y hace ejercicio ligero, entonces, deberia
comer azucares, proteinas, frutas y verduras.*/
si_h_pn_a_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Adulto',
    Ejercicio == 'Ligero',
    Tipo == 'peso normal').

/* Si la persona es hombre, tiene sobrepeso, es adulto y hace ejercicio ligero, entonces, deberia
comer proteinas, frutas y verduras.*/
si_h_sp_a_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Adulto',
    Ejercicio == 'Ligero',
    Tipo == 'sobrepeso').

/* Si la persona es hombre, tiene obesidad I, es niÃ±o y hace ejercicio ligero, entonces, deberia
comer frutas y verduras.*/
si_h_obst1_a_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Adulto',
    Ejercicio == 'Ligero',
    Tipo == 'obesidad grado I').

/* Si la persona es hombre, tiene obesidad II, es adulto y hace ejercicio ligero, entonces, deberia
comer frutas y verduras.*/
si_h_obst2_a_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Adulto',
    Ejercicio == 'Ligero',
    Tipo == 'obesidad grado II').

/* Si la persona es hombre, tiene obesidad III, es adulto y hace ejercicio ligero, entonces, deberia
comer frutas y verduras.*/
si_h_obst3_a_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Adulto',
    Ejercicio == 'Ligero',
    Tipo == 'obesidad grado III').

/* Si la persona es hombre, tiene peso bajo, es adulto y hace ejercicio moderado, entonces, deberia
comer azucares, grasas, proteÃ­nas, frutas y verduras.*/
si_h_pb_a_ejmoderado(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Adulto',
    Ejercicio == 'Moderado',
    Tipo == 'peso bajo').

/* Si la persona es hombre, tiene peso normal, es adulto y hace ejercicio moderado, entonces,
deberia comer azucares, proteinas, frutas y verduras.*/
si_h_pn_a_ejmoderado(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Adulto',
    Ejercicio == 'Moderado',
    Tipo == 'peso normal').

/* Si la persona es hombre, tiene sobrepeso, es adulto y hace ejercicio moderado, entonces,
deberia comer proteinas, frutas y verduras.*/
si_h_sp_a_ejmoderado(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Adulto',
    Ejercicio == 'Moderado',
    Tipo == 'sobrepeso').

/* Si la persona es hombre, tiene obesidad I, es adulto y hace ejercicio moderado, entonces,
deberia comer frutas y verduras.*/
si_h_obst1_a_ejmoderado(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Adulto',
    Ejercicio == 'Moderado',
    Tipo == 'obesidad grado I').

/* Si la persona es hombre, tiene obesidad II, es adulto y hace ejercicio moderado, entonces,
deberia comer frutas y verduras*/
si_h_obst2_a_ejmoderado(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Adulto',
    Ejercicio == 'Moderado',
    Tipo =='obesidad grado II').

/* Si la persona es hombre, tiene obesidad III, es adulto y hace ejercicio moderado, entonces,
deberia comer frutas y verduras*/
si_h_obst3_a_ejmoderado(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Adulto',
    Ejercicio == 'Moderado',
    Tipo == 'obesidad grado III').

/* Si la persona es hombre, tiene peso bajo, es adulto y hace ejercicio alto, entonces, deberia
comer azucares, grasas, proteinas, frutas y verduras.*/
si_h_pb_a_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Adulto',
    Ejercicio == 'Alto',
    Tipo == 'peso bajo').

/* Si la persona es hombre, tiene peso normal, es adulto y hace ejercicio alto, entonces, deberia
comer grasas, proteinas, frutas y verduras.*/
si_h_pn_a_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Adulto',
    Ejercicio == 'Alto',
    Tipo == 'peso normal').

/* Si la persona es hombre, tiene sobrepeso, es adulto y hace ejercicio alto, entonces, deberia
comer proteinas, frutas y verduras.*/
si_h_sp_a_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Adulto',
    Ejercicio == 'Alto',
    Tipo == 'sobrepeso').

/* Si la persona es hombre, tiene obesidad I, es adulto y hace ejercicio alto, entonces, deberia
comer frutas y verduras.*/
si_h_obst1_a_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Adulto',
    Ejercicio == 'Alto',
    Tipo == 'obesidad grado I').

/* Si la persona es hombre, tiene obesidad II, es adulto y hace ejercicio alto, entonces, deberia
comer frutas y verduras*/
si_h_obst2_a_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Adulto',
    Ejercicio == 'Alto',
    Tipo == 'obesidad grado II').

/* Si la persona es hombre, tiene obesidad III, es adulto y hace ejercicio alto, entonces, deberia
comer frutas y verduras*/
si_h_obst3_a_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Adulto',
    Ejercicio == 'Alto',
    Tipo == 'obesidad grado III').

/* Si la persona es hombre, tiene peso bajo, es adulto y hace ejercicio intenso, entonces, deberia
comer azucares, grasas, proteinas, frutas y verduras.*/
si_h_pb_a_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Adulto',
    Ejercicio == 'Intenso',
    Tipo == 'peso bajo').

/* Si la persona es hombre, tiene peso normal, es adulto y hace ejercicio intenso, entonces, deberia
comer azucares, grasas, proteinas, frutas y verduras.*/
si_h_pn_a_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Adulto',
    Ejercicio == 'Intenso',
    Tipo == 'peso normal').

/* Si la persona es hombre, tiene sobrepeso, es adulto y hace ejercicio intenso, entonces, deberia
comer grasas, proteinas, frutas y verduras.*/
si_h_sp_a_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Adulto',
    Ejercicio == 'Intenso',
    Tipo == 'sobrepeso').

/* Si la persona es hombre, tiene obesidad I, es adulto y hace ejercicio intenso, entonces, deberi
comer proteinas, frutas y verduras.*/
si_h_obst1_a_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Adulto',
    Ejercicio == 'Intenso',
    Tipo == 'obesidad grado I').

/* Si la persona es hombre, tiene obesidad II, es adulto y hace ejercicio intenso, entonces, deberia
comer proteinas, frutas y verduras*/
si_h_obst2_a_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Adulto',
    Ejercicio == 'Intenso',
    Tipo == 'obesidad grado II').

/* Si la persona es hombre, tiene obesidad III, es adulto y hace ejercicio intenso, entonces, deberia
comer proteinas, frutas y verduras*/
si_h_obst3_a_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Hombre',
    Edad == 'Adulto',
    Ejercicio == 'Intenso',
    Tipo == 'obesidad grado III').

/*-- FIN DE LAS REGLAS DEL ADULTO-HOMBRE --*/


/* ------------------------------------- INICIO DE LAS REGLAS PARA MUJER NIÑA ------------------------------------------ */

/* SI MUJER NIÑA PESO BAJO SENDENTARIA */
si_m_n_pb_sed(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Nino',
    Ejercicio == 'Sedentarismo',
    Tipo == 'peso bajo').

/* SI MUJER NIÑA PESO NORMAL SEDENTARIA */
si_m_n_pn_sed(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Nino',
    Ejercicio == 'Sedentarismo',
    Tipo == 'peso normal').

/* SI MUJER NIÑA SOBREPESO SEDENTARIA */
si_m_n_sp_sed(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Nino',
    Ejercicio == 'Sedentarismo',
    Tipo == 'sobrepeso').

/* SI MUJER NIÑA OBESIDAD I Y SEDENTARIA */
si_m_n_ob1_sed(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Nino',
    Ejercicio == 'Sedentarismo',
    Tipo == 'obesidad grado I').

/* SI MUJER NIÑA OBESIDAD II Y SEDENTARIA */
si_m_n_ob2_sed(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Nino',
    Ejercicio == 'Sedentarismo',
    Tipo == 'obesidad grado II').

/* SI MUJER NIÑA OBESIDAD III Y SEDENTARIA */
si_m_n_ob3_sed(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Nino',
    Ejercicio == 'Sedentarismo',
    Tipo == 'obesidad grado III').

/* SI MUJER NIÑA PESO BAJO Y EJERCICIO LIGERO */
si_m_n_pb_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Nino',
    Ejercicio == 'Ligero',
    Tipo == 'peso bajo').

/* SI MUJER NIÑA PESO NORMAL Y EJERCICIO LIGERO */
si_m_n_pn_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Nino',
    Ejercicio == 'Ligero',
    Tipo == 'peso normal').

/* SI MUJER NIÑA SOBREPESO Y EJERCICIO LIGERO */
si_m_n_sp_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Nino',
    Ejercicio == 'Ligero',
    Tipo == 'sobrepeso').

/* SI MUJER NIÑA OBESIDAD TIPO 1 Y EJERCICIO LIGERO */
si_m_n_ob1_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Nino',
    Ejercicio == 'Ligero',
    Tipo == 'obesidad grado I').

/* SI MUJER NIÑA OBESIDAD TIPO 2 Y EJERCICIO LIGERO */
si_m_n_ob2_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Nino',
    Ejercicio == 'Ligero',
    Tipo == 'obesidad grado II').

/* SI MUJER NIÑA OBESIDAS TIPO 3 Y EJERCICIO LIGERO */
si_m_n_ob3_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Nino',
    Ejercicio == 'Ligero',
    Tipo == 'obesidad grado III').

/* SI MUJER NIÑA PESO BAJO Y EJERCICIO MODEDARO */
si_m_n_pb_ejmod(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Nino',
    Ejercicio == 'Moderado',
    Tipo == 'peso bajo').

/* SI MUJER NIÑA PESO NORMAL Y EJERCICIO MODERADO */
si_m_n_pn_ejmod(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Nino',
    Ejercicio == 'Moderado',
    Tipo == 'peso normal').

/* SI MUJER NIÑA SOBREPESO Y EJERCICIO MODERADO */
si_m_n_sp_ejmod(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Nino',
    Ejercicio == 'Moderado',
    Tipo == 'sobrepeso').

/* SI MUJER NIÑA OBESIDAD TIPO 1 Y EJERCICIO MODERADO */
si_m_n_ob1_ejmod(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Nino',
    Ejercicio == 'Moderado',
    Tipo == 'obesidad grado I').

/* SI MUJER NIÑA OBESIDAD TIPO 2 Y EJERCICIO MODERADO */
si_m_n_ob2_ejmod(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Nino',
    Ejercicio == 'Moderado',
    Tipo =='obesidad grado II').

/* SI MUJER NIÑA OBESIDAD TIPO 3 Y EJERCICIO MODERADO */
si_m_n_ob3_ejmod(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Nino',
    Ejercicio == 'Moderado',
    Tipo == 'obesidad grado III').

/* SI MUJER NIÑA PESO BAJO Y EJERCICIO ALTO */
si_m_n_pb_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Nino',
    Ejercicio == 'Alto',
    Tipo == 'peso bajo').

/* SI MUJER NIÑA PESO NORMAL Y EJERICICIO ALTO */
si_m_n_pn_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Nino',
    Ejercicio == 'Alto',
    Tipo == 'peso normal').

/* SI MUJER NIÑA SOBREPESO Y EJERCICIO ALTO */
si_m_n_sp_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Nino',
    Ejercicio == 'Alto',
    Tipo == 'sobrepeso').

/* SI MUJER NIÑA OBESIDAD TIPO 1 Y EJERCICIO ALTO */
si_m_n_ob1_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Nino',
    Ejercicio == 'Alto',
    Tipo == 'obesidad grado I').

/* SI MUJER NIÑA OBESIDAD TIPO 2 Y EJERCICIO ALTO */
si_m_n_ob2_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Nino',
    Ejercicio == 'Alto',
    Tipo == 'obesidad grado II').

/* SI MUJER NIÑA OBESIDAD TIPO 3 Y EJERCICIO ALTO */
si_m_n_ob3_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Nino',
    Ejercicio == 'Alto',
    Tipo == 'obesidad grado III').

/* SI MUJER NIÑA PESO BAJO Y EJERCICIO EXTREMO */
si_m_n_pb_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Nino',
    Ejercicio == 'Intenso',
    Tipo == 'peso bajo').

/* SI MUJER NIÑA PESO NORMAL Y EJERCICIO EXTREMO */
si_m_n_pn_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Nino',
    Ejercicio == 'Intenso',
    Tipo == 'peso normal').

/* SI MUJER NIÑA SOBREPESO Y EJERCICIO EXTREMO */
si_m_n_sp_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Nino',
    Ejercicio == 'Intenso',
    Tipo == 'sobrepeso').

/* SI MUJER NIÑA OBESIDAD TIPO 1 Y EJERCICIO EXTREMO */
si_m_n_ob1_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Nino',
    Ejercicio == 'Intenso',
    Tipo == 'obesidad grado I').

/* SI MUJER NIÑA OBESIDAD TIPO 2 Y EJERCICIO EXTREMO */
si_m_n_ob2_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Nino',
    Ejercicio == 'Intenso',
    Tipo == 'obesidad grado II').

/* SI MUJER NIÑA OBESIDAD TIPO 3 Y EJERCICIO EXTREMO */
si_m_n_ob3_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Nino',
    Ejercicio == 'Intenso',
    Tipo == 'obesidad grado III').


/* --------------------------------------- INICIO DE LAS REGLAS PARA MUJER JOVEN -------------------------------------------- */

/* SI MUJER JOVEN PESO BAJO SENDENTARIA */
si_m_j_pb_sed(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Joven',
    Ejercicio == 'Sedentarismo',
    Tipo == 'peso bajo').

/* SI MUJER JOVEN PESO NORMAL SEDENTARIA */
si_m_j_pn_sed(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Joven',
    Ejercicio == 'Sedentarismo',
    Tipo == 'peso normal').

/* SI MUJER JOVEN SOBREPESO SEDENTARIA */
si_m_j_sp_sed(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Joven',
    Ejercicio == 'Sedentarismo',
    Tipo == 'sobrepeso').

/* SI MUJER JOVEN OBESIDAD I Y SEDENTARIA */
si_m_j_ob1_sed(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Joven',
    Ejercicio == 'Sedentarismo',
    Tipo == 'obesidad grado I').

/* SI MUJER JOVEN OBESIDAD II Y SEDENTARIA */
si_m_j_ob2_sed(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Joven',
    Ejercicio == 'Sedentarismo',
    Tipo == 'obesidad grado II').

/* SI MUJER JOVEN OBESIDAD III Y SEDENTARIA */
si_m_j_ob3_sed(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Joven',
    Ejercicio == 'Sedentarismo',
    Tipo == 'obesidad grado III').

/* SI MUJER JOVEN PESO BAJO Y EJERCICIO LIGERO */
si_m_j_pb_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Joven',
    Ejercicio == 'Ligero',
    Tipo == 'peso bajo').

/* SI MUJER JOVEN PESO NORMAL Y EJERCICIO LIGERO */
si_m_j_pn_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Joven',
    Ejercicio == 'Ligero',
    Tipo == 'peso normal').

/* SI MUJER JOVEN SOBREPESO Y EJERCICIO LIGERO */
si_m_j_sp_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Joven',
    Ejercicio == 'Ligero',
    Tipo == 'sobrepeso').

/* SI MUJER JOVEN OBESIDAD TIPO 1 Y EJERCICIO LIGERO */
si_m_j_ob1_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Joven',
    Ejercicio == 'Ligero',
    Tipo == 'obesidad grado I').

/* SI MUJER JOVEN OBESIDAD TIPO 2 Y EJERCICIO LIGERO */
si_m_j_ob2_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Joven',
    Ejercicio == 'Ligero',
    Tipo == 'obesidad grado II').

/* SI MUJER JOVEN OBESIDAS TIPO 3 Y EJERCICIO LIGERO */
si_m_j_ob3_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Joven',
    Ejercicio == 'Ligero',
    Tipo == 'obesidad grado III').

/* SI MUJER JOVEN PESO BAJO Y EJERCICIO MODEDARO */
si_m_j_pb_ejmod(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Joven',
    Ejercicio == 'Moderado',
    Tipo == 'peso bajo').

/* SI MUJER JOVEN PESO NORMAL Y EJERCICIO MODERADO */
si_m_j_pn_ejmod(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Joven',
    Ejercicio == 'Moderado',
    Tipo == 'peso normal').

/* SI MUJER JOVEN SOBREPESO Y EJERCICIO MODERADO */
si_m_j_sp_ejmod(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Joven',
    Ejercicio == 'Moderado',
    Tipo == 'sobrepeso').

/* SI MUJER JOVEN OBESIDAD TIPO 1 Y EJERCICIO MODERADO */
si_m_j_ob1_ejmod(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Joven',
    Ejercicio == 'Moderado',
    Tipo == 'obesidad grado I').

/* SI MUJER JOVEN OBESIDAD TIPO 2 Y EJERCICIO MODERADO */
si_m_j_ob2_ejmod(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Joven',
    Ejercicio == 'Moderado',
    Tipo =='obesidad grado II').

/* SI MUJER JOVEN OBESIDAD TIPO 3 Y EJERCICIO MODERADO */
si_m_j_ob3_ejmod(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Joven',
    Ejercicio == 'Moderado',
    Tipo == 'obesidad grado III').

/* SI MUJER JOVEN PESO BAJO Y EJERCICIO ALTO */
si_m_j_pb_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Joven',
    Ejercicio == 'Alto',
    Tipo == 'peso bajo').

/* SI MUJER Joven PESO NORMAL Y EJERICICIO ALTO */
si_m_j_pn_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Joven',
    Ejercicio == 'Alto',
    Tipo == 'peso normal').

/* SI MUJER JOVEN SOBREPESO Y EJERCICIO ALTO */
si_m_j_sp_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Joven',
    Ejercicio == 'Alto',
    Tipo == 'sobrepeso').

/* SI MUJER JOVEN OBESIDAD TIPO 1 Y EJERCICIO ALTO */
si_m_j_ob1_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Joven',
    Ejercicio == 'Alto',
    Tipo == 'obesidad grado I').

/* SI MUJER JOVEN OBESIDAD TIPO 2 Y EJERCICIO ALTO */
si_m_j_ob2_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Joven',
    Ejercicio == 'Alto',
    Tipo == 'obesidad grado II').

/* SI MUJER JOVEN OBESIDAD TIPO 3 Y EJERCICIO ALTO */
si_m_j_ob3_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Joven',
    Ejercicio == 'Alto',
    Tipo == 'obesidad grado III').

/* SI MUJER JOVEN PESO BAJO Y EJERCICIO EXTREMO */
si_m_j_pb_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Joven',
    Ejercicio == 'Intenso',
    Tipo == 'peso bajo').

/* SI MUJER JOVEN PESO NORMAL Y EJERCICIO EXTREMO */
si_m_j_pn_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Joven',
    Ejercicio == 'Intenso',
    Tipo == 'peso normal').

/* SI MUJER JOVEN SOBREPESO Y EJERCICIO EXTREMO */
si_m_j_sp_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Joven',
    Ejercicio == 'Intenso',
    Tipo == 'sobrepeso').

/* SI MUJER JOVEN OBESIDAD TIPO 1 Y EJERCICIO EXTREMO */
si_m_j_ob1_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Joven',
    Ejercicio == 'Intenso',
    Tipo == 'obesidad grado I').

/* SI MUJER JOVEN OBESIDAD TIPO 2 Y EJERCICIO EXTREMO */
si_m_j_ob2_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Joven',
    Ejercicio == 'Intenso',
    Tipo == 'obesidad grado II').

/* SI MUJER JOVEN OBESIDAD TIPO 3 Y EJERCICIO EXTREMO */
si_m_j_ob3_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Joven',
    Ejercicio == 'Intenso',
    Tipo == 'obesidad grado III').

/* --------------------------------------- INICIO DE LAS REGLAS PARA MUJER ADULTO -------------------------------------------- */

/* SI MUJER ADULTO PESO BAJO SENDENTARIA */
si_m_a_pb_sed(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Adulto',
    Ejercicio == 'Sedentarismo',
    Tipo == 'peso bajo').

/* SI MUJER ADULTO PESO NORMAL SEDENTARIA */
si_m_a_pn_sed(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Adulto',
    Ejercicio == 'Sedentarismo',
    Tipo == 'peso normal').

/* SI MUJER ADULTO SOBREPESO SEDENTARIA */
si_m_a_sp_sed(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Adulto',
    Ejercicio == 'Sedentarismo',
    Tipo == 'sobrepeso').

/* SI MUJER ADULTO OBESIDAD I Y SEDENTARIA */
si_m_a_ob1_sed(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Adulto',
    Ejercicio == 'Sedentarismo',
    Tipo == 'obesidad grado I').

/* SI MUJER ADULTO OBESIDAD II Y SEDENTARIA */
si_m_a_ob2_sed(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Adulto',
    Ejercicio == 'Sedentarismo',
    Tipo == 'obesidad grado II').

/* SI MUJER ADULTO OBESIDAD III Y SEDENTARIA */
si_m_a_ob3_sed(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Adulto',
    Ejercicio == 'Sedentarismo',
    Tipo == 'obesidad grado III').

/* SI MUJER ADULTO PESO BAJO Y EJERCICIO LIGERO */
si_m_a_pb_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Adulto',
    Ejercicio == 'Ligero',
    Tipo == 'peso bajo').

/* SI MUJER ADULTO PESO NORMAL Y EJERCICIO LIGERO */
si_m_a_pn_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Adulto',
    Ejercicio == 'Ligero',
    Tipo == 'peso normal').

/* SI MUJER ADULTO SOBREPESO Y EJERCICIO LIGERO */
si_m_a_sp_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Adulto',
    Ejercicio == 'Ligero',
    Tipo == 'sobrepeso').

/* SI MUJER ADULTO OBESIDAD TIPO 1 Y EJERCICIO LIGERO */
si_m_a_ob1_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Adulto',
    Ejercicio == 'Ligero',
    Tipo == 'obesidad grado I').

/* SI MUJER ADULTO OBESIDAD TIPO 2 Y EJERCICIO LIGERO */
si_m_a_ob2_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Adulto',
    Ejercicio == 'Ligero',
    Tipo == 'obesidad grado II').

/* SI MUJER ADULTO OBESIDAS TIPO 3 Y EJERCICIO LIGERO */
si_m_a_ob3_ejligero(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Adulto',
    Ejercicio == 'Ligero',
    Tipo == 'obesidad grado III').

/* SI MUJER ADULTO PESO BAJO Y EJERCICIO MODEDARO */
si_m_a_pb_ejmod(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Adulto',
    Ejercicio == 'Moderado',
    Tipo == 'peso bajo').

/* SI MUJER ADULTO PESO NORMAL Y EJERCICIO MODERADO */
si_m_a_pn_ejmod(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Adulto',
    Ejercicio == 'Moderado',
    Tipo == 'peso normal').

/* SI MUJER ADULTO SOBREPESO Y EJERCICIO MODERADO */
si_m_a_sp_ejmod(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Adulto',
    Ejercicio == 'Moderado',
    Tipo == 'sobrepeso').

/* SI MUJER ADULTO OBESIDAD TIPO 1 Y EJERCICIO MODERADO */
si_m_a_ob1_ejmod(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Adulto',
    Ejercicio == 'Moderado',
    Tipo == 'obesidad grado I').

/* SI MUJER ADULTO OBESIDAD TIPO 2 Y EJERCICIO MODERADO */
si_m_a_ob2_ejmod(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Adulto',
    Ejercicio == 'Moderado',
    Tipo =='obesidad grado II').

/* SI MUJER ADULTO OBESIDAD TIPO 3 Y EJERCICIO MODERADO */
si_m_a_ob3_ejmod(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Adulto',
    Ejercicio == 'Moderado',
    Tipo == 'obesidad grado III').

/* SI MUJER ADULTO PESO BAJO Y EJERCICIO ALTO */
si_m_a_pb_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Adulto',
    Ejercicio == 'Alto',
    Tipo == 'peso bajo').

/* SI MUJER Adulto PESO NORMAL Y EJERICICIO ALTO */
si_m_a_pn_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Adulto',
    Ejercicio == 'Alto',
    Tipo == 'peso normal').

/* SI MUJER ADULTO SOBREPESO Y EJERCICIO ALTO */
si_m_a_sp_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Adulto',
    Ejercicio == 'Alto',
    Tipo == 'sobrepeso').

/* SI MUJER ADULTO OBESIDAD TIPO 1 Y EJERCICIO ALTO */
si_m_a_ob1_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Adulto',
    Ejercicio == 'Alto',
    Tipo == 'obesidad grado I').

/* SI MUJER ADULTO OBESIDAD TIPO 2 Y EJERCICIO ALTO */
si_m_a_ob2_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Adulto',
    Ejercicio == 'Alto',
    Tipo == 'obesidad grado II').

/* SI MUJER ADULTO OBESIDAD TIPO 3 Y EJERCICIO ALTO */
si_m_a_ob3_ejalto(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Adulto',
    Ejercicio == 'Alto',
    Tipo == 'obesidad grado III').

/* SI MUJER ADULTO PESO BAJO Y EJERCICIO EXTREMO */
si_m_a_pb_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Adulto',
    Ejercicio == 'Intenso',
    Tipo == 'peso bajo').

/* SI MUJER ADULTO PESO NORMAL Y EJERCICIO EXTREMO */
si_m_a_pn_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Adulto',
    Ejercicio == 'Intenso',
    Tipo == 'peso normal').

/* SI MUJER ADULTO SOBREPESO Y EJERCICIO EXTREMO */
si_m_a_sp_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Adulto',
    Ejercicio == 'Intenso',
    Tipo == 'sobrepeso').

/* SI MUJER ADULTO OBESIDAD TIPO 1 Y EJERCICIO EXTREMO */
si_m_a_ob1_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Adulto',
    Ejercicio == 'Intenso',
    Tipo == 'obesidad grado I').

/* SI MUJER ADULTO OBESIDAD TIPO 2 Y EJERCICIO EXTREMO */
si_m_a_ob2_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Adulto',
    Ejercicio == 'Intenso',
    Tipo == 'obesidad grado II').

/* SI MUJER ADULTO OBESIDAD TIPO 3 Y EJERCICIO EXTREMO */
si_m_a_ob3_ejintenso(Sexo,Edad,Ejercicio,Altura,Peso,Tipo):- masa_corporal(Altura,Peso,_,_,_,Tipo), (
    Sexo == 'Mujer',
    Edad == 'Adulto',
    Ejercicio == 'Intenso',
    Tipo == 'obesidad grado III').






