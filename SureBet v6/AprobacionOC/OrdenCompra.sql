USE [LAVALIN]
GO
/****** Object:  StoredProcedure [dbo].[PA_HD_WEB_OC_Consulta_Cabecera]    Script Date: 14/11/2022 9:30:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[PA_HD_WEB_OC_Consulta_Cabecera]
@p_CodCia as Char(2), @p_CodSuc as Char(2), @p_NumOC as Char(10)
/***********************************************************************************************************
 Procedimiento	: PA_HD_WEB_OC_Consulta_Cabecera
 Proposito		: Consulta Tabla de Compras, Cabecera
 Inputs			: p_CodCia, p_CodSuc, p_NumOC
 Se asume		: OC existe en Tablas y Ya existe Validacion de acceso a la OC
 Efectos		: Retorno de 1 filas por cada OC
 Retorno		: 0/1 numero de registros afectados
 Notas			: N/A
 Modificaciones	: 
 Autor			: Gerardo Cherre
 Fecha y Hora	: 12/10/2014
***********************************************************************************************************/

AS
SET NOCOUNT ON
Select 
Left(a.ocm_corocm,1) as Occ_Serie,
a.ocm_corocm as Occ_Numero, a.occ_fecdoc as OCC_Fecha, a.aux_codaux as OCC_Proveedor_ID, b.AUX_NOMAUX as Proveedor, a.occ_tipocc as OCC_Tipo_Id, 
dbo.fx_auxiliar_direccion(a.cia_codcia,a.aux_codaux,'') as Proveedor_Direccion, dbo.fx_auxiliar_telefono(a.cia_codcia,a.aux_codaux) as Proveedor_Telefono,
(case a.occ_tipocc when '1' then 'Local' when '2' then 'Importacion' when '3' then 'Servicios' Else 'Otros' End) as Occ_Tipo,
(case a.occ_indest when '1' then 'Vigente' when '0' then 'Cancelado' else 'No Definido' end) as Occ_Estado,
a.ano_codano as Occ_Año, a.mes_codmes as Occ_Mes, 
a.pna_coddid as Occ_Atencion_TipDoc, a.pna_numdoc as Occ_Atencion_Numero, 
LTRIM(rtrim(f.pna_apepat))+' '+LTRIM(rtrim(f.pna_apemat))+' '+LTRIM(rtrim(f.pna_nombre)) as Occ_Atencion_Nombre, E.CON_DESCAR as Occ_Atencion_Cargo,
a.tsc_codtsc as Occ_Tipo_Solicitud_Id, h.tsc_deslar as Tipo_Solicitud,
a.tco_codtco as Occ_Terminos_Compra_Id, I.tco_destco as Terminnos_Compra,
a.cpa_codcpa as Occ_Condicion_Pago_Id, J.cpa_deslar as Condicion_Pago,
a.tmo_codtmo as Occ_Moneda_Id, K.Tmo_DesLar as Moneda, 
a.occ_fecent as Occ_Fecha_Entrega, a.occ_tipcam as Occ_TipoCambio, a.occ_pordes as Occ_Descuento, a.occ_tasigv as Occ_Tasa_IGV, 
a.lec_codlec as Occ_Lugar_Entrega_Id, l.lec_deslar as Lugar_Entrega,
a.occ_gloocc as Occ_Glosa, (Case a.occ_sitlog When '1' Then 'Atendido' Else 'Pendiente' End) as  Occ_Situacion_Logistica, a.occ_indalm as Occ_Indicador_Almacen,
a.cco_codcco as Occ_Centro_Costo_Id, c.cco_deslar as Centro_Costo,
a.emp_codemp as Occ_Empleado_Id, d.aux_nomaux as Empleado, 
(Case a.occ_indigv When '0' Then 'PRECIOS DE PRODUCTOS FALTAN INCLUIR EL IGV' 
                   When '1' Then 'PRECIOS DE PRODUCTOS INCLUIDO EL IGV' 
                   When '2' Then 'PRECIOS DE PRODUCTOS SIN IGV' 
                   Else 'NO DEFINIDO' End) as Occ_Indicador_IGV,
(Case a.occ_indcal When '1' Then 'CALCULAR DESDE EL PRECIO DE COMPRA' 
                   When '2' Then 'CALCULAR DESDE EL IMPORTE TOTAL' 
                   Else 'NO DEFINIDO' End) as Occ_Indicador_Calculo,
a.eoc_numeoc as Occ_Evento,           
a.occ_sitapr as OCC_Situacion_Aprobado_ID,
(Case a.occ_sitapr When '1' Then 'PENDIENTE'
                   When '2' Then 'APROBADO'
                   When '3' Then 'RECHAZADO'
                   Else 'NO DEFINIDO' End) as Occ_Situacion_Aprobado,
a.occ_portol as Occ_Tolerancia, a.occ_tototr as Occ_Importe_Otro,
a.occ_impbru as Occ_Importe_bruto, a.occ_impde1 as Occ_Importe_Descuento,
a.occ_impigv as Occ_Importe_IGV, a.occ_imptot as Occ_Importe_Total, 
(a.occ_imptot-a.occ_impigv) as Occ_Importe_Valor_Venta,
a.occ_inicon as Contrato_Inicio, a.occ_fincon as Contrato_Final, isnull(a.occ_rutcon,'') as Contrato_File, a.scc_numscc as Solicitud, o.rco_numrco as Requisicion,
Isnull(m.cc1_rutdoc_intranet,'.\') as OCC_Ruta_Intranet,
Isnull(m.cc1_rutdoc_extranet,'.\') as OCC_Ruta_Extranet,
Isnull(('CC_' + Rtrim(a.scc_numscc) + '.PDF'),'') as CuadroComparativo_File,
Isnull(p.rad_codarc,'') as SoleSource_File,
Isnull(r.cca_codarc,'') as SoleSource_File_CCO,
Isnull(q.cc1_rutdoc_intranet,'.\') as RCO_Ruta_Intranet,
Isnull(q.cc1_rutdoc_extranet,'.\') as RCO_Ruta_Extranet,
Isnull(s.cc1_rutdoc_intranet,'.\') as CCO_Ruta_Intranet,
Isnull(s.cc1_rutdoc_extranet,'.\') as CCO_Ruta_Extranet
--,A.* 
From Dbo.Orden_Compra_occ A
Left Outer Join Dbo.auxiliares_aux B
    On(b.cia_codcia=a.cia_codcia and b.aux_codaux=a.aux_codaux) 
Left Outer Join Dbo.Centro_Costo_cco C
    On(c.cia_codcia=a.cia_codcia and c.cco_codcco=a.cco_codcco) 
Left Outer Join Dbo.Auxiliares_Aux D
    On(d.cia_codcia=a.cia_codcia and d.aux_codaux=a.emp_codemp) 
Left Outer Join Dbo.contactos_auxiliar_con E
    ON(e.cia_codcia=a.cia_codcia and e.aux_codaux=a.aux_codaux and e.pna_coddid=a.pna_coddid and e.pna_numdoc=a.pna_numdoc) 
Left Outer Join Dbo.persona_natural_pna F
    ON(f.did_coddid=e.pna_coddid and f.pna_numdoc=e.pna_numdoc) 
Left Outer Join dbo.cond_pago_cpa G
    ON(g.cpa_codcpa=a.cpa_codcpa) 
Left Outer Join dbo.TIPO_SOLICITUD_TSC H 
    On(a.cia_codcia=h.CIA_CODCIA and a.tsc_codtsc=h.TSC_CODTSC)
Left Outer Join dbo.Terminos_Compra_TCO I
    On(a.cia_codcia=i.CIA_CODCIA and a.tco_codtco=i.Tco_CodTco)
Left Outer Join dbo.Cond_Pago_Cpa J
    On(a.cpa_codcpa=j.cpa_codcpa)    
Left Outer Join dbo.Tipo_de_Moneda_Tmo K
    On(a.tmo_codtmo=k.tmo_codtmo)    
Left Outer Join Dbo.Lugar_Entrega_Lec L
    On(a.cia_codcia=l.cia_codcia and a.lec_codlec=l.lec_codlec)
Left Join HD_CONFIG_COMP_CAB_CC1 M On a.cia_codcia=m.cia_codcia and a.suc_codsuc=m.suc_codsuc and m.cc1_codcc1='ORDCOM'
Left Join SOLICITUD_COMPRA_SCC N On a.cia_codcia=n.CIA_CODCIA and a.suc_codsuc=n.SUC_CODSUC and a.scc_numscc=n.SCC_NUMSCC
Left Join REQUERIMIENTO_COMPRA_RCO O On n.CIA_CODCIA=o.cia_codcia and n.SUC_CODSUC=o.suc_codsuc and n.RCO_NUMRCO=o.rco_numrco
Left Join REQUERIMIENTO_ADJUNTOS_RAD P on o.cia_codcia=p.cia_codcia and o.rco_numrco=p.rco_numrco and p.rad_nomarc='SOLE SOURCE'
Left Join HD_CONFIG_COMP_CAB_CC1 Q On a.cia_codcia=q.cia_codcia and a.suc_codsuc=q.suc_codsuc and q.cc1_codcc1='REQCOM'
Left Join CUADRO_COMPARATIVO_ADJUNTOS_CCA R On a.cia_codcia=r.CIA_CODCIA and a.suc_codsuc=r.SUC_CODSUC and a.scc_numscc=r.scc_numscc and r.cca_nomarc='SOLE SOURCE'
Left Join HD_CONFIG_COMP_CAB_CC1 S On a.cia_codcia=s.cia_codcia and a.suc_codsuc=s.suc_codsuc and s.cc1_codcc1='C_COMP'

Where 
a.cia_codcia = @p_CodCia and a.suc_codsuc = @p_CodSuc And a.ocm_corocm=@p_NumOC

/*
Exec PA_HD_WEB_OC_Consulta_Cabecera @p_CodCia='99', @p_CodSuc='99', @p_NumOC='S201400005'
*/

