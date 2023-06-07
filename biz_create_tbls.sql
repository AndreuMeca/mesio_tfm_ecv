
DROP EXTENSION IF EXISTS tablefunc CASCADE;

create extension if not exists tablefunc with schema stgecv;
commit;

create table stgecv.ecv_taux_pivot_encuesta_respuesta_persona as
select pk_entidad || pk_anyo as pk_entidad_anyo, pk_pregunta, des_respuesta
from crpecv.ecv_tx_encuesta_respuesta
where pk_encuesta = 'ECV' and pk_entidad_encuesta = 'P'
;

create table stgecv.ecv_taux_pivot_encuesta_respuesta_hogar as
select pk_entidad || pk_anyo as pk_entidad_anyo, pk_pregunta, des_respuesta
from crpecv.ecv_tx_encuesta_respuesta
where pk_encuesta = 'ECV' and pk_entidad_encuesta = 'H'
;


create table stgecv.ecv_taux_encuesta_respuesta_persona as
select * from 
stgecv.crosstab
	(
	'select pk_entidad_anyo::text, pk_pregunta::text, des_respuesta::text
	from stgecv.ecv_taux_pivot_encuesta_respuesta_persona'
	)
	as t(pk_entidad_anyo text
		   , PE040 text
	       , PL031 text
	       , PL020 text
	       , PL025 text
	       , PL040 text
	       , PL060 text
	       , PL140 text
	       , PL160 text
	       , PL170 text
	       , PL180 text
	       , PL190 text
	       , PL200 text
	       , PL211A text
	       , PL211B text
	       , PL211C text
	       , PL211D text
	       , PL211E text
	       , PL211F text
	       , PL211G text
	       , PL211H text
	       , PL211I text
	       , PL211J text
	       , PL211K text
	       , PL211L text
	       , PH010 text
	       , PH020 text
	       , PH030 text
	       , PY010N text
	       , PY020N text
	       , PY021N text
	       , PY035N text
	       , PY050N text
	       , PY080N text
	       , PY090N text
	       , PY100N text
	       , PY110N text
	       , PY120N text
	       , PY130N text
	       , PY140N text
	       , PY010G text
	       , PY020G text
	       , PY021G text
	       , PY030G text
	       , PY035G text
	       , PY050G text
	       , PY080G text
	       , PY090G text
	       , PY100G text
	       , PY110G text
	       , PY120G text
	       , PY130G text
	       , PY140G text)
;

--hogar crosstab
create table stgecv.ecv_taux_encuesta_respuesta_hogar as
select * from 
stgecv.crosstab
	(
	'select *
	from stgecv.ecv_taux_pivot_encuesta_respuesta_hogar'
	)
	as t(pk_entidad_anyo text
		   , HY020 text
	       , HY022 text
	       , HY023 text
	       , HY030N text
	       , HY040N text
	       , HY050N text
	       , HY060N text
	       , HY070N text
	       , HY080N text
	       , HY090N text
	       , HY100N text
	       , HY110N text
	       , HY120N text
	       , HY130N text
	       , HY145N text
	       , HY170N text
	       , HY010 text
	       , HY040G text
	       , HY050G text
	       , HY060G text
	       , HY070G text
	       , HY080G text
	       , HY090G text
	       , HY100G text
	       , HY110G text
	       , HY120G text
	       , HY130G text
	       , HY140G text
	       , HS011 text
	       , HS021 text
	       , HS031 text
	       , HS040 text
	       , HS050 text
	       , HS060 text
	       , HS070 text
	       , HS080 text
	       , HS090 text
	       , HS100 text
	       , HS110 text
	       , HS120 text
	       , HS130 text
	       , HS140 text
	       , HS150 text
	       , HH010 text
	       , HH020 text
	       , HH021 text
	       , HH030 text
	       , HH031 text
	       , HH040 text
	       , HH050 text
	       , HH060 text
	       , HH061 text
	       , HH070 text
	       , HH081 text
	       , HH091 text)
;

create table bizecv.ecv_tx_f1_visual as
select 
	tp.pk_anyo
	, pk_persona
	, fk_hogar
	, val_anyo_rotacion
	, val_mes_nacimiento
	, val_anyo_nacimiento
	, td_anyomes_nacimiento
	, cast(tp.pk_anyo as int) - cast(substr(td_anyomes_nacimiento, 1, 4) as int) as val_edad
	, case 
		when cast(tp.pk_anyo as int) - cast(substr(td_anyomes_nacimiento, 1, 4) as int) < 16 then 'Menor de 16 años'
		when cast(tp.pk_anyo as int) - cast(substr(td_anyomes_nacimiento, 1, 4) as int) >= 16 and 
			cast(tp.pk_anyo as int) - cast(substr(td_anyomes_nacimiento, 1, 4) as int) < 29 then 'Entre 16 y 28 años'
		when cast(tp.pk_anyo as int) - cast(substr(td_anyomes_nacimiento, 1, 4) as int) >= 29 and 
			cast(tp.pk_anyo as int) - cast(substr(td_anyomes_nacimiento, 1, 4) as int) < 45 then 'Entre 29 y 44 años'
		when cast(tp.pk_anyo as int) - cast(substr(td_anyomes_nacimiento, 1, 4) as int) >= 45 and 
			cast(tp.pk_anyo as int) - cast(substr(td_anyomes_nacimiento, 1, 4) as int) < 65 then 'Entre 45 y 64 años'
		when cast(tp.pk_anyo as int) - cast(substr(td_anyomes_nacimiento, 1, 4) as int) >= 65 then 'Más de 65 años'
		when tp.pk_anyo is null or td_anyomes_nacimiento is null then 'No Disponible'
	end as des_intervalo_edad
	, cod_sexo
	, case 
		when des_sexo is not null then des_sexo
		else 'No Disponible'
	end as des_sexo
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
	, case 
		when imp_renta_unidad_consumo < 0 then 'Menor de 0€'
		when imp_renta_unidad_consumo >= 0 and imp_renta_unidad_consumo < 9000 then 'Entre 0€ y 9000€'
		when imp_renta_unidad_consumo >= 9000 and imp_renta_unidad_consumo < 12450 then 'Entre 9000€ y 12450€'
		when imp_renta_unidad_consumo >= 12450 and imp_renta_unidad_consumo < 20200 then 'Entre 12450€ y 20200€'
		when imp_renta_unidad_consumo >= 20200 and imp_renta_unidad_consumo < 35200 then 'Entre 20200€ y 35200€'
		when imp_renta_unidad_consumo >= 35200 and imp_renta_unidad_consumo < 60000 then 'Entre 35200€ y 60000€'
		else 'Mayor de 60000€'
	end as des_renta_unidad_consumo
	, flg_carencia_material_severa
	, case 
		when flg_carencia_material_severa = '0' then 'Sin Riesgo'
		when flg_carencia_material_severa = '1' then 'En Riesgo'
	end as des_carencia_material_severa
	, flg_hogar_baja_intensidad_empleo
	, case 
		when flg_hogar_baja_intensidad_empleo = '0' then 'Sin Riesgo'
		when flg_hogar_baja_intensidad_empleo = '1' then 'En Riesgo'
	end as des_hogar_baja_intensidad_empleo
	, flg_riesgo_pobreza
	, case 
		when flg_riesgo_pobreza = '0' then 'Sin Riesgo'
		when flg_riesgo_pobreza = '1' then 'En Riesgo'
	end as des_riesgo_pobreza
	, flg_pobreza_exclusion
	, case 
		when flg_pobreza_exclusion = '0' then 'Sin Riesgo'
		when flg_pobreza_exclusion = '1' then 'En Riesgo'
	end as des_pobreza_exclusion
	, flg_riesgo_pobreza_longitudinal
	, case 
		when flg_riesgo_pobreza_longitudinal = '0' then 'Sin Riesgo'
		when flg_riesgo_pobreza_longitudinal = '1' then 'En Riesgo'
	end as des_riesgo_pobreza_longitudinal
	, flg_hogar_baja_intensidad_empleo_longitudinal
	, case 
		when flg_hogar_baja_intensidad_empleo_longitudinal = '0' then 'Sin Riesgo'
		when flg_hogar_baja_intensidad_empleo_longitudinal = '1' then 'En Riesgo'
	end as des_hogar_baja_intensidad_empleo_longitudinal
	, flg_carencia_material_severa_longitudinal
	, case 
		when flg_carencia_material_severa_longitudinal = '0' then 'Sin Riesgo'
		when flg_carencia_material_severa_longitudinal = '1' then 'En Riesgo'
	end as des_carencia_material_severa_longitudinal
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
	/*, case 
		when val_anyo_rotacion = 1 then flg_pobreza_exclusion
		when val_anyo_rotacion = 2 then lag(flg_pobreza_exclusion, 1) over(partition by pk_persona order by val_anyo_rotacion) || flg_pobreza_exclusion
		when val_anyo_rotacion = 3 then lag(flg_pobreza_exclusion, 2) over(partition by pk_persona order by val_anyo_rotacion) || lag(flg_pobreza_exclusion, 1) over(partition by pk_persona order by val_anyo_rotacion) || flg_pobreza_exclusion
		when val_anyo_rotacion = 4 then lag(flg_pobreza_exclusion, 3) over(partition by pk_persona order by val_anyo_rotacion) || lag(flg_pobreza_exclusion, 2) over(partition by pk_persona order by val_anyo_rotacion) || lag(flg_pobreza_exclusion, 1) over(partition by pk_persona order by val_anyo_rotacion) || flg_pobreza_exclusion
	end as cod_pobreza_exclusion
	, case 
		when val_anyo_rotacion = 1 then flg_carencia_material_severa 
		when val_anyo_rotacion = 2 then lag(flg_carencia_material_severa, 1) over(partition by pk_persona order by val_anyo_rotacion) || flg_carencia_material_severa
		when val_anyo_rotacion = 3 then lag(flg_carencia_material_severa, 2) over(partition by pk_persona order by val_anyo_rotacion) || lag(flg_carencia_material_severa, 1) over(partition by pk_persona order by val_anyo_rotacion) || flg_carencia_material_severa
		when val_anyo_rotacion = 4 then lag(flg_carencia_material_severa, 3) over(partition by pk_persona order by val_anyo_rotacion) || lag(flg_carencia_material_severa, 2) over(partition by pk_persona order by val_anyo_rotacion) || lag(flg_carencia_material_severa, 1) over(partition by pk_persona order by val_anyo_rotacion) || flg_carencia_material_severa
	end as cod_carencia_material_severa
	, case 
		when val_anyo_rotacion = 1 then flg_hogar_baja_intensidad_empleo  
		when val_anyo_rotacion = 2 then lag(flg_hogar_baja_intensidad_empleo, 1) over(partition by pk_persona order by val_anyo_rotacion) || flg_hogar_baja_intensidad_empleo
		when val_anyo_rotacion = 3 then lag(flg_hogar_baja_intensidad_empleo, 2) over(partition by pk_persona order by val_anyo_rotacion) || lag(flg_hogar_baja_intensidad_empleo, 1) over(partition by pk_persona order by val_anyo_rotacion) || flg_hogar_baja_intensidad_empleo
		when val_anyo_rotacion = 4 then lag(flg_hogar_baja_intensidad_empleo, 3) over(partition by pk_persona order by val_anyo_rotacion) || lag(flg_hogar_baja_intensidad_empleo, 2) over(partition by pk_persona order by val_anyo_rotacion) || lag(flg_hogar_baja_intensidad_empleo, 1) over(partition by pk_persona order by val_anyo_rotacion) || flg_hogar_baja_intensidad_empleo
	end as cod_hogar_baja_intensidad_empleo
	, case 
		when val_anyo_rotacion = 1 then flg_riesgo_pobreza  
		when val_anyo_rotacion = 2 then lag(flg_riesgo_pobreza, 1) over(partition by pk_persona order by val_anyo_rotacion) || flg_riesgo_pobreza
		when val_anyo_rotacion = 3 then lag(flg_riesgo_pobreza, 2) over(partition by pk_persona order by val_anyo_rotacion) || lag(flg_riesgo_pobreza, 1) over(partition by pk_persona order by val_anyo_rotacion) || flg_riesgo_pobreza
		when val_anyo_rotacion = 4 then lag(flg_riesgo_pobreza, 3) over(partition by pk_persona order by val_anyo_rotacion) || lag(flg_riesgo_pobreza, 2) over(partition by pk_persona order by val_anyo_rotacion) || lag(flg_riesgo_pobreza, 1) over(partition by pk_persona order by val_anyo_rotacion) || flg_riesgo_pobreza
	end as cod_riesgo_pobreza*/
	, th.des_pais
	, cod_region
	, des_region, cod_muestreo
	, val_factor_transversal
	, cod_urbanizacion
	, des_urbanizacion
	, pe040
	, pl031
	, pl020
	, pl025
	, case 
		when pl040 = 'Empresario sin asalariados o trabajador independiente' 
			then 'Empresario o Trabajador Independiente'
		when pl040 is not null then pl040
		else 'No Disponible'
	end as pl040
	, pl060
	, pl140
	, pl160
	, pl170
	, pl180
	, pl190
	, pl200
	, pl211a
	, pl211b
	, pl211c
	, pl211d
	, pl211e
	, pl211f
	, pl211g
	, pl211h
	, pl211i
	, pl211j
	, pl211k
	, pl211l
	, ph010
	, ph020
	, ph030
	, py010n
	, py020n
	, py021n
	, py035n
	, py050n
	, py080n
	, py090n
	, py100n
	, py110n
	, py120n
	, py130n
	, py140n
	, py010g
	, py020g
	, py021g
	, py030g
	, py035g
	, py050g
	, py080g
	, py090g
	, py100g
	, py110g
	, py120g
	, py130g
	, py140g
	, hy020
	, hy022
	, hy023
	, hy030n
	, hy040n
	, hy050n
	, hy060n
	, hy070n
	, hy080n
	, hy090n
	, hy100n
	, hy110n
	, hy120n
	, hy130n
	, hy145n
	, hy170n
	, hy010
	, hy040g
	, hy050g
	, hy060g
	, hy070g
	, hy080g
	, hy090g
	, hy100g
	, hy110g
	, hy120g
	, hy130g
	, hy140g
	, hs011
	, hs021
	, hs031
	, hs040
	, hs050
	, hs060
	, hs070
	, hs080
	, hs090
	, hs100
	, hs110
	, hs120
	, hs130
	, hs140
	, hs150
	, case 
		when hh010 is not null then hh010
		else 'No Disponible'
	end as hh010
	, hh020
	, hh021
	, hh030
	, hh031
	, hh040
	, hh050
	, hh060
	, hh061
	, hh070
	, hh081
	, hh091
from crpecv.ecv_td_persona tp 
left join crpecv.ecv_td_hogar th 
	on tp.pk_anyo = th.pk_anyo 
		and tp.fk_hogar = th.pk_hogar
left join stgecv.ecv_taux_encuesta_respuesta_persona terp 
	on tp.pk_persona || tp.pk_anyo = terp.pk_entidad_anyo 
left join stgecv.ecv_taux_encuesta_respuesta_hogar terh 
	on th.pk_hogar || th.pk_anyo = terh.pk_entidad_anyo 
;


create table bizecv.ecv_tx_f1_model as
with t as (
select right(pk_persona, length(pk_persona) - 4) as pk_persona
from bizecv.ecv_tx_f1_visual 
group by right(pk_persona, length(pk_persona) - 4)
having count(*) = 4),
t2 as (
select 
	pk_anyo
	, right(pk_persona, length(pk_persona) - 4) as pk_persona
	, fk_hogar
	, val_anyo_rotacion
	, val_mes_nacimiento
	, val_anyo_nacimiento
	, td_anyomes_nacimiento
	, val_edad
	, des_intervalo_edad
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
	, des_renta_unidad_consumo
	, flg_carencia_material_severa
	, des_carencia_material_severa
	, flg_hogar_baja_intensidad_empleo
	, des_hogar_baja_intensidad_empleo
	, flg_riesgo_pobreza
	, des_riesgo_pobreza
	, flg_pobreza_exclusion
	, des_pobreza_exclusion
	, flg_riesgo_pobreza_longitudinal
	, des_riesgo_pobreza_longitudinal
	, flg_hogar_baja_intensidad_empleo_longitudinal
	, des_hogar_baja_intensidad_empleo_longitudinal
	, flg_carencia_material_severa_longitudinal
	, des_carencia_material_severa_longitudinal
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
	, des_pais
	, cod_region
	, des_region, cod_muestreo
	, val_factor_transversal
	, cod_urbanizacion
	, des_urbanizacion
	, pe040
	, pl031
	, pl020
	, pl025
	, pl040
	, pl060
	, pl140
	, pl160
	, pl170
	, pl180
	, pl190
	, pl200
	, pl211a
	, pl211b
	, pl211c
	, pl211d
	, pl211e
	, pl211f
	, pl211g
	, pl211h
	, pl211i
	, pl211j
	, pl211k
	, pl211l
	, ph010
	, ph020
	, ph030
	, py010n
	, py020n
	, py021n
	, py035n
	, py050n
	, py080n
	, py090n
	, py100n
	, py110n
	, py120n
	, py130n
	, py140n
	, py010g
	, py020g
	, py021g
	, py030g
	, py035g
	, py050g
	, py080g
	, py090g
	, py100g
	, py110g
	, py120g
	, py130g
	, py140g
	, hy020
	, hy022
	, hy023
	, hy030n
	, hy040n
	, hy050n
	, hy060n
	, hy070n
	, hy080n
	, hy090n
	, hy100n
	, hy110n
	, hy120n
	, hy130n
	, hy145n
	, hy170n
	, hy010
	, hy040g
	, hy050g
	, hy060g
	, hy070g
	, hy080g
	, hy090g
	, hy100g
	, hy110g
	, hy120g
	, hy130g
	, hy140g
	, hs011
	, hs021
	, hs031
	, hs040
	, hs050
	, hs060
	, hs070
	, hs080
	, hs090
	, hs100
	, hs110
	, hs120
	, hs130
	, hs140
	, hs150
	, hh010
	, hh020
	, hh021
	, hh030
	, hh031
	, hh040
	, hh050
	, hh060
	, hh061
	, hh070
	, hh081
	, hh091
from bizecv.ecv_tx_f1_visual 
where right(pk_persona, length(pk_persona) - 4) in (select * from t)
),
t2_distinct_anyo as (
select pk_anyo || pk_persona as pk_anyo_persona
from t2
group by pk_anyo, pk_persona
having count(*) = 1
),
t3_distinct_rotacion as (
select val_anyo_rotacion || pk_persona as pk_anyo_persona
from t2
group by val_anyo_rotacion, pk_persona
having count(*) = 1
),
taux2 as (
select *
from t2 
where pk_anyo || pk_persona in (select * from t2_distinct_anyo)
	and val_anyo_rotacion || pk_persona in (select * from t3_distinct_rotacion)
),
taux3 as (
select pk_persona
from taux2
group by pk_persona 
having count(*) = 4
), t4 as (
select *
from t2 
where pk_anyo || pk_persona in (select * from t2_distinct_anyo)
	and val_anyo_rotacion || pk_persona in (select * from t3_distinct_rotacion)
	and pk_persona in (select * from taux3)
)
select 
	*,
	case 
		when val_anyo_rotacion = 1 then flg_pobreza_exclusion
		when val_anyo_rotacion = 2 then lag(flg_pobreza_exclusion, 1) over(partition by pk_persona order by val_anyo_rotacion) || flg_pobreza_exclusion
		when val_anyo_rotacion = 3 then lag(flg_pobreza_exclusion, 2) over(partition by pk_persona order by val_anyo_rotacion) || lag(flg_pobreza_exclusion, 1) over(partition by pk_persona order by val_anyo_rotacion) || flg_pobreza_exclusion
		when val_anyo_rotacion = 4 then lag(flg_pobreza_exclusion, 3) over(partition by pk_persona order by val_anyo_rotacion) || lag(flg_pobreza_exclusion, 2) over(partition by pk_persona order by val_anyo_rotacion) || lag(flg_pobreza_exclusion, 1) over(partition by pk_persona order by val_anyo_rotacion) || flg_pobreza_exclusion
	end as cod_pobreza_exclusion,
	case 
		when val_anyo_rotacion = 1 then flg_carencia_material_severa 
		when val_anyo_rotacion = 2 then lag(flg_carencia_material_severa, 1) over(partition by pk_persona order by val_anyo_rotacion) || flg_carencia_material_severa
		when val_anyo_rotacion = 3 then lag(flg_carencia_material_severa, 2) over(partition by pk_persona order by val_anyo_rotacion) || lag(flg_carencia_material_severa, 1) over(partition by pk_persona order by val_anyo_rotacion) || flg_carencia_material_severa
		when val_anyo_rotacion = 4 then lag(flg_carencia_material_severa, 3) over(partition by pk_persona order by val_anyo_rotacion) || lag(flg_carencia_material_severa, 2) over(partition by pk_persona order by val_anyo_rotacion) || lag(flg_carencia_material_severa, 1) over(partition by pk_persona order by val_anyo_rotacion) || flg_carencia_material_severa
	end as cod_carencia_material_severa,
	case 
		when val_anyo_rotacion = 1 then flg_hogar_baja_intensidad_empleo  
		when val_anyo_rotacion = 2 then lag(flg_hogar_baja_intensidad_empleo, 1) over(partition by pk_persona order by val_anyo_rotacion) || flg_hogar_baja_intensidad_empleo
		when val_anyo_rotacion = 3 then lag(flg_hogar_baja_intensidad_empleo, 2) over(partition by pk_persona order by val_anyo_rotacion) || lag(flg_hogar_baja_intensidad_empleo, 1) over(partition by pk_persona order by val_anyo_rotacion) || flg_hogar_baja_intensidad_empleo
		when val_anyo_rotacion = 4 then lag(flg_hogar_baja_intensidad_empleo, 3) over(partition by pk_persona order by val_anyo_rotacion) || lag(flg_hogar_baja_intensidad_empleo, 2) over(partition by pk_persona order by val_anyo_rotacion) || lag(flg_hogar_baja_intensidad_empleo, 1) over(partition by pk_persona order by val_anyo_rotacion) || flg_hogar_baja_intensidad_empleo
	end as cod_hogar_baja_intensidad_empleo,
	case 
		when val_anyo_rotacion = 1 then flg_riesgo_pobreza  
		when val_anyo_rotacion = 2 then lag(flg_riesgo_pobreza, 1) over(partition by pk_persona order by val_anyo_rotacion) || flg_riesgo_pobreza
		when val_anyo_rotacion = 3 then lag(flg_riesgo_pobreza, 2) over(partition by pk_persona order by val_anyo_rotacion) || lag(flg_riesgo_pobreza, 1) over(partition by pk_persona order by val_anyo_rotacion) || flg_riesgo_pobreza
		when val_anyo_rotacion = 4 then lag(flg_riesgo_pobreza, 3) over(partition by pk_persona order by val_anyo_rotacion) || lag(flg_riesgo_pobreza, 2) over(partition by pk_persona order by val_anyo_rotacion) || lag(flg_riesgo_pobreza, 1) over(partition by pk_persona order by val_anyo_rotacion) || flg_riesgo_pobreza
	end as cod_riesgo_pobreza
from t4
--where pk_anyo >= '2018'
;

create table bizecv.ecv_tx_f2_visual as
select 
	pk_anyo
	, pk_persona
	, fk_hogar
	, val_anyo_rotacion
	, des_intervalo_edad
	, des_sexo
	, imp_renta_unidad_consumo
	, des_renta_unidad_consumo
	, flg_carencia_material_severa
	, des_carencia_material_severa
	, flg_hogar_baja_intensidad_empleo
	, des_hogar_baja_intensidad_empleo
	, flg_riesgo_pobreza
	, des_riesgo_pobreza
	, flg_pobreza_exclusion
	, des_pobreza_exclusion
	, flg_riesgo_pobreza_longitudinal
	, des_riesgo_pobreza_longitudinal
	, flg_hogar_baja_intensidad_empleo_longitudinal
	, des_hogar_baja_intensidad_empleo_longitudinal
	, flg_carencia_material_severa_longitudinal
	, des_carencia_material_severa_longitudinal
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
	/*, cod_pobreza_exclusion
	, cod_carencia_material_severa
	, cod_hogar_baja_intensidad_empleo
	, cod_riesgo_pobreza*/
	, cod_region
	, des_region
	, pe040
	, pl040
	, hy020
from bizecv.ecv_tx_f1_visual etfv
--where cast(pk_anyo as int) >= extract(year from now()) - 5
;

create table bizecv.ecv_tx_f2_model as
select 
	pk_anyo
	, pk_persona
	, val_anyo_rotacion 
	, des_intervalo_edad
	, des_sexo
	, des_renta_unidad_consumo
	, cod_pobreza_exclusion
	, cod_carencia_material_severa
	, cod_hogar_baja_intensidad_empleo
	, cod_riesgo_pobreza
	, des_region
	, pe040
	, pl040
from bizecv.ecv_tx_f1_model etfm 
;