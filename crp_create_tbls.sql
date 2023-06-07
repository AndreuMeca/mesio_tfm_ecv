--td_encuesta
create table crpecv.ecv_td_encuesta (
	pk_encuesta VARCHAR ( 50 ),
	pk_entidad_encuesta VARCHAR ( 50 ),
	des_encuesta VARCHAR ( 50 ),
	des_area VARCHAR ( 50 ) 
);
insert into crpecv.ecv_td_encuesta(pk_encuesta, pk_entidad_encuesta, des_encuesta, des_area)
values ('ECV', 'H', 'Encuesta de Condiciones de Vida', 'Hogar'),
		('ECV', 'P', 'Encuesta de Condiciones de Vida', 'Persona');

--td_encuesta_pregunta
create table crpecv.ecv_td_encuesta_pregunta (
	pk_encuesta VARCHAR ( 50 ),
	pk_entidad_encuesta VARCHAR ( 50 ),
	pk_pregunta VARCHAR ( 50 ),
	des_modulo VARCHAR ( 50 ),
	des_serie VARCHAR ( 50 ),
	des_pregunta VARCHAR ( 255 ),
	des_pregunta_corta VARCHAR ( 255 )  
)
;

truncate table crpecv.ecv_td_encuesta_pregunta;

insert into crpecv.ecv_td_encuesta_pregunta(pk_encuesta, pk_entidad_encuesta, pk_pregunta, des_modulo, des_serie, des_pregunta, des_pregunta_corta)
values ('ECV', 'H', 'HY020', 'Renta', 'Renta', 'Renta disponible total del hogar en el año anterior al de la encuesta', 'Renta disponible total del hogar en el año anterior al de la encuesta')
	   , ('ECV', 'H', 'HY022', 'Renta', 'Renta', 'Renta disponible total del hogar antes de transferencias sociales excepto prestaciones por jubilación y por supervivencia en el año anterior al de encuesta', 'Renta total antes de transferencias excepto jubilación y supervivencia (año anterior)')
	   , ('ECV', 'H', 'HY023', 'Renta', 'Renta', 'Renta disponible total del hogar antes de transferencias sociales incluidas prestaciones por jubilación y por supervivencia en el año anterior al de encuesta', 'Renta total antes de transferencias incluidas jubilación y supervivencia (año anterior)')
	   , ('ECV', 'H', 'HY030N', 'Renta', 'Renta Neta', 'Alquiler imputado', 'Alquiler imputado')
	   , ('ECV', 'H', 'HY040N', 'Renta', 'Renta Neta', 'Renta neta procedente del alquiler de una propiedad o terreno en el año anterior al de encuesta', 'Renta neta procedente del alquiler de una propiedad o terreno (año anterior)')
	   , ('ECV', 'H', 'HY050N', 'Renta', 'Renta Neta', 'Ayuda por familia/hijos en el año anterior al de encuesta', 'Ayuda por familia/hijos (año anterior)')
	   , ('ECV', 'H', 'HY060N', 'Renta', 'Renta Neta', 'Ingresos por asistencia social en el año anterior al de encuesta', 'Ingresos por asistencia social (año anterior)')
	   , ('ECV', 'H', 'HY070N', 'Renta', 'Renta Neta', 'Ayuda para vivienda en el año anterior al de la encuesta', 'Ayuda para vivienda (año anterior)')
	   , ('ECV', 'H', 'HY080N', 'Renta', 'Renta Neta', 'Transferencias periódicas monetarias percibidas de otros hogares en el año anterior al de la encuesta', 'Transferencias periódicas monetarias percibidas de otros hogares (año anterior)')
	   , ('ECV', 'H', 'HY090N', 'Renta', 'Renta Neta', 'Intereses, dividendos y ganancias netos de inversiones 	de capital en empresas no constituidas en sociedad en el año anterior al de encuesta', 'Intereses, dividendos y ganancias netos de inversiones de capital en empresas no constituidas en sociedad (año anterior)')
	   , ('ECV', 'H', 'HY100N', 'Renta', 'Renta Neta', 'Intereses pagados del préstamo para la compra de la vivienda principal, en el año anterior al de encuesta', 'Intereses pagados del préstamo para la compra de la vivienda principal (año anterior)')
	   , ('ECV', 'H', 'HY110N', 'Renta', 'Renta Neta', 'Renta neta percibida por los menores de 16 años en el año anterior al de la encuesta', 'Renta neta percibida por los menores de 16 años (año anterior)')
	   , ('ECV', 'H', 'HY120N', 'Renta', 'Renta Neta', 'Impuesto sobre el patrimonio en el año anterior al de la encuesta', 'Impuesto sobre el patrimonio (año anterior)')
	   , ('ECV', 'H', 'HY130N', 'Renta', 'Renta Neta', 'Transferencias periódicas monetarias abonadas a otros  hogares en el año anterior al de la encuesta', 'Transferencias periódicas monetarias abonadas a otros hogares(año anterior)')
	   , ('ECV', 'H', 'HY145N', 'Renta', 'Renta Neta', 'Devoluciones/ingresos complementarios por ajustes en impuestos en el año anterior al de la encuesta (declaración del IRPF)', 'Devoluciones/ingresos complementarios por ajustes en impuestos(año anterior)')
	   , ('ECV', 'H', 'HY170N', 'Renta', 'Renta Neta', 'Autoconsumo en el año anterior al de la encuesta', 'Autoconsumo (año anterior)')
	   , ('ECV', 'H', 'HY010', 'Renta', 'Renta Bruta', 'Renta bruta total del hogar en el año anterior al de la encuesta', 'Renta bruta total del hogar (año anterior)')
	   , ('ECV', 'H', 'HY040G', 'Renta', 'Renta Bruta', 'Renta bruta procedente del alquiler de una propiedad o terreno en el año anterior al de la encuesta', 'Renta bruta procedente del alquiler de una propiedad o terreno (año anterior)')
	   , ('ECV', 'H', 'HY050G', 'Renta', 'Renta Bruta', 'Ayuda por familia/hijos en el año anterior al de la encuesta', 'Ayuda por familia/hijos (año anterior)')
	   , ('ECV', 'H', 'HY060G', 'Renta', 'Renta Bruta', 'Ingresos por asistencia social en el año anterior al de la encuesta', 'Ingresos por asistencia social (año anterior)')
	   , ('ECV', 'H', 'HY070G', 'Renta', 'Renta Bruta', 'Ayuda para vivienda en el año anterior al de la encuesta', 'Ayuda para vivienda (año anterior)')
	   , ('ECV', 'H', 'HY080G', 'Renta', 'Renta Bruta', 'Transferencias periódicas monetarias percibidas de otros hogares en el año anterior al de encuesta', 'Transferencias periódicas monetarias percibidas de otros hogares (año anterior)')
	   , ('ECV', 'H', 'HY090G', 'Renta', 'Renta Bruta', 'Intereses, dividendos y ganancias brutos de inversiones de capital en empresas no constituidas en sociedad en el año anterior al de encuesta', 'Intereses, dividendos y ganancias brutos de inversiones de capital en empresas no constituidas en sociedad (año anterior)')
	   , ('ECV', 'H', 'HY100G', 'Renta', 'Renta Bruta', 'Intereses pagados del préstamo para la compra de la vivienda principal, en el año anterior al de encuesta', 'Intereses pagados del préstamo para la compra de la vivienda principal (año anterior)')
	   , ('ECV', 'H', 'HY110G', 'Renta', 'Renta Bruta', 'Renta bruta percibida por los menores de 16 años en el año anterior al de encuesta', 'Renta bruta percibida por los menores de 16 años (año anterior)')
	   , ('ECV', 'H', 'HY120G', 'Renta', 'Renta Bruta', 'Impuesto sobre el patrimonio en el año anterior al de encuesta', 'Impuesto sobre el patrimonio (año anterior)')
	   , ('ECV', 'H', 'HY130G', 'Renta', 'Renta Bruta', 'Transferencias periódicas monetarias abonadas a otros  hogares en el año anterior al de encuesta', 'Transferencias periódicas monetarias abonadas a otros hogares (año anterior)')
	   , ('ECV', 'H', 'HY140G', 'Renta', 'Renta Bruta', 'Impuesto sobre la renta y cotizaciones sociales (incluida la declaración del IRPF)', 'Impuesto sobre la renta y cotizaciones sociales')
	   , ('ECV', 'H', 'HS011', 'Exclusión Social', 'Exclusión Social', '¿Se han producido retrasos en el pago de la hipoteca o del alquiler del hogar en los últimos 12 meses?', '¿Se han producido retrasos en el pago de la hipoteca o del alquiler del hogar?')
	   , ('ECV', 'H', 'HS021', 'Exclusión Social', 'Exclusión Social', '¿Se han producido retrasos en el pago de las facturas de la electricidad, agua, gas, etc. en los últimos 12 meses?', '¿Se han producido retrasos en el pago de las facturas de la electricidad, agua, gas, etc.?')
	   , ('ECV', 'H', 'HS031', 'Exclusión Social', 'Exclusión Social', '¿Se han producido retrasos en el pago de compras aplazadas o de otros préstamos (deudas no relacionadas con la vivienda principal) en los últimos 12 meses?', '¿Se han producido retrasos en el pago de compras aplazadas o de otros préstamos?')
	   , ('ECV', 'H', 'HS040', 'Exclusión Social', 'Exclusión Social', '¿Puede el hogar permitirse pagar unas vacaciones fuera de casa, al menos una semana al año?', '¿Puede el hogar permitirse pagar unas vacaciones fuera de casa, al menos una semana al año?')
	   , ('ECV', 'H', 'HS050', 'Exclusión Social', 'Exclusión Social', '¿Puede el hogar permitirse una comida de carne, pollo o pescado (o equivalentes para los vegetarianos) al menos cada dos días?', '¿Puede el hogar permitirse una comida de carne, pollo o pescado al menos cada dos días?')
	   , ('ECV', 'H', 'HS060', 'Exclusión Social', 'Exclusión Social', '¿Tiene el hogar capacidad para afrontar gastos imprevistos?', '¿Tiene el hogar capacidad para afrontar gastos imprevistos?')
	   , ('ECV', 'H', 'HS070', 'Exclusión Social', 'Exclusión Social', '¿Tiene el hogar teléfono (incluido móvil)?', '¿Tiene el hogar teléfono?')
	   , ('ECV', 'H', 'HS080', 'Exclusión Social', 'Exclusión Social', '¿Tiene el hogar televisión en color?', '¿Tiene el hogar televisión en color?')
	   , ('ECV', 'H', 'HS090', 'Exclusión Social', 'Exclusión Social', '¿Tiene el hogar ordenador?', '¿Tiene el hogar ordenador?')
	   , ('ECV', 'H', 'HS100', 'Exclusión Social', 'Exclusión Social', '¿Tiene el hogar lavadora?', '¿Tiene el hogar lavadora?')
	   , ('ECV', 'H', 'HS110', 'Exclusión Social', 'Exclusión Social', '¿Tiene el hogar coche?', '¿Tiene el hogar coche?')
	   , ('ECV', 'H', 'HS120', 'Exclusión Social', 'Exclusión Social', 'Capacidad del hogar para llegar a fin de mes', 'Capacidad del hogar para llegar a fin de mes')
	   , ('ECV', 'H', 'HS130', 'Exclusión Social', 'Exclusión Social', 'Ingresos mínimos para llegar a final de mes', 'Ingresos mínimos para llegar a final de mes')
	   , ('ECV', 'H', 'HS140', 'Exclusión Social', 'Exclusión Social', 'Los gastos totales de la vivienda (incluyendo seguros, electricidad, comunidad, etc.) suponen para el hogar', 'Los gastos totales de la vivienda suponen para el hogar')
	   , ('ECV', 'H', 'HS150', 'Exclusión Social', 'Exclusión Social', 'Los desembolsos por compras a plazos o por devolución de préstamos no relacionados con la vivienda suponen para el hogar', 'Los desembolsos por compras a plazos o por devolución de préstamos no relacionados con la vivienda suponen para el hogar')
	   , ('ECV', 'H', 'HH010', 'Vivienda', 'Vivienda', 'Tipo de vivienda', 'Tipo de vivienda')
	   , ('ECV', 'H', 'HH020', 'Vivienda', 'Vivienda', 'Régimen de tenencia', 'Régimen de tenencia')
	   , ('ECV', 'H', 'HH021', 'Vivienda', 'Vivienda', 'Régimen de tenencia', 'Régimen de tenencia')
	   , ('ECV', 'H', 'HH030', 'Vivienda', 'Vivienda', 'Numero de habitaciones de la vivienda', 'Numero de habitaciones de la vivienda')
	   , ('ECV', 'H', 'HH031', 'Vivienda', 'Vivienda', 'Año del contrato o de la compra o de instalación', 'Año del contrato o de la compra o de instalación')
	   , ('ECV', 'H', 'HH040', 'Vivienda', 'Vivienda', '¿Tiene la vivienda problema de goteras, humedades en paredes, suelos, techos o cimientos, o podredumbre en suelos, marcos de ventanas o puertas?', '¿Tiene la vivienda problema de goteras, humedades o podredumbre?')
	   , ('ECV', 'H', 'HH050', 'Vivienda', 'Vivienda', '¿Puede el hogar permitirse mantener la vivienda con una temperatura adecuada durante los meses de invierno?', '¿Puede el hogar permitirse mantener la vivienda con una temperatura adecuada durante los meses de invierno?')
	   , ('ECV', 'H', 'HH060', 'Vivienda', 'Vivienda', 'Alquiler actual por la vivienda ocupada', 'Alquiler actual por la vivienda ocupada')
	   , ('ECV', 'H', 'HH061', 'Vivienda', 'Vivienda', '¿Cuál cree usted que sería el importe mensual que tendría que pagar por el alquiler de una vivienda como ésta a precio de mercado?', '¿Cuál cree usted que sería el importe mensual que tendría que pagar por el alquiler de una vivienda como ésta a precio de mercado?')
	   , ('ECV', 'H', 'HH070', 'Vivienda', 'Vivienda', 'Gastos de la vivienda: Alquiler (si la vivienda se encuentra en régimen de alquiler), intereses de la hipoteca (para viviendas en propiedad con pagos pendientes) y otros gastos asociados (comunidad, agua, electricidad, gas, etc.)', 'Gastos de la vivienda')
	   , ('ECV', 'H', 'HH081', 'Vivienda', 'Vivienda', '¿Dispone la vivienda de bañera o ducha?', '¿Dispone la vivienda de bañera o ducha?')
	   , ('ECV', 'H', 'HH091', 'Vivienda', 'Vivienda', '¿Dispone de inodoro con agua corriente en el interior de la vivienda?', '¿Dispone de inodoro con agua corriente en el interior de la vivienda?')
	   , ('ECV', 'P', 'PE040', 'Educación', 'Educación', 'Nivel de los estudios terminados', 'Nivel de los estudios terminados')
	   , ('ECV', 'P', 'PL031', 'Datos Laborales', 'Datos Laborales', 'Situación en relación con la actividad definida por el interesado', 'Situación en relación con la actividad definida por el interesado')
	   , ('ECV', 'P', 'PL020', 'Datos Laborales', 'Datos Laborales', '¿Buscó un trabajo activamente durante las 4 semanas anteriores?', '¿Buscó un trabajo activamente durante las 4 semanas anteriores?')
	   , ('ECV', 'P', 'PL025', 'Datos Laborales', 'Datos Laborales', '¿Está disponible para trabajar en las próximas 2 semanas?', '¿Está disponible para trabajar en las próximas 2 semanas?')
	   , ('ECV', 'P', 'PL040', 'Datos Laborales', 'Datos Laborales', 'Situación profesional', 'Situación profesional')
	   , ('ECV', 'P', 'PL060', 'Datos Laborales', 'Datos Laborales', 'Número de horas trabajadas normalmente por semana en el trabajo principal', 'Número de horas trabajadas normalmente por semana en el trabajo principal')
	   , ('ECV', 'P', 'PL140', 'Datos Laborales', 'Datos Laborales', 'Tipo de contrato', 'Tipo de contrato')
	   , ('ECV', 'P', 'PL160', 'Datos Laborales', 'Datos Laborales', '¿Ha cambiado de trabajo en los últimos 12 meses?', '¿Ha cambiado de trabajo en los últimos 12 meses?')
	   , ('ECV', 'P', 'PL170', 'Datos Laborales', 'Datos Laborales', 'Motivo para el cambio', 'Motivo para el cambio')
	   , ('ECV', 'P', 'PL180', 'Datos Laborales', 'Datos Laborales', 'Cambio más reciente en la situación de actividad de la persona', 'Cambio más reciente en la situación de actividad de la persona')
	   , ('ECV', 'P', 'PL190', 'Datos Laborales', 'Datos Laborales', '¿A qué edad empezó a trabajar regularmente?', '¿A qué edad empezó a trabajar regularmente?')
	   , ('ECV', 'P', 'PL200', 'Datos Laborales', 'Datos Laborales', 'Número de años pasados en trabajo remunerado', 'Número de años pasados en trabajo remunerado')
	   , ('ECV', 'P', 'PL211A', 'Datos Laborales', 'Datos Laborales', 'Actividad principal en Enero', 'Actividad principal en Enero')
	   , ('ECV', 'P', 'PL211B', 'Datos Laborales', 'Datos Laborales', 'Actividad principal en Febrero', 'Actividad principal en Febrero')
	   , ('ECV', 'P', 'PL211C', 'Datos Laborales', 'Datos Laborales', 'Actividad principal en Marzo', 'Actividad principal en Marzo')
	   , ('ECV', 'P', 'PL211D', 'Datos Laborales', 'Datos Laborales', 'Actividad principal en Abril', 'Actividad principal en Abril')
	   , ('ECV', 'P', 'PL211E', 'Datos Laborales', 'Datos Laborales', 'Actividad principal en Mayo', 'Actividad principal en Mayo')
	   , ('ECV', 'P', 'PL211F', 'Datos Laborales', 'Datos Laborales', 'Actividad principal en Junio', 'Actividad principal en Junio')
	   , ('ECV', 'P', 'PL211G', 'Datos Laborales', 'Datos Laborales', 'Actividad principal en Julio', 'Actividad principal en Julio')
	   , ('ECV', 'P', 'PL211H', 'Datos Laborales', 'Datos Laborales', 'Actividad principal en Agosto', 'Actividad principal en Agosto')
	   , ('ECV', 'P', 'PL211I', 'Datos Laborales', 'Datos Laborales', 'Actividad principal en Septiembre', 'Actividad principal en Septiembre')
	   , ('ECV', 'P', 'PL211J', 'Datos Laborales', 'Datos Laborales', 'Actividad principal en Octubre', 'Actividad principal en Octubre')
	   , ('ECV', 'P', 'PL211K', 'Datos Laborales', 'Datos Laborales', 'Actividad principal en Noviembre', 'Actividad principal en Noviembre')
	   , ('ECV', 'P', 'PL211L', 'Datos Laborales', 'Datos Laborales', 'Actividad principal en Diciembre', 'Actividad principal en Diciembre')
	   , ('ECV', 'P', 'PH010', 'Salud', 'Salud', 'Estado general de salud', 'Estado general de salud')
	   , ('ECV', 'P', 'PH020', 'Salud', 'Salud', '¿Tiene alguna enfermedad o problema de salud crónicos?', '¿Tiene alguna enfermedad o problema de salud crónicos?')
	   , ('ECV', 'P', 'PH030', 'Salud', 'Salud', 'Durante al menos los últimos 6 meses, ¿en qué medida se ha visto limitado debido a un problema de salud para realizar las actividades que la gente habitualmente hace?', 'En los últimos 6 meses, ¿Se ha visto limitado debido a un problema de salud para realizar actividades?')
	   , ('ECV', 'P', 'PY010N', 'Renta', 'Renta', 'Renta neta monetaria o cuasi monetaria del asalariado en el año anterior a la entrevista', 'Renta neta monetaria o cuasi monetaria del asalariado (año anterior)')
	   , ('ECV', 'P', 'PY020N', 'Renta', 'Renta', 'Renta neta no monetaria del asalariado en el año anterior a la entrevista', 'Renta neta no monetaria del asalariado (año anterior)')
	   , ('ECV', 'P', 'PY021N', 'Renta', 'Renta', 'Renta neta no monetaria del asalariado en el año anterior a la entrevista (coche de empresa)', 'Renta neta no monetaria del asalariado (año anterior)')
	   , ('ECV', 'P', 'PY035N', 'Renta', 'Renta', 'Aportaciones a planes de pensiones privados individuales en el año anterior a la entrevista', 'Aportaciones a planes de pensiones privados individuales (año anterior)')
	   , ('ECV', 'P', 'PY050N', 'Renta', 'Renta', 'Beneficios o pérdidas monetarios netos de trabajadores por cuenta propia (incluidos derechos de propiedad intelectual) en el año anterior a la entrevista', 'Beneficios o pérdidas monetarios netos de trabajadores por cuenta propia (año anterior)')
	   , ('ECV', 'P', 'PY080N', 'Renta', 'Renta', 'Rentas netas percibidas de esquemas privados de pensiones (distintos de los incluidos en SEEPROS) en el año anterior a la entrevista', 'Rentas netas percibidas de esquemas privados de pensiones (año anterior)')
	   , ('ECV', 'P', 'PY090N', 'Renta', 'Renta', 'Prestaciones por desempleo (netas) en el año anterior a la entrevista', 'Prestaciones por desempleo (año anterior)')
	   , ('ECV', 'P', 'PY100N', 'Renta', 'Renta', 'Prestaciones por jubilación (netas) en el año anterior a la entrevista', 'Prestaciones por jubilación (año anterior)')
	   , ('ECV', 'P', 'PY110N', 'Renta', 'Renta', 'Prestaciones por supervivencia (netas) en el año anterior a la entrevista', 'Prestaciones por supervivencia (año anterior)')
	   , ('ECV', 'P', 'PY120N', 'Renta', 'Renta', 'Prestaciones por enfermedad (netas) en el año anterior a la entrevista', 'Prestaciones por enfermedad (año anterior)')
	   , ('ECV', 'P', 'PY130N', 'Renta', 'Renta', 'Prestaciones por invalidez (netas) en el año anterior a la entrevista', 'Prestaciones por invalidez (año anterior)')
	   , ('ECV', 'P', 'PY140N', 'Renta', 'Renta', 'Ayuda para estudios en el año anterior al de la entrevista', 'Ayuda para estudios (año anterior)')
	   , ('ECV', 'P', 'PY010G', 'Renta', 'Renta Bruta', 'Renta bruta monetaria o cuasi monetaria del asalariado en el año anterior al de entrevista', 'Renta bruta monetaria o cuasi monetaria del asalariado (año anterior)')
	   , ('ECV', 'P', 'PY020G', 'Renta', 'Renta Bruta', 'Renta bruta no monetaria del asalariado en el año anterior al de entrevista', 'Renta bruta no monetaria del asalariado (año anterior)')
	   , ('ECV', 'P', 'PY021G', 'Renta', 'Renta Bruta', 'Renta bruta no monetaria del asalariado en el año anterior al de entrevista (coche de empresa)', 'Renta bruta no monetaria del asalariado (año anterior)')
	   , ('ECV', 'P', 'PY030G', 'Renta', 'Renta Bruta', 'Cotizaciones sociales a cargo del empleador en el año anterior al de entrevista', 'Cotizaciones sociales a cargo del empleador (año anterior)')
	   , ('ECV', 'P', 'PY035G', 'Renta', 'Renta Bruta', 'Aportaciones a planes de pensiones privados individuales en el año anterior al de entrevista', 'Aportaciones a planes de pensiones privados individuales (año anterior)')
	   , ('ECV', 'P', 'PY050G', 'Renta', 'Renta Bruta', 'Beneficios o pérdidas monetarios brutos de trabajadores por cuenta propia (incluidos derechos de propiedad intelectual) en el año anterior al de entrevista', 'Beneficios o pérdidas monetarios brutos de trabajadores por cuenta propia (año anterior)')
	   , ('ECV', 'P', 'PY080G', 'Renta', 'Renta Bruta', 'Rentas brutas percibidas de esquemas privados de pensiones (distintos de los incluidos en SEEPROS) en el año anterior al de entrevista', 'Rentas brutas percibidas de esquemas privados de pensiones (año anterior)')
	   , ('ECV', 'P', 'PY090G', 'Renta', 'Renta Bruta', 'Prestaciones por desempleo (brutas) en el año anterior al de entrevista', 'Prestaciones por desempleo (año anterior)')
	   , ('ECV', 'P', 'PY100G', 'Renta', 'Renta Bruta', 'Prestaciones por jubilación (brutas) en el año anterior al de entrevista', 'Prestaciones por jubilación (año anterior)')
	   , ('ECV', 'P', 'PY110G', 'Renta', 'Renta Bruta', 'Prestaciones por supervivencia (brutas) en el año anterior al de entrevista', 'Prestaciones por supervivencia (año anterior)')
	   , ('ECV', 'P', 'PY120G', 'Renta', 'Renta Bruta', 'Prestaciones por enfermedad (brutas) en el año anterior al de entrevista', 'Prestaciones por enfermedad (año anterior)')
	   , ('ECV', 'P', 'PY130G', 'Renta', 'Renta Bruta', 'Prestaciones por invalidez (brutas) en el año anterior al de entrevista', 'Prestaciones por invalidez (año anterior)')
	   , ('ECV', 'P', 'PY140G', 'Renta', 'Renta Bruta', 'Ayuda para estudios en el año anterior al de entrevista', 'Ayuda para estudios (año anterior)')   
;

--tx_encuesta_respuesta
create table crpecv.ecv_tx_encuesta_respuesta as
select * from (
	with t as (
	select 
		'ECV' as PK_ENCUESTA
		, 'H' as PK_ENTIDAD_ENCUESTA
		, "HB010" as PK_ANYO
		, "HB030" as PK_ENTIDAD
		, "HY020"
		, "HY020" as "DES_HY020"
		--, "HY020_F"
		, "HY022"
		, "HY022" as "DES_HY022"
		--, "HY022_F"
		, "HY023"
		, "HY023" as "DES_HY023"
		--, "HY023_F"
		, "HY030N" 
		, "HY030N" as "DES_HY030N"
		--, "HY030N_F"
		, "HY040N"
		, "HY040N" as "DES_HY040N"
		--, "HY040N_F"
		, "HY050N"
		, "HY050N" as "DES_HY050N"
		--, "HY050N_F"
		, "HY060N"
		, "HY060N" as "DES_HY060N"
		--, "HY060N_F"
		, "HY070N"
		, "HY070N" as "DES_HY070N"
		--, "HY070N_F"
		, "HY080N"
		, "HY080N" as "DES_HY080N"
		--, "HY080N_F"
		, "HY090N"
		, "HY090N" as "DES_HY090N"
		--, "HY090N_F"
		, "HY100N"
		, "HY100N" as "DES_HY100N"
		--, "HY100N_F"
		, "HY110N"
		, "HY110N" as "DES_HY110N"
		--, "HY110N_F"
		, "HY120N"
		, "HY120N" as "DES_HY120N"
		--, "HY120N_F"
		, "HY130N"
		, "HY130N" as "DES_HY130N"
		--, "HY130N_F"
		, "HY145N"
		, "HY145N" as "DES_HY145N"
		--, "HY145N_F"
		, "HY170N"
		, "HY170N" as "DES_HY170N"
		--, "HY170N_F"
		, "HY010"
		, "HY010" as "DES_HY010"
		--, "HY010_F"
		, "HY040G"
		, "HY040G" as "DES_HY040G"
		--, "HY040G_F"
		, "HY050G"
		, "HY050G" as "DES_HY050G"
		--, "HY050G_F"
		, "HY060G"
		, "HY060G" as "DES_HY060G"
		--, "HY060G_F"
		, "HY070G" 
		, "HY070G" as "DES_HY070G"
		--, "HY070G_F"
		, "HY080G"
		, "HY080G" as "DES_HY080G"
		--, "HY080G_F"
		, "HY090G"
		, "HY090G" as "DES_HY090G"
		--, "HY090G_F"
		, "HY100G"
		, "HY100G" as "DES_HY100G"
		--, "HY100G_F"
		, "HY110G"
		, "HY110G" as "DES_HY110G"
		--, "HY110G_F"
		, "HY120G"
		, "HY120G" as "DES_HY120G"
		--, "HY120G_F"
		, "HY130G"
		, "HY130G" as "DES_HY130G"
		--, "HY130G_F"
		, "HY140G"
		, "HY140G" as "DES_HY140G"
		--, "HY140G_F"
		, "HS011"
		, case 
				when "HS011" = '1' then 'Sí, solamente una vez'
				when "HS011" = '2' then 'Sí, dos veces o más'
				when "HS011" = '3' then 'No'
		 	end as "DES_HS011"
		--, "HS011_F"
		, "HS021"
		, case 
			when "HS021" = '1' then 'Sí, solamente una vez'
			when "HS021" = '2' then 'Sí, dos veces o más'
			when "HS021" = '3' then 'No'
		end as "DES_HS021"
		--, "HS021_F"
		, "HS031"
		, case 
			when "HS031" = '1' then 'Sí, solamente una vez'
			when "HS031" = '2' then 'Sí, dos veces o más'
			when "HS031" = '3' then 'No'
		end as "DES_HS031"
		--, "HS031_F"
		, "HS040"
		, case 
			when "HS040" = '1' then 'Sí'
			when "HS040" = '2' then 'No'
		end as "DES_HS040"
		--, "HS040_F"
		, "HS050"
		, case 
			when "HS050" = '1' then 'Sí'
			when "HS050" = '2' then 'No'
		end as "DES_HS050"
		--, "HS050_F"
		, "HS060"
		, case 
			when "HS060" = '1' then 'Sí'
			when "HS060" = '2' then 'No'
		end as "DES_HS060"
		--, "HS060_F"
		, "HS070"
		, case 
			when "HS070" = '1' then 'Sí'
			when "HS070" = '2' then 'No (por no poder permitírselo)'
			when "HS070" = '3' then 'No (otro motivo)'
		end as "DES_HS070"
		--, "HS070_F"
		, "HS080"
		, case 
			when "HS080" = '1' then 'Sí'
			when "HS080" = '2' then 'No (por no poder permitírselo)'
			when "HS080" = '3' then 'No (otro motivo)'
		end as "DES_HS080"
		--, "HS080_F"
		, "HS090"
		, case 
			when "HS090" = '1' then 'Sí'
			when "HS090" = '2' then 'No (por no poder permitírselo)'
			when "HS090" = '3' then 'No (otro motivo)'
		end as "DES_HS090"
		--, "HS090_F"
		, "HS100"
		, case 
			when "HS100" = '1' then 'Sí'
			when "HS100" = '2' then 'No (por no poder permitírselo)'
			when "HS100" = '3' then 'No (otro motivo)'
		end as "DES_HS100"
		--, "HS100_F"
		, "HS110"
		, case 
			when "HS110" = '1' then 'Sí'
			when "HS110" = '2' then 'No (por no poder permitírselo)'
			when "HS110" = '3' then 'No (otro motivo)'
		end as "DES_HS110"
		--, "HS110_F"
		, "HS120"
		, case 
			when "HS120" = '1' then 'Con mucha dificultad'
			when "HS120" = '2' then 'Con dificultad'
			when "HS120" = '3' then 'Con cierta dificultad'
			when "HS120" = '4' then 'Con cierta facilidad'
			when "HS120" = '5' then 'Con facilidad'
			when "HS120" = '6' then 'Con mucha facilidad'
		end as "DES_HS120"
		--, "HS120_F"
		, "HS130"
		, "HS130" as "DES_HS130"
		--, "HS130_F"
		, "HS140"
		, case 
			when "HS140" = '1' then 'Una carga pesada'
			when "HS140" = '2' then 'Una carga razonable'
			when "HS140" = '3' then 'Ninguna carga'
		end as "DES_HS140"
		--, "HS140_F"
		, "HS150"
		, case 
			when "HS150" = '1' then 'Una carga pesada'
			when "HS150" = '2' then 'Una carga razonable'
			when "HS150" = '3' then 'Ninguna carga'
		end as "DES_HS150"
		--, "HS150_F"
		, "HH010"
		, case 
			when "HH010" = '1' then 'Vivienda unifamiliar independiente'
			when "HH010" = '2' then 'Vivienda unifamiliar adosada o pareada'
			when "HH010" = '3' then 'Piso o apartamento en un edificio con menos de 10 viviendas'
			when "HH010" = '4' then 'Piso o apartamento en un  edificio con 10 viviendas o más'
		end as "DES_HH010"
		--, "HH010_F"
		, "HH020"
		, case 
			when "HH020" = '1' then 'En propiedad'
			when "HH020" = '2' then 'En alquiler o realquiler a precio de mercado'
			when "HH020" = '3' then 'En alquiler o realquiler a precio inferior al de mercado'
			when "HH020" = '4' then 'En cesión gratuita'
		end as "DES_HH020"
		--, "HH020_F"
		, "HH021"
		, case 
			when "HH021" = '1' then 'En propiedad sin hipoteca'
			when "HH021" = '2' then 'En propiedad con hipoteca'
			when "HH021" = '3' then 'En alquiler o realquiler a precio de mercado'
			when "HH021" = '4' then 'En alquiler o realquiler a precio inferior al de mercado'
			when "HH021" = '5' then 'En cesión gratuita'
		end as "DES_HH021"
		--, "HH021_F"
		, "HH030"
		, "HH030" as "DES_HH030"
		--, "HH030_F"
		, "HH031"
		, "HH031" as "DES_HH031"
		--, "HH031_F"
		, "HH040"
		, case 
			when "HH040" = '1' then 'Sí'
			when "HH040" = '2' then 'No'
		end as "DES_HH040"
		--, "HH040_F"
		, "HH050"
		, case 
			when "HH050" = '1' then 'Sí'
			when "HH050" = '2' then 'No'
		end as "DES_HH050"
		--, "HH050_F"
		, "HH060"
		, "HH060" as "DES_HH060"
		--, "HH060_F"
		, "HH061"
		, "HH061" as "DES_HH061"
		--, "HH061_F"
		, "HH070"
		, "HH070" as "DES_HH070"
		--, "HH070_F"
		, "HH081"
		, case 
			when "HH081" = '1' then 'Sí, para uso exclusivo del hogar'
			when "HH081" = '2' then 'Sí, para uso compartido con otros hogares'
			when "HH081" = '3' then 'No'
		end as "DES_HH081"
		--, "HH081_F"
		, "HH091"
		, case 
			when "HH091" = '1' then 'Sí, para uso exclusivo del hogar'
			when "HH091" = '2' then 'Sí, para uso compartido con otros hogares'
			when "HH091" = '3' then 'No'
		end as "DES_HH091"
		--, "HH091_F"
	from stgecv.ecv_raw_hogar
	--where concat("HB010", "HB030") in (select pk_hogar_total from stgecv.ecv_aux_include)
	) 
	select t."pk_encuesta", t."pk_entidad_encuesta", t."pk_anyo", t."pk_entidad", t2."pk_pregunta", t2."cod_respuesta", t2."des_respuesta"
	from t
	cross join lateral (
	     values 
	       ('HY020', t."HY020", t."DES_HY020")
	       , ('HY022', t."HY022", t."DES_HY022")
	       , ('HY023', t."HY023", t."DES_HY023")
	       , ('HY030N', t."HY030N", t."DES_HY030N")
	       , ('HY040N', t."HY040N", t."DES_HY040N")
	       , ('HY050N', t."HY050N", t."DES_HY050N")
	       , ('HY060N', t."HY060N", t."DES_HY060N")
	       , ('HY070N', t."HY070N", t."DES_HY070N")
	       , ('HY080N', t."HY080N", t."DES_HY080N")
	       , ('HY090N', t."HY090N", t."DES_HY090N")
	       , ('HY100N', t."HY100N", t."DES_HY100N")
	       , ('HY110N', t."HY110N", t."DES_HY110N")
	       , ('HY120N', t."HY120N", t."DES_HY120N")
	       , ('HY130N', t."HY130N", t."DES_HY130N")
	       , ('HY145N', t."HY145N", t."DES_HY145N")
	       , ('HY170N', t."HY170N", t."DES_HY170N")
	       , ('HY010', t."HY010", t."DES_HY010")
	       , ('HY040G', t."HY040G", t."DES_HY040G")
	       , ('HY050G', t."HY050G", t."DES_HY050G")
	       , ('HY060G', t."HY060G", t."DES_HY060G")
	       , ('HY070G', t."HY070G", t."DES_HY070G")
	       , ('HY080G', t."HY080G", t."DES_HY080G")
	       , ('HY090G', t."HY090G", t."DES_HY090G")
	       , ('HY100G', t."HY100G", t."DES_HY100G")
	       , ('HY110G', t."HY110G", t."DES_HY110G")
	       , ('HY120G', t."HY120G", t."DES_HY120G")
	       , ('HY130G', t."HY130G", t."DES_HY130G")
	       , ('HY140G', t."HY140G", t."DES_HY140G")
	       , ('HS011', t."HS011", t."DES_HS011")
	       , ('HS021', t."HS021", t."DES_HS021")
	       , ('HS031', t."HS031", t."DES_HS031")
	       , ('HS040', t."HS040", t."DES_HS040")
	       , ('HS050', t."HS050", t."DES_HS050")
	       , ('HS060', t."HS060", t."DES_HS060")
	       , ('HS070', t."HS070", t."DES_HS070")
	       , ('HS080', t."HS080", t."DES_HS080")
	       , ('HS090', t."HS090", t."DES_HS090")
	       , ('HS100', t."HS100", t."DES_HS100")
	       , ('HS110', t."HS110", t."DES_HS110")
	       , ('HS120', t."HS120", t."DES_HS120")
	       , ('HS130', t."HS130", t."DES_HS130")
	       , ('HS140', t."HS140", t."DES_HS140")
	       , ('HS150', t."HS150", t."DES_HS150")
	       , ('HH010', t."HH010", t."DES_HH010")
	       , ('HH020', t."HH020", t."DES_HH020")
	       , ('HH021', t."HH021", t."DES_HH021")
	       , ('HH030', t."HH030", t."DES_HH030")
	       , ('HH031', t."HH031", t."DES_HH031")
	       , ('HH040', t."HH040", t."DES_HH040")
	       , ('HH050', t."HH050", t."DES_HH050")
	       , ('HH060', t."HH060", t."DES_HH060")
	       , ('HH061', t."HH061", t."DES_HH061")
	       , ('HH070', t."HH070", t."DES_HH070")
	       , ('HH081', t."HH081", t."DES_HH081")
	       , ('HH091', t."HH091", t."DES_HH091")
	  ) as t2 (PK_PREGUNTA, COD_RESPUESTA, DES_RESPUESTA)
) tblh
union all
---persona
select * from (
	with t as (
	select 
		'ECV' as PK_ENCUESTA
		, 'P' as PK_ENTIDAD_ENCUESTA
		, "PB010" as PK_ANYO
		, "PB030" as PK_ENTIDAD
		, "PE040"
		, case 
			when "PE040" = '1' then 'Educación primaria'
			when "PE040" = '2' then 'Educación secundaria de 1ª etapa (incluye formación e inserción laboral equivalente)'
			when "PE040" = '3' then 'Educación secundaria de 2ª etapa (incluye formación e inserción laboral equivalente)'
			when "PE040" = '4' then 'Formación e inserción laboral que precisa título de segunda etapa de secundaria'
			when "PE040" = '5' then 'Educación superior'
 		end as "DES_PE040"
		--, "PE040_F"
		, "PL031"
		, case
			when "PL031" = '1' then 'Asalariado a tiempo completo'
			when "PL031" = '2' then 'Asalariado a tiempo parcial'
			when "PL031" = '3' then 'Trabajador por cuenta propia a tiempo completo'
			when "PL031" = '4' then 'Trabajador por cuenta propia a tiempo parcial'
			when "PL031" = '5' then 'Parado'
			when "PL031" = '6' then 'Estudiante, escolar o en formación'
			when "PL031" = '7' then 'Jubilado, retirado, jubilado anticipado o ha cerrado un negocio'
			when "PL031" = '8' then 'Incapacitado permanente para trabajar'
			when "PL031" = '9' then 'Servicio militar obligatorio o prestación social sustitutoria'
			when "PL031" = '10' then 'Dedicado a las labores del hogar, al cuidado de niños u otras personas'
			when "PL031" = '11' then 'Otro clase de inactividad económica'
		end as "DES_PL031"
		--, "PL031_F"
		, "PL020"
		, case
			when "PL020" = '1' then 'Sí'
			when "PL020" = '2' then 'No'
		end as "DES_PL020"
		--, "PL020_F"
		, "PL025"
		, case
			when "PL025" = '1' then 'Sí'
			when "PL025" = '2' then 'No'
		end as "DES_PL025"
		--, "PL025_F"
		, "PL040"
		, case
			when "PL040" = '1' then 'Empleador'
			when "PL040" = '2' then 'Empresario sin asalariados o trabajador independiente'
			when "PL040" = '3' then 'Asalariado'
			when "PL040" = '4' then 'Ayuda familiar'
		end as "DES_PL040"
		--, "PL040_F"
		, "PL060"
		, "PL060" as "DES_PL060"
		--, "PL060_F"
		, "PL140"
		, case
			when "PL140" = '1' then 'Contrato fijo de duración indefinida'
			when "PL140" = '2' then 'Contrato temporal de duración determinada'
		end as "DES_PL140"
		--, "PL140_F"
		, "PL160"
		, case
			when "PL160" = '1' then 'Sí'
			when "PL160" = '2' then 'No'
		end as "DES_PL160"
		--, "PL160_F"
		, "PL170"
		, case 
			when "PL170" = '1' then 'Conseguir un trabajo mejor o más adecuado'
			when "PL170" = '2' then 'Fin de contrato o empleo temporal'
			when "PL170" = '3' then 'Obligado por causas empresariales (cierre, jubilación anticipada, exceso de empleados, etc.)'
			when "PL170" = '4' then 'Venta o cierre del negocio propio o familiar'
			when "PL170" = '5' then 'Cuidado de hijos y otras personas dependientes'
			when "PL170" = '6' then 'Matrimonio o desplazamiento a otra zona debido al trabajo del compañero/a'
			when "PL170" = '7' then 'Otros motivos'
		end as "DES_PL170"
		--, "PL170_F"
		, "PL180"
		, case 
			when "PL180" = '1' then 'Empleado-parado'
			when "PL180" = '2' then 'Empleado-jubilado'
			when "PL180" = '3' then 'Empleado-otra clase de inactividad'
			when "PL180" = '4' then 'Parado-empleado'
			when "PL180" = '5' then 'Parado-jubilado'
			when "PL180" = '6' then 'Parado-otra clase de inactividad'
			when "PL180" = '7' then 'Jubilado-empleado'
			when "PL180" = '8' then 'Jubilado-parado'
			when "PL180" = '9' then 'Jubilado-otra clase de inactividad'
			when "PL180" = '10' then 'Otra clase de inactividad-empleado'
			when "PL180" = '11' then 'Otra clase de inactividad-parado'
			when "PL180" = '12' then 'Otra clase de inactividad-jubilado'
		end as "DES_PL180"
		--, "PL180_F"
		, "PL190"
		, "PL190" as "DES_PL190"
		--, "PL190_F"
		, "PL200"
		, "PL200" as "DES_PL200"
		--, "PL200_F"
		, "PL211A"
		, case 
			when "PL211A" = '1' then 'Asalariado (tiempo completo)'
			when "PL211A" = '2' then 'Asalariado (tiempo parcial)'
			when "PL211A" = '3' then 'Trabajador por cuenta propia (tiempo completo)'
			when "PL211A" = '4' then 'Trabajador por cuenta propia (tiempo parcial)'
			when "PL211A" = '5' then 'Parado'
			when "PL211A" = '6' then 'Estudiante, escolar o en formación'
			when "PL211A" = '7' then 'Jubilado o retirado'
			when "PL211A" = '8' then 'Incapacitado permanente para trabajar'
			when "PL211A" = '9' then 'Servicio militar obligatorio'
			when "PL211A" = '10' then 'Dedicado a las labores del hogar, cuidado de niños, etc.'
			when "PL211A" = '11' then 'Otro tipo de inactividad económica'
		end as "DES_PL211A"
		--, "PL211A_F"
		, "PL211B"
		, case 
			when "PL211B" = '1' then 'Asalariado (tiempo completo)'
			when "PL211B" = '2' then 'Asalariado (tiempo parcial)'
			when "PL211B" = '3' then 'Trabajador por cuenta propia (tiempo completo)'
			when "PL211B" = '4' then 'Trabajador por cuenta propia (tiempo parcial)'
			when "PL211B" = '5' then 'Parado'
			when "PL211B" = '6' then 'Estudiante, escolar o en formación'
			when "PL211B" = '7' then 'Jubilado o retirado'
			when "PL211B" = '8' then 'Incapacitado permanente para trabajar'
			when "PL211B" = '9' then 'Servicio militar obligatorio'
			when "PL211B" = '10' then 'Dedicado a las labores del hogar, cuidado de niños, etc.'
			when "PL211B" = '11' then 'Otro tipo de inactividad económica'
		end as "DES_PL211B"
		--, "PL211B_F"
		, "PL211C"
		, case 
			when "PL211C" = '1' then 'Asalariado (tiempo completo)'
			when "PL211C" = '2' then 'Asalariado (tiempo parcial)'
			when "PL211C" = '3' then 'Trabajador por cuenta propia (tiempo completo)'
			when "PL211C" = '4' then 'Trabajador por cuenta propia (tiempo parcial)'
			when "PL211C" = '5' then 'Parado'
			when "PL211C" = '6' then 'Estudiante, escolar o en formación'
			when "PL211C" = '7' then 'Jubilado o retirado'
			when "PL211C" = '8' then 'Incapacitado permanente para trabajar'
			when "PL211C" = '9' then 'Servicio militar obligatorio'
			when "PL211C" = '10' then 'Dedicado a las labores del hogar, cuidado de niños, etc.'
			when "PL211C" = '11' then 'Otro tipo de inactividad económica'
		end as "DES_PL211C"
		--, "PL211C_F"
		, "PL211D"
		, case 
			when "PL211D" = '1' then 'Asalariado (tiempo completo)'
			when "PL211D" = '2' then 'Asalariado (tiempo parcial)'
			when "PL211D" = '3' then 'Trabajador por cuenta propia (tiempo completo)'
			when "PL211D" = '4' then 'Trabajador por cuenta propia (tiempo parcial)'
			when "PL211D" = '5' then 'Parado'
			when "PL211D" = '6' then 'Estudiante, escolar o en formación'
			when "PL211D" = '7' then 'Jubilado o retirado'
			when "PL211D" = '8' then 'Incapacitado permanente para trabajar'
			when "PL211D" = '9' then 'Servicio militar obligatorio'
			when "PL211D" = '10' then 'Dedicado a las labores del hogar, cuidado de niños, etc.'
			when "PL211D" = '11' then 'Otro tipo de inactividad económica'
		end as "DES_PL211D"
		--, "PL211D_F"
		, "PL211E"
		, case 
			when "PL211E" = '1' then 'Asalariado (tiempo completo)'
			when "PL211E" = '2' then 'Asalariado (tiempo parcial)'
			when "PL211E" = '3' then 'Trabajador por cuenta propia (tiempo completo)'
			when "PL211E" = '4' then 'Trabajador por cuenta propia (tiempo parcial)'
			when "PL211E" = '5' then 'Parado'
			when "PL211E" = '6' then 'Estudiante, escolar o en formación'
			when "PL211E" = '7' then 'Jubilado o retirado'
			when "PL211E" = '8' then 'Incapacitado permanente para trabajar'
			when "PL211E" = '9' then 'Servicio militar obligatorio'
			when "PL211E" = '10' then 'Dedicado a las labores del hogar, cuidado de niños, etc.'
			when "PL211E" = '11' then 'Otro tipo de inactividad económica'
		end as "DES_PL211E"
		--, "PL211E_F"
		, "PL211F"
		, case 
			when "PL211F" = '1' then 'Asalariado (tiempo completo)'
			when "PL211F" = '2' then 'Asalariado (tiempo parcial)'
			when "PL211F" = '3' then 'Trabajador por cuenta propia (tiempo completo)'
			when "PL211F" = '4' then 'Trabajador por cuenta propia (tiempo parcial)'
			when "PL211F" = '5' then 'Parado'
			when "PL211F" = '6' then 'Estudiante, escolar o en formación'
			when "PL211F" = '7' then 'Jubilado o retirado'
			when "PL211F" = '8' then 'Incapacitado permanente para trabajar'
			when "PL211F" = '9' then 'Servicio militar obligatorio'
			when "PL211F" = '10' then 'Dedicado a las labores del hogar, cuidado de niños, etc.'
			when "PL211F" = '11' then 'Otro tipo de inactividad económica'
		end as "DES_PL211F"
		--, "PL211F_F"
		, "PL211G"
		, case 
			when "PL211G" = '1' then 'Asalariado (tiempo completo)'
			when "PL211G" = '2' then 'Asalariado (tiempo parcial)'
			when "PL211G" = '3' then 'Trabajador por cuenta propia (tiempo completo)'
			when "PL211G" = '4' then 'Trabajador por cuenta propia (tiempo parcial)'
			when "PL211G" = '5' then 'Parado'
			when "PL211G" = '6' then 'Estudiante, escolar o en formación'
			when "PL211G" = '7' then 'Jubilado o retirado'
			when "PL211G" = '8' then 'Incapacitado permanente para trabajar'
			when "PL211G" = '9' then 'Servicio militar obligatorio'
			when "PL211G" = '10' then 'Dedicado a las labores del hogar, cuidado de niños, etc.'
			when "PL211G" = '11' then 'Otro tipo de inactividad económica'
		end as "DES_PL211G"
		--, "PL211G_F"
		, "PL211H"
		, case 
			when "PL211H" = '1' then 'Asalariado (tiempo completo)'
			when "PL211H" = '2' then 'Asalariado (tiempo parcial)'
			when "PL211H" = '3' then 'Trabajador por cuenta propia (tiempo completo)'
			when "PL211H" = '4' then 'Trabajador por cuenta propia (tiempo parcial)'
			when "PL211H" = '5' then 'Parado'
			when "PL211H" = '6' then 'Estudiante, escolar o en formación'
			when "PL211H" = '7' then 'Jubilado o retirado'
			when "PL211H" = '8' then 'Incapacitado permanente para trabajar'
			when "PL211H" = '9' then 'Servicio militar obligatorio'
			when "PL211H" = '10' then 'Dedicado a las labores del hogar, cuidado de niños, etc.'
			when "PL211H" = '11' then 'Otro tipo de inactividad económica'
		end as "DES_PL211H"
		--, "PL211H_F"
		, "PL211I"
		, case 
			when "PL211I" = '1' then 'Asalariado (tiempo completo)'
			when "PL211I" = '2' then 'Asalariado (tiempo parcial)'
			when "PL211I" = '3' then 'Trabajador por cuenta propia (tiempo completo)'
			when "PL211I" = '4' then 'Trabajador por cuenta propia (tiempo parcial)'
			when "PL211I" = '5' then 'Parado'
			when "PL211I" = '6' then 'Estudiante, escolar o en formación'
			when "PL211I" = '7' then 'Jubilado o retirado'
			when "PL211I" = '8' then 'Incapacitado permanente para trabajar'
			when "PL211I" = '9' then 'Servicio militar obligatorio'
			when "PL211I" = '10' then 'Dedicado a las labores del hogar, cuidado de niños, etc.'
			when "PL211I" = '11' then 'Otro tipo de inactividad económica'
		end as "DES_PL211I"
		--, "PL211I_F"
		, "PL211J"
		, case 
			when "PL211J" = '1' then 'Asalariado (tiempo completo)'
			when "PL211J" = '2' then 'Asalariado (tiempo parcial)'
			when "PL211J" = '3' then 'Trabajador por cuenta propia (tiempo completo)'
			when "PL211J" = '4' then 'Trabajador por cuenta propia (tiempo parcial)'
			when "PL211J" = '5' then 'Parado'
			when "PL211J" = '6' then 'Estudiante, escolar o en formación'
			when "PL211J" = '7' then 'Jubilado o retirado'
			when "PL211J" = '8' then 'Incapacitado permanente para trabajar'
			when "PL211J" = '9' then 'Servicio militar obligatorio'
			when "PL211J" = '10' then 'Dedicado a las labores del hogar, cuidado de niños, etc.'
			when "PL211J" = '11' then 'Otro tipo de inactividad económica'
		end as "DES_PL211J"
		--, "PL211J_F"
		, "PL211K"
		, case 
			when "PL211K" = '1' then 'Asalariado (tiempo completo)'
			when "PL211K" = '2' then 'Asalariado (tiempo parcial)'
			when "PL211K" = '3' then 'Trabajador por cuenta propia (tiempo completo)'
			when "PL211K" = '4' then 'Trabajador por cuenta propia (tiempo parcial)'
			when "PL211K" = '5' then 'Parado'
			when "PL211K" = '6' then 'Estudiante, escolar o en formación'
			when "PL211K" = '7' then 'Jubilado o retirado'
			when "PL211K" = '8' then 'Incapacitado permanente para trabajar'
			when "PL211K" = '9' then 'Servicio militar obligatorio'
			when "PL211K" = '10' then 'Dedicado a las labores del hogar, cuidado de niños, etc.'
			when "PL211K" = '11' then 'Otro tipo de inactividad económica'
		end as "DES_PL211K"
		--, "PL211K_F"
		, "PL211L"
		, case 
			when "PL211L" = '1' then 'Asalariado (tiempo completo)'
			when "PL211L" = '2' then 'Asalariado (tiempo parcial)'
			when "PL211L" = '3' then 'Trabajador por cuenta propia (tiempo completo)'
			when "PL211L" = '4' then 'Trabajador por cuenta propia (tiempo parcial)'
			when "PL211L" = '5' then 'Parado'
			when "PL211L" = '6' then 'Estudiante, escolar o en formación'
			when "PL211L" = '7' then 'Jubilado o retirado'
			when "PL211L" = '8' then 'Incapacitado permanente para trabajar'
			when "PL211L" = '9' then 'Servicio militar obligatorio'
			when "PL211L" = '10' then 'Dedicado a las labores del hogar, cuidado de niños, etc.'
			when "PL211L" = '11' then 'Otro tipo de inactividad económica'
		end as "DES_PL211L"
		--, "PL211L_F"
		, "PH010"
		, case 
			when "PH010" = '1' then 'Muy bueno'
			when "PH010" = '2' then 'Bueno'
			when "PH010" = '3' then 'Regular'
			when "PH010" = '4' then 'Malo'
			when "PH010" = '5' then 'Muy Malo'
		end as "DES_PH010"
		--, "PH010_F"
		, "PH020"
		, case 
			when "PH020" = '1' then 'Sí'
			when "PH020" = '2' then 'No'
		end as "DES_PH020"
		--, "PH020_F"
		, "PH030"
		, case 
			when "PH030" = '1' then 'Sí, intensamente'
			when "PH030" = '2' then 'Sí, hasta cierto punto'
			when "PH030" = '3' then 'No'
		end as "DES_PH030"
		--, "PH030_F"
		, "PY010N"
		, "PY010N" as "DES_PY010N"
		--, "PY010N_F"
		, "PY020N"
		, "PY020N" as "DES_PY020N"
		--, "PY020N_F"
		, "PY021N"
		, "PY021N" as "DES_PY021N"
		--, "PY021N_F"
		, "PY035N"
		, "PY035N" as "DES_PY035N"
		--, "PY035N_F"
		, "PY050N"
		, "PY050N" as "DES_PY050N"
		--, "PY050N_F"
		, "PY080N"
		, "PY080N" as "DES_PY080N"
		--, "PY080N_F"
		, "PY090N"
		, "PY090N" as "DES_PY090N"
		--, "PY090N_F"
		, "PY100N"
		, "PY100N" as "DES_PY100N"
		--, "PY100N_F"
		, "PY110N"
		, "PY110N" as "DES_PY110N"
		--, "PY110N_F"
		, "PY120N"
		, "PY120N" as "DES_PY120N"
		--, "PY120N_F"
		, "PY130N"
		, "PY130N" as "DES_PY130N"
		--, "PY130N_F"
		, "PY140N"
		, "PY140N" as "DES_PY140N"
		--, "PY140N_F"
		, "PY010G"
		, "PY010G" as "DES_PY010G"
		--, "PY010G_F"
		, "PY020G"
		, "PY020G" as "DES_PY020G"
		--, "PY020G_F"
		, "PY021G"
		, "PY021G" as "DES_PY021G"
		--, "PY021G_F"
		, "PY030G"
		, "PY030G" as "DES_PY030G"
		--, "PY030G_F"
		, "PY035G"
		, "PY035G" as "DES_PY035G"
		--, "PY035G_F"
		, "PY050G"
		, "PY050G" as "DES_PY050G"
		--, "PY050G_F"
		, "PY080G"
		, "PY080G" as "DES_PY080G"
		--, "PY080G_F"
		, "PY090G"
		, "PY090G" as "DES_PY090G"
		--, "PY090G_F"
		, "PY100G"
		, "PY100G" as "DES_PY100G"
		--, "PY100G_F"
		, "PY110G"
		, "PY110G" as "DES_PY110G"
		--, "PY110G_F"
		, "PY120G"
		, "PY120G" as "DES_PY120G"
		--, "PY120G_F"
		, "PY130G"
		, "PY130G" as "DES_PY130G"
		--, "PY130G_F"
		, "PY140G"
		, "PY140G" as "DES_PY140G"
		--, "PY140G_F" 
	from stgecv.ecv_raw_persona
	--where concat(pk_ciclo, "PB010", "PB030") in (select pk_persona_total from stgecv.ecv_aux_include)
	) 
	select t."pk_encuesta", t."pk_entidad_encuesta", t."pk_anyo", t."pk_entidad", t2."pk_pregunta", t2."cod_respuesta", t2."des_respuesta"
	from t
	cross join lateral (
	     values 
	       ('PE040', t."PE040", t."DES_PE040")
	       , ('PL031', t."PL031", t."DES_PL031")
	       , ('PL020', t."PL020", t."DES_PL020")
	       , ('PL025', t."PL025", t."DES_PL025")
	       , ('PL040', t."PL040", t."DES_PL040")
	       , ('PL060', t."PL060", t."DES_PL060")
	       , ('PL140', t."PL140", t."DES_PL140")
	       , ('PL160', t."PL160", t."DES_PL160")
	       , ('PL170', t."PL170", t."DES_PL170")
	       , ('PL180', t."PL180", t."DES_PL180")
	       , ('PL190', t."PL190", t."DES_PL190")
	       , ('PL200', t."PL200", t."DES_PL200")
	       , ('PL211A', t."PL211A", t."DES_PL211A")
	       , ('PL211B', t."PL211B", t."DES_PL211B")
	       , ('PL211C', t."PL211C", t."DES_PL211C")
	       , ('PL211D', t."PL211D", t."DES_PL211D")
	       , ('PL211E', t."PL211E", t."DES_PL211E")
	       , ('PL211F', t."PL211F", t."DES_PL211F")
	       , ('PL211G', t."PL211G", t."DES_PL211G")
	       , ('PL211H', t."PL211H", t."DES_PL211H")
	       , ('PL211I', t."PL211I", t."DES_PL211I")
	       , ('PL211J', t."PL211J", t."DES_PL211J")
	       , ('PL211K', t."PL211K", t."DES_PL211K")
	       , ('PL211L', t."PL211L", t."DES_PL211L")
	       , ('PH010', t."PH010", t."DES_PH010")
	       , ('PH020', t."PH020", t."DES_PH020")
	       , ('PH030', t."PH030", t."DES_PH030")
	       , ('PY010N', t."PY010N", t."DES_PY010N")
	       , ('PY020N', t."PY020N", t."DES_PY020N")
	       , ('PY021N', t."PY021N", t."DES_PY021N")
	       , ('PY035N', t."PY035N", t."DES_PY035N")
	       , ('PY050N', t."PY050N", t."DES_PY050N")
	       , ('PY080N', t."PY080N", t."DES_PY080N")
	       , ('PY090N', t."PY090N", t."DES_PY090N")
	       , ('PY100N', t."PY100N", t."DES_PY100N")
	       , ('PY110N', t."PY110N", t."DES_PY110N")
	       , ('PY120N', t."PY120N", t."DES_PY120N")
	       , ('PY130N', t."PY130N", t."DES_PY130N")
	       , ('PY140N', t."PY140N", t."DES_PY140N")
	       , ('PY010G', t."PY010G", t."DES_PY010G")
	       , ('PY020G', t."PY020G", t."DES_PY020G")
	       , ('PY021G', t."PY021G", t."DES_PY021G")
	       , ('PY030G', t."PY030G", t."DES_PY030G")
	       , ('PY035G', t."PY035G", t."DES_PY035G")
	       , ('PY050G', t."PY050G", t."DES_PY050G")
	       , ('PY080G', t."PY080G", t."DES_PY080G")
	       , ('PY090G', t."PY090G", t."DES_PY090G")
	       , ('PY100G', t."PY100G", t."DES_PY100G")
	       , ('PY110G', t."PY110G", t."DES_PY110G")
	       , ('PY120G', t."PY120G", t."DES_PY120G")
	       , ('PY130G', t."PY130G", t."DES_PY130G")
	       , ('PY140G', t."PY140G", t."DES_PY140G")
	  ) as t2 (PK_PREGUNTA, COD_RESPUESTA, DES_RESPUESTA)
) tblp
;

--hogar_basico
create table crpecv.ecv_td_hogar as
with hogar_aux as (
	select 
		 replace(to_char("DB010", '9999'), ' ', '') as PK_ANYO
		, replace("DB030", ' ', '') as PK_HOGAR
		, "DB075" as VAL_ANYO_ROTACION
		, "DB020" as COD_PAIS
		, case
			when "DB020" = 'ES' then 'España'
			else "DB020"
		end as DES_PAIS
		, "DB040" as COD_REGION
		, case
			when "DB040" = 'ES11' then 'Galicia'
			when "DB040" = 'ES12' then 'Principado de Asturias'
			when "DB040" = 'ES13' then 'Cantabria'
			when "DB040" = 'ES21' then 'Pais Vasco'
			when "DB040" = 'ES22' then 'Comunidad Foral de Navarra'
			when "DB040" = 'ES23' then 'La Rioja'
			when "DB040" = 'ES24' then 'Aragón'
			when "DB040" = 'ES30' then 'Comunidad de Madrid'
			when "DB040" = 'ES41' then 'Castilla y León'
			when "DB040" = 'ES42' then 'Castilla-La Mancha'
			when "DB040" = 'ES43' then 'Extremadura'
			when "DB040" = 'ES51' then 'Catalunya'
			when "DB040" = 'ES52' then 'Comunidad Valenciana'
			when "DB040" = 'ES53' then 'Illes Balears'
			when "DB040" = 'ES61' then 'Andalucia'
			when "DB040" = 'ES62' then 'Región de Murcia'
			when "DB040" = 'ES63' then 'Ciudad Autónoma de Ceuta'
			when "DB040" = 'ES64' then 'Ciudad Autónoma de Melilla'
			when "DB040" = 'ES70' then 'Canarias'
			when "DB040" = 'ESZZ' then 'Extra-Regio'
			else "DB040"
		end as DES_REGION
		, replace(to_char("DB060", '999999999999999'), ' ', '') as COD_MUESTREO
		, "DB090" as VAL_FACTOR_TRANSVERSAL
		, replace(to_char("DB100", '999999999999999'), ' ', '') as COD_URBANIZACION
		, case
			when "DB100" = '1' then 'Zona Muy Poblada'
			when "DB100" = '2' then 'Zona Media'
			when "DB100" = '3' then 'Zona Poco Poblada'
		end as DES_URBANIZACION
	from stgecv.ecv_raw_hogar_basico
	--where concat(pk_ciclo, "DB010", "DB030") in (select pk_hogar_total from stgecv.ecv_aux_include)
)
select *
from hogar_aux
;

--persona_basico
create table crpecv.ecv_td_persona as
with t as (
select 
	 "RB010" as PK_ANYO
	, "RB030" as PK_PERSONA
	, "RB040" as FK_HOGAR
	, "RB020" as COD_PAIS
	, "RB070" as VAL_MES_NACIMIENTO
	, "RB080" as VAL_ANYO_NACIMIENTO
	, concat("RB080", 
			case when length("RB070") = 1 then concat(0, "RB070")
			else "RB070" end) as TD_ANYOMES_NACIMIENTO
	, "RB090" as COD_SEXO
	, case
		when "RB090" = '1' then 'Varón'
		when "RB090" = '2' then 'Mujer'
		else "RB090"
		end as DES_SEXO
	, "RB110" as COD_SITUACION_HOGAR
	, case 
		when "RB110" = '1' then 'Estuvo en el hogar en ciclos anteriores o es miembro del hogar actual'
		when "RB110" = '2' then 'Se trasladó a este hogar procedente de otro hogar de la muestra tras el ciclo anterior'
		when "RB110" = '3' then 'Se trasladó a este hogar procedente de otro hogar ajeno a la muestra tras el ciclo anterior'
		when "RB110" = '4' then 'Nacido en este hogar tras el último ciclo'
		when "RB110" = '5' then 'Se trasladó en el ciclo anterior'
		when "RB110" = '6' then 'Falleció'
		when "RB110" = '7' then 'Vivió en el hogar al menos tres meses tras el período de referencia de los ingresos pero no figura en el registro de este hogar'
	end as DES_SITUACION_HOGAR
	, "RB120" as COD_LUGAR_TRASLADO
	, case
		when "RB120" = '1' then 'A un hogar privado dentro del país'
		when "RB120" = '2' then 'A un hogar o institución colectivos dentro del país'
		when "RB120" = '3' then 'Al extranjero'
		when "RB120" = '4' then 'Perdido'
	end as DES_LUGAR_TRASLADO
	, "RB140" as VAL_MES_TRASLADO
	, "RB150" as VAL_ANYO_TRASLADO
	, concat("RB150", 
			case when length("RB140") = 1 then concat(0, "RB140")
			else "RB140" end) 
	  as TD_ANYOMES_TRASLADO
	, "RB160" as VAL_MESES_HOGAR
	, "RB170" as COD_SITUACION_PERIODO
	, case
		when "RB170" = '1' then 'Activo'
		when "RB170" = '2' then 'Parado'
		when "RB170" = '3' then 'Jubilado o jubilado anticipadamente'
		when "RB170" = '4' then 'Otra clase de inactividad económica'
 	end as DES_SITUACION_PERIODO
	, "RB180" as VAL_MES_LLEGADA_HOGAR
	, "RB190" as VAL_ANYO_LLEGADA_HOGAR
	, concat("RB190", 
			case when length("RB180") = 1 then concat(0, "RB180")
			else "RB180" end) 
	  as TD_ANYOMES_LLEGADA_HOGAR
	, "RB200" as COD_SITUACION_RESIDENCIA
	, case 
		when "RB200" = '1' then 'Vive Actualmente en el Hogar'
		when "RB200" = '2' then 'Ausente Temporalmente'
		else "RB200"
	end as DES_SITUACION_RESIDENCIA
	, "RB210" as COD_SITUACION_ULTIMA_SEMANA
	, case 
		when "RB210" = '1' then 'Trabajando'
		when "RB210" = '2' then 'Parado'
		when "RB210" = '3' then 'Jubilado o jubilado anticipadamente'
		when "RB210" = '4' then 'Otra clase de inactividad económica'
		else "RB210"
	end as DES_SITUACION_ULTIMA_SEMANA
	, "RB220" as COD_PADRE
	, "RB230" as COD_MADRE
	, "RB240" as COD_CONYUGE_PAREJA
	, rp.imp_renta_unidad_consumo 
	, cms.flg_carencia_material_severa 
	, coalesce(hbie.flg_hogar_baja_intensidad_empleo , '0') as flg_hogar_baja_intensidad_empleo 
	, rp.flg_riesgo_pobreza 
	, case 
		when coalesce(cast(cms.flg_carencia_material_severa as int), 0) + 
				coalesce(cast(hbie.flg_hogar_baja_intensidad_empleo as int), 0)  + 
				coalesce(cast(rp.flg_riesgo_pobreza as int), 0) > 0 then '1'
		else '0'
	end as flg_pobreza_exclusion,
	cms.flg_vacaciones,
	cms.flg_comida,
	cms.flg_temperatura,
	cms.flg_gastos_imprevistos,
	cms.flg_retraso_pago,
	cms.flg_coche,
	cms.flg_telefono,
	cms.flg_television,
	cms.flg_lavadora
from stgecv.ecv_raw_persona_basico pb
left join stgecv.ecv_taux_flg_carencia_material_severa cms
	on 
		pb."RB010" = cms.pk_anyo 
		and "RB040" = cms.pk_hogar 
left join stgecv.ecv_taux_flg_hogar_baja_intensidad_empleo hbie
	on
		pb."RB010" = hbie.pk_anyo 
		and pb."RB030" = hbie.pk_persona
left join stgecv.ecv_taux_flg_riesgo_pobreza rp
	on 
		pb."RB010" = rp.pk_anyo 
		and "RB040" = rp.pk_hogar
), 
t2 as (
select 
	pk_persona
	, case 
		when sum(cast(flg_riesgo_pobreza as int)) >= 1 then 1
		else 0
	end as flg_riesgo_pobreza
	, case 
		when sum(cast(flg_hogar_baja_intensidad_empleo as int)) >= 1 then 1
		else 0
	end as flg_hogar_baja_intensidad_empleo
	, case 
		when sum(cast(flg_carencia_material_severa as int)) >= 1 then 1
		else 0
	end as flg_carencia_material_severa
from t 
group by pk_persona),
t3 as (
select 
	pk_persona
	, flg_riesgo_pobreza as flg_riesgo_pobreza_longitudinal
	, flg_hogar_baja_intensidad_empleo as flg_hogar_baja_intensidad_empleo_longitudinal
	, flg_carencia_material_severa as flg_carencia_material_severa_longitudinal
	, case 
		when flg_riesgo_pobreza + flg_hogar_baja_intensidad_empleo + flg_carencia_material_severa >= 2 
			then 'Múltiples factores de riesgo de pobreza y/o exclusión social'
		when flg_riesgo_pobreza = 1 then 'En riesgo de pobreza'
		when flg_hogar_baja_intensidad_empleo = 1 then 'En riesgo de baja intensidad en el empleo'
		when flg_carencia_material_severa = 1 then 'En riesgo de carencia material severa'
		when flg_riesgo_pobreza + flg_hogar_baja_intensidad_empleo + flg_carencia_material_severa = 0 
			then 'Sin riesgo de pobreza y/o exclusión social' 
	end as des_riesgo_pobreza_exclusion_longitudinal
from t2)
select 
	pk_anyo
	, t.pk_persona
	, fk_hogar
	, cod_pais
	, val_mes_nacimiento
	, val_anyo_nacimiento
	, td_anyomes_nacimiento
	, cod_sexo
	, des_sexo
	, cod_situacion_hogar
	, des_situacion_hogar
	, cod_lugar_traslado
	, des_lugar_traslado
	, val_mes_traslado
	, val_anyo_traslado
	, td_anyomes_traslado
	, val_meses_hogar
	, cod_situacion_periodo
	, des_situacion_periodo
	, val_mes_llegada_hogar
	, val_anyo_llegada_hogar
	, td_anyomes_llegada_hogar
	, cod_situacion_residencia
	, des_situacion_residencia
	, cod_situacion_ultima_semana
	, des_situacion_ultima_semana
	, cod_padre
	, cod_madre
	, cod_conyuge_pareja
	, imp_renta_unidad_consumo
	, flg_carencia_material_severa
	, flg_hogar_baja_intensidad_empleo
	, flg_riesgo_pobreza
	, flg_pobreza_exclusion
	, flg_riesgo_pobreza_longitudinal
	, flg_hogar_baja_intensidad_empleo_longitudinal
	, flg_carencia_material_severa_longitudinal
	, des_riesgo_pobreza_exclusion_longitudinal
	, flg_vacaciones
	, flg_comida
	, flg_temperatura
	, flg_gastos_imprevistos
	, flg_retraso_pago
	, flg_coche
	, flg_telefono
	, flg_television
	, flg_lavadora
from t
left join t3
	on t.pk_persona = t3.pk_persona
;