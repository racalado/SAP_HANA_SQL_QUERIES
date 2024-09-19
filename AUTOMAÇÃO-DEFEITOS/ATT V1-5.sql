﻿SELECT * , 
CASE 
WHEN DTV1 = 0 THEN 'AGUARDAR CICLO 1'
WHEN URGRP = 200 AND DTV1 <> 0 AND MES1_PER < 0.2 THEN 'CANCELAR - POS COMP'
WHEN URGRP = 200 AND DTV1 <> 0 AND MES1_PER >= 0.2 THEN 'CALCULAR'
WHEN URGRP = 100 AND 
( DTV1 <> 0 AND MES1_PER >= 0.2 ) OR
( DTV2 <> 0 AND MES2_PER >= 0.2 ) OR
( DTV3 <> 0 AND MES3_PER >= 0.2 ) THEN 'CALCULAR'
WHEN URGRP = 100 AND DTV1 <> 0 AND DTV2 = 0 AND MES1_PER < 0.2 THEN 'AGUARDAR CICLO 2'
WHEN URGRP = 100 AND DTV1 <> 0 AND DTV2 <> 0 AND DTV3 = 0 AND MES2_PER < 0.2 THEN 'AGUARDAR CICLO 3'
WHEN URGRP = 100 AND DTV1 <> 0 AND DTV2 <> 0 AND DTV3 <> 0 AND
MES1_PER < 0.2 AND
MES2_PER < 0.2 AND
MES3_PER < 0.2 THEN 'CANCELAR - POS COMP'
ELSE '' END RESULT,
CAST(CASE WHEN DTV1 <> 0 AND MES1_PER >= 0.2 AND DATA_VIDA <> 'CONS_M1' THEN PV1-A1 ELSE 0 END AS DECIMAL (10,2))+
CAST(CASE WHEN DTV1 <> 0 AND MES1_A2_PER >= 0.2 AND MES1_PER >= 0.2 AND DATA_VIDA NOT IN ('CONS_M1','CONS_M2') THEN PV1-A2 ELSE 0 END AS DECIMAL (10,2))+
CAST(CASE WHEN DTV1 <> 0 AND MES1_A3_PER >= 0.2 AND MES1_A2_PER >= 0.2 AND MES1_PER >= 0.2 AND DATA_VIDA NOT IN ('CONS_M1','CONS_M2','CONS_M3') THEN PV1-A3 ELSE 0 END AS DECIMAL (10,2))
 AS RECUP_DEF,
CASE 
WHEN DTV1 <> 0 AND MES1_A3_PER >= 0.2 AND MES1_A2_PER >= 0.2 AND MES1_PER >= 0.2 AND DATA_VIDA NOT IN ('CONS_M1','CONS_M2','CONS_M3') THEN LEFT(ADD_MONTHS(FIM_RECUP,-2),7)
WHEN DTV1 <> 0 AND MES1_A2_PER >= 0.2 AND MES1_PER >= 0.2 AND DATA_VIDA NOT IN ('CONS_M1','CONS_M2') THEN LEFT(ADD_MONTHS(FIM_RECUP,-1),7)
ELSE FIM_RECUP END INIC_RECUP,
CASE 
WHEN DTV1 <> 0 AND MES1_A3_PER >= 0.2 AND MES1_A2_PER >= 0.2 AND MES1_PER >= 0.2 AND DATA_VIDA NOT IN ('CONS_M1','CONS_M2','CONS_M3') THEN LEFT(ADD_MONTHS(FIM_RECUP,-2),7)
WHEN DTV1 <> 0 AND MES1_A2_PER >= 0.2 AND MES1_PER >= 0.2 AND DATA_VIDA NOT IN ('CONS_M1','CONS_M2') THEN LEFT(ADD_MONTHS(FIM_RECUP,-1),7)
ELSE FIM_RECUP END INIC_APUR,
PV1 CONS_POS,
CAST(CASE WHEN DTV1 <> 0 AND MES1_PER >= 0.2 AND DATA_VIDA <> 'CONS_M1' THEN A1 ELSE 0 END AS DECIMAL (10,2))+
CAST(CASE WHEN DTV1 <> 0 AND MES1_A2_PER >= 0.2 AND MES1_PER >= 0.2 AND DATA_VIDA NOT IN ('CONS_M1','CONS_M2') THEN A2 ELSE 0 END AS DECIMAL (10,2))+
CAST(CASE WHEN DTV1 <> 0 AND MES1_A3_PER >= 0.2 AND MES1_A2_PER >= 0.2 AND MES1_PER >= 0.2 AND DATA_VIDA NOT IN ('CONS_M1','CONS_M2','CONS_M3') THEN A3 ELSE 0 END AS DECIMAL (10,2))
 AS FATURADO

FROM
(SELECT  NOTA, DATAC, INSTALACAO, URGRP, A3, A2, A1, ADT1, ADT2, ADT3, MEDIA, P1,P2,P3,P4 ,QTD_POS, DT1, DT2, DT3, DT4, PV1, PV2, PV3, DTV1, DTV2, DTV3, DATA_VIDA, BARRA_CALCULO,
PV1-A1 AG1 , PV2-A1 AG2 , PV3-A1 AG3, 
CAST(CASE WHEN PV1>0 AND A1>0 THEN (PV1/A1-1) WHEN PV1>0 AND A1=0 THEN 1 ELSE 0 END AS DECIMAL (10,2)) AS MES1_PER,
CAST(CASE WHEN PV2>0 AND A1>0 THEN (PV2/A1-1) WHEN PV2>0 AND A1=0 THEN 1 ELSE 0 END AS DECIMAL (10,2)) AS MES2_PER, 
CAST(CASE WHEN PV3>0 AND A1>0 THEN (PV3/A1-1) WHEN PV3>0 AND A1=0 THEN 1 ELSE 0 END AS DECIMAL (10,2)) AS MES3_PER,
CAST(CASE WHEN PV1>0 AND A2>0 THEN (PV1/A2-1) WHEN PV1>0 AND A2=0 THEN 1 ELSE 0 END AS DECIMAL (10,2)) AS MES1_A2_PER,
CAST(CASE WHEN PV1>0 AND A3>0 THEN (PV1/A3-1) WHEN PV1>0 AND A3=0 THEN 1 ELSE 0 END AS DECIMAL (10,2)) AS MES1_A3_PER,
PV1-A1 RECUP1,
PV1-A2 RECUP2,
PV1-A3 RECUP3,
ADD_DAYS(DATAC,-ADT1) A1_DTFAT,
ADD_DAYS(DATAC,-ADT2) A2_DTFAT,
ADD_DAYS(DATAC,-ADT3) A3_DTFAT,
CASE WHEN LEFT(DATAC,7) = LEFT(ADD_DAYS(DATAC,-ADT1),7) THEN LEFT(DATAC,7) 
ELSE LEFT(ADD_MONTHS(LEFT(DATAC,7),-1),7) END FIM_RECUP,
LEFT(ADD_DAYS(DATAC,DTV1),7) MES_REF

FROM ( SELECT  NOTA, DATAC, INSTALACAO, URGRP, A3, A2, A1, ADT1, ADT2, ADT3, 
CAST(CASE WHEN ( NUM = 0 OR NUM IS NULL) THEN 0 ELSE SOMA/NUM END AS DECIMAL(20,0)) MEDIA,
P1,P2,P3,P4, QTD_POS, DT1, DT2, DT3, DT4,
(CASE WHEN DT1 >= 27 THEN P1 ELSE P2 END) AS PV1,
(CASE WHEN DT1 >= 27 THEN P2 ELSE P3 END) AS PV2,
(CASE WHEN DT1 >= 27 THEN P3 ELSE P4 END) AS PV3,
(CASE WHEN DT1 >= 27 THEN DT1 ELSE DT2 END) AS DTV1,
(CASE WHEN DT1 >= 27 THEN DT2 ELSE DT3 END) AS DTV2,
(CASE WHEN DT1 >= 27 THEN DT3 ELSE DT4 END) AS DTV3,
DATA_VIDA, BARRA_CALCULO
 FROM (
		SELECT ANTES.NOTA, ANTES.DATAC, ANTES.INSTALACAO, A3, A2, A1, ADT1, ADT2, ADT3, SOMA, NUM, URGRP,
		SUM(CASE WHEN POS.ORDEM = 1 THEN POS.WERT2 ELSE 0 END) P1,
		SUM(CASE WHEN POS.ORDEM = 2 THEN POS.WERT2 ELSE 0 END) P2,
		SUM(CASE WHEN POS.ORDEM = 3 THEN POS.WERT2 ELSE 0 END) P3,
		SUM(CASE WHEN POS.ORDEM = 4 THEN POS.WERT2 ELSE 0 END) P4,
		SUM(CASE WHEN POS.ORDEM IN (1,2,3) THEN 1 ELSE 0 END) QTD_POS,
		SUM(CASE WHEN POS.ORDEM = 1 THEN POS.DIAS ELSE 0 END) DT1,
		SUM(CASE WHEN POS.ORDEM = 2 THEN POS.DIAS ELSE 0 END) DT2,
		SUM(CASE WHEN POS.ORDEM = 3 THEN POS.DIAS ELSE 0 END) DT3,
		SUM(CASE WHEN POS.ORDEM = 4 THEN POS.DIAS ELSE 0 END) DT4

FROM (
	( SELECT DISTINCT NOTA.ZCGQMNUM NOTA, URGRP, ZCGDTFINA DATAC, ZCGINSTAL INSTALACAO,
		SUM(CASE WHEN ANT.ORDEM = 3 THEN ANT.WERT2 ELSE 0 END) A3, 
		SUM(CASE WHEN ANT.ORDEM = 2 THEN ANT.WERT2 ELSE 0 END) A2, 
		SUM(CASE WHEN ANT.ORDEM = 1 THEN ANT.WERT2 ELSE 0 END) A1, 
		SUM(CASE WHEN ANT.ORDEM = 1 THEN ANT.DIAS ELSE 0 END) ADT1,
		SUM(CASE WHEN ANT.ORDEM = 2 THEN ANT.DIAS ELSE 0 END) ADT2,
		SUM(CASE WHEN ANT.ORDEM = 3 THEN ANT.DIAS ELSE 0 END) ADT3,
		SUM(CASE WHEN ANT.ORDEM IN (1,2,3) THEN ANT.WERT2 ELSE 0 END) SOMA, 
		SUM(CASE WHEN ANT.ORDEM IN (1,2,3) THEN 1 ELSE 0 END) NUM

	FROM "CLB_CCS_ICC"."ZCT_DS_TAB004" NOTA
		
		LEFT JOIN (
			SELECT * , ROW_NUMBER() OVER(PARTITION BY NOTA ORDER BY ABS(DIAS) ) AS ORDEM
			FROM (SELECT NOTA.ZCGQMNUM NOTA, ZCGDTFINA DATAC, ANLAGE2 INSTALACAO, WERT2, CONS.BIS2 DATA_LEIT, DAYS_BETWEEN(BIS2,ZCGDTFINA) DIAS
			FROM "CLB_CCS_ICC"."ZCT_DS_TAB004" NOTA
		
			LEFT JOIN (
			SELECT ANLAGE ANLAGE2, AB AB2, BIS BIS2, SUM(WERT1) WERT2
			FROM "NEO_COR"."neo.cor.data::MODEL.TABLES.ZCT_DS_CONSUMOS" CONS 
			WHERE OPERAND in ('CA_FAT_TT', 'CA_FAT_RV', 'CA_FAT_NP', 'CA_FAT_FP', 'CA_FAT_EM', 'CA_FAT_LIM', 'CA_FAT_LNP') AND BIS > '2018-01-01' 
			GROUP BY ANLAGE, AB, BIS  ) CONS
			ON NOTA.ZCGINSTAL = CONS.ANLAGE2 
			WHERE ZCGTPNOTA = 'CI' AND ZCGDTFINA > '2018-01-01' AND ZCGUSRSTS IN ('VREL','CRRE') AND URGRP IN ('100','200') AND BIS2 < ZCGDTFINA
			GROUP BY  NOTA.ZCGQMNUM , ZCGDTFINA , ANLAGE2, DAYS_BETWEEN(BIS2,ZCGDTFINA), CONS.BIS2, CONS.WERT2
			)ORDER BY  NOTA, DATA_LEIT DESC
				) ANT
		ON NOTA.ZCGQMNUM = ANT.NOTA AND NOTA.ZCGINSTAL = ANT.INSTALACAO
		
		WHERE ZCGTPNOTA = 'CI' AND NOTA.ZCGDTFINA > '2018-01-01' AND ZCGUSRSTS IN ('VREL','CRRE') AND URGRP IN ('100','200') 
		GROUP BY  NOTA.ZCGQMNUM , ZCGDTFINA , NOTA.ZCGINSTAL, NOTA.URGRP
		) ANTES
		
		LEFT JOIN (
		SELECT * , ROW_NUMBER() OVER(PARTITION BY NOTA ORDER BY ABS(DIAS) ) AS ORDEM 
		FROM ( SELECT NOTA.ZCGQMNUM NOTA, ZCGDTFINA DATAC, ANLAGE2 INSTALACAO, WERT2, CONS.BIS2 DATA_LEIT, DAYS_BETWEEN(ZCGDTFINA,BIS2) DIAS
		FROM "CLB_CCS_ICC"."ZCT_DS_TAB004" NOTA
		
		LEFT JOIN (
		SELECT ANLAGE ANLAGE2, AB AB2, BIS BIS2, SUM(WERT1) WERT2
		FROM "NEO_COR"."neo.cor.data::MODEL.TABLES.ZCT_DS_CONSUMOS" CONS 
		WHERE OPERAND in ('CA_FAT_TT', 'CA_FAT_RV', 'CA_FAT_NP', 'CA_FAT_FP', 'CA_FAT_EM', 'CA_FAT_LIM', 'CA_FAT_LNP') AND BIS > '2018-01-01' 
		GROUP BY ANLAGE, AB, BIS  ) CONS
		ON NOTA.ZCGINSTAL = CONS.ANLAGE2 
		WHERE ZCGTPNOTA = 'CI' AND ZCGDTFINA > '2018-01-01' AND ZCGUSRSTS IN ('VREL','CRRE') AND URGRP IN ('100','200') AND BIS2 > ZCGDTFINA
		GROUP BY  NOTA.ZCGQMNUM , ZCGDTFINA , ANLAGE2, DAYS_BETWEEN(BIS2,ZCGDTFINA), CONS.BIS2, CONS.WERT2
		)ORDER BY  NOTA, DATA_LEIT DESC
		) POS
		ON ANTES.NOTA = POS.NOTA
		)
		
GROUP BY ANTES.NOTA, ANTES.DATAC, ANTES.INSTALACAO, A3, A2, A1, SOMA, NUM, URGRP, ADT1, ADT2, ADT3
		) CALC
		LEFT JOIN (SELECT NOTA2, DATA_VIDA, BARRA_CALCULO FROM "CLP124051"."TABELA_CONSUMO_NOTA_FA") FA
		ON CALC.NOTA = FA.NOTA2
	)
)