-- explorar os dados que pertencem a cada uma das tabelas
-- tabela churn_demographics:
-- são no total 7043 linhas registros
-- sao 9 colunas customer_ID, Count, Gender, Age, Under_30, Senior_Citizen, Married, Dependents,Number_Of_Dependents

SELECT *
FROM `laboratoria-telco-361604.Dataset_telco.churn_demographics`

-- explorar os dados que pertencem a cada uma das tabelas
-- tabela churn_population:
-- são no total 1671 linhas registros
-- sao 3 colunas ID, Zip_Code, Population 

SELECT *
FROM `laboratoria-telco-361604.Dataset_telco.churn_population`


-- explorar os dados que pertencem a cada uma das tabelas
-- tabela churn_services:
-- são no total 7043 linhas registros
/* sao 30 colunas customer_ID, Count, Quarter, Referred_a_Friend, Number_Of_Referrals, Tenure_in_Mounths, Offer, Phone_Service, Avg_Monthly_Long_Distance_Charges, Multiple_Lines, Internet_Service, Internet_Type, Avg_Monthly_GB_Download, Online_Security, Online_Backup, Device_Protection_Plan, Premium_Tech_Support, Streaming_TV, Streaming_Movies, Streaming_Music, Unlimited_Data, Contract, Paperless_Billing, Payment_Method, Monthly_Charge, Total_Charges, Total_Refunds, Total_Extra_Data_Charges, Total_Long_Ditance_Charges, Total_Revenue */

SELECT *
FROM `laboratoria-telco-361604.Dataset_telco.churn_services`


-- explorar os dados que pertencem a cada uma das tabelas
-- tabela churn_status:
-- são no total 7043 linhas registros
-- sao 8 colunas Customer_ID, Count, Quarter, Customer_Status, Churn_Label, Churn_Value, Churn_Category, Churn_Reason

SELECT *
FROM `laboratoria-telco-361604.Dataset_telco.churn_status`

-- explorar os dados que pertencem a cada uma das tabelas
-- tabela churn_location:
-- são no total 7043 linhas registros
-- sao 8 colunas customer_ID, Count, Country, State, City, Zip_Code, Latitude, Longitude 

SELECT *
FROM `laboratoria-telco-361604.Dataset_telco.churn_location`

--se quisermos observar apenas Customer_ID, Country, State, City,Latitude e Longitude

SELECT 
    Customer_ID,
    Country,
    State,
    City,
    Latitude,
    Longitude
FROM `laboratoria-telco-361604.Dataset_telco.churn_location`
LIMIT 6

-- 🤓 Experimente criar uma nova variável com o nome Lat_long, unindo as variáveis Latitude e Longitude através da função CONCAT.

SELECT 
CONCAT 
(
'Latitude', '', 'Longitude' 
) AS Lat_long
FROM `laboratoria-telco-361604.Dataset_telco.churn_location`

/* 👩‍💻 Agora é sua vez!, Como você aprendeu a limitar um pequeno número de registros e exibir apenas as variáveis ​​que deseja, considere que queremos exibir 10 registros da tabela churn_status com as seguintes variáveis ​​Customer_ID, Customer_Status, Churn_Value, Churn_Category e Churn_Reason. */

SELECT 
    Customer_ID,
    Customer_Status,
    Churn_Value,
    Churn_Category,
    Churn_Reason
FROM `laboratoria-telco-361604.Dataset_telco.churn_status`
LIMIT 6

/* criação da tabela final (7043 linhas, 47 ​​variáveis ​​ou colunas) nela usar função SELECT para poder selecionar as variáveis ​​que precisamos, */
CREATE OR REPLACE TABLE `laboratoria-telco-361604.Dataset_telco.master_churn`  AS (
SELECT a.* EXCEPT(Zip_Code),
        b.Gender,b.Age,b.Under_30,b.Senior_Citizen,
        b.Married,b.Dependents,b.Number_of_Dependents,
        c.Quarter,c.Referred_a_Friend,c.Number_of_Referrals,
        c.Tenure_in_Months,c.Offer,c.Phone_Service,
        c.Avg_Monthly_Long_Distance_Charges,c.Multiple_Lines,
        c.Internet_Service,c.Internet_Type,c.Avg_Monthly_GB_Download,
        c.Online_Security,c.Online_Backup,c.Device_Protection_Plan,
        c.Premium_Tech_Support,c.Streaming_TV,c.Streaming_Movies,
        c.Streaming_Music,c.Unlimited_Data,c.Contract,c.Paperless_Billing,
        c.Payment_Method,c.Monthly_Charge,c.Total_Charges,c.Total_Refunds,
        c.Total_Extra_Data_Charges,c.Total_Long_Distance_Charges,c.Total_Revenue,
        d.Customer_Status,d.Churn_Label,d.Churn_Value,
        d.Churn_Category,d.Churn_Reason 
FROM `laboratoria-telco-361604.Dataset_telco.churn_location` a
LEFT JOIN `laboratoria-telco-361604.Dataset_telco.churn_demographics` b
ON a.Customer_ID=b.Customer_ID
LEFT JOIN `laboratoria-telco-361604.Dataset_telco.churn_services` c
ON b.Customer_ID=c.Customer_ID
LEFT JOIN `laboratoria-telco-361604.Dataset_telco.churn_status` d
ON c.Customer_ID=d.Customer_ID
)

-- contar o número total de registros que nosso quadro final possui: 7043
SELECT COUNT(*)
FROM `laboratoria-telco-361604.Dataset_telco.master_churn`
LIMIT 10

/* Primeiramente, vamos tentar validar que todos os registros pertencem aos Estados Unidos e ao estado da Califórnia, para isso será utilizada a função DISTINCT: */

SELECT DISTINCT Country
FROM `laboratoria-telco-361604.Dataset_telco.master_churn`

SELECT DISTINCT State
FROM `laboratoria-telco-361604.Dataset_telco.master_churn`

/* Saber o número de cidades que podem receber os serviços da empresa TELCO é muito importante para o negócio, pois assim podemos identificar onde novas alianças e vínculos com novos clientes podem ser gerados. Para esta exploração, será levado em consideração o uso da função COUNT (variável DISTINCT), total 1106*/

SELECT COUNT (DISTINCT City)
FROM `laboratoria-telco-361604.Dataset_telco.master_churn`

--  Dado o exemplo 3, você poderia mostrar algumas cidades para as quais a empresa TELCO presta serviços

SELECT DISTINCT City
FROM `laboratoria-telco-361604.Dataset_telco.master_churn`

/*  identificar valores máximos e mínimos, bem como somas e médias de variáveis ​​quantitativas com as funções de agregação MIN, MAX e AVG  ​​O que é interessante explorar é a distribuição das idades da nossa carteira de clientes */

SELECT 
MIN(Age) AS edad_minima,
MAX(Age) AS edad_maxima,
AVG(Age) AS edad_promedio
FROM `laboratoria-telco-361604.Dataset_telco.master_churn`

/* Como pode ser observado, a idade mínima da carteira de clientes é de 19 anos, enquanto a idade máxima é de 119 anos, enquanto a idade média da nossa carteira é de 47 anos. Se começarmos a analisar a idade máxima, vemos que não é consistente ter clientes com idade de 119 anos, então podemos tratar esses casos como anomalias nos dados, que comumente ocorrem nas bases de dados. Esta anomalia que existe na variável “Age” será tratada posteriormente. */

/* mostrar o pagamento mensal mínimo, máximo e médio da carteira de clientes da empresa TELCO? (Sugerimos a utilização da variável Monthly Charge). */

SELECT 
MIN(Monthly_Charge) AS Pag_Min,
MAX(Monthly_Charge) AS Pag_Max,
AVG(Monthly_Charge) AS Pag_Med
FROM `laboratoria-telco-361604.Dataset_telco.master_churn`

-- saber o número de clientes por gênero na carteira da empresa TELCO
SELECT Gender, COUNT(Customer_ID) AS clientes_totales
FROM `laboratoria-telco-361604.Dataset_telco.master_churn`
GROUP BY 1

-- agrupar as quantidades de acordo com a localização da variável ou de acordo com o nome.
SELECT Gender, COUNT(Customer_ID) AS clientes_totales
FROM `laboratoria-telco-361604.Dataset_telco.master_churn`
GROUP BY Gender

--mostrar o número de clientes casados ​​e solteiros de acordo com o tipo de gênero?
SELECT Gender, COUNT(Customer_ID) AS clientes_totales, married
FROM `laboratoria-telco-361604.Dataset_telco.master_churn`
GROUP BY Gender, Married

--precisarmos saber quais são as 5 principais cidades com maior número de clientes na carteira da empresa TELCO
SELECT City, COUNT(Customer_ID) AS clientes_totales
FROM `laboratoria-telco-361604.Dataset_telco.master_churn`
GROUP BY 1
ORDER BY 2 DESC 
LIMIT 5

/* precisamos padronizar as categorias da variável Gender, ou seja, converter a categoria “M” para Masculino e a categoria “F” para Feminino. estudo exploratório da variável "Monthly Charge", devido a alguns registos ( 110) que continham valores negativos e zeros. Em relação à variável "Age", Sebástian havia nos dito anteriormente que a idade máxima admitida de acordo com o histórico de serviços é de 80 anos, e que as mensalidades não poderiam ser negativas ou nulas, pois as bases cadastravam os clientes que aceitavam os serviços prestados pela empresa TELCO. */
CREATE OR REPLACE TABLE `laboratoria-telco-361604.Dataset_telco.master_churn` AS
(
SELECT * EXCEPT(gender),
CASE
WHEN gender = 'M' THEN 'Male'
WHEN gender = 'F' THEN 'Female'
ELSE gender END as gender
FROM `laboratoria-telco-361604.Dataset_telco.master_churn`
WHERE Age<=80
AND Monthly_Charge > 0
)

/* Ao fazer esta consulta, obteremos um total de 6.815 registros com 48 variáveis ​​para as quais serão feitas as respectivas visualizações no POWER BI para entender as características da carteira de clientes TELCO. */

SELECT *
FROM `laboratoria-telco-361604.Dataset_telco.master_churn`


-- segmentar as idades de acordo com a faixa etária que será de 19 a 40 anos, 41 a 60 e de 61 a mais.

CREATE OR REPLACE TABLE `laboratoria-telco-361604.Dataset_telco.master_churn` AS
(
  SELECT * ,
  CASE 
    WHEN Age < 41 THEN '1. 0 a 40 anos'
    WHEN Age BETWEEN 41 AND 60 THEN '2. 41 a 60 anos' 
    ELSE '3. Mais de 60 anos' 
    END AS faixa_etaria
  FROM `laboratoria-telco-361604.Dataset_telco.master_churn`
  WHERE Age<=80 #filtrando variável/coluna idade para apenas menores de 80 anos
  AND Monthly_Charge > 0 #filtrando variável/coluna pagamento mensal para apenas valores maiores que zero
)

-- 5 principais cidades com o maior número de clientes.
CREATE OR REPLACE TABLE `laboratoria-telco-361604.Dataset_telco.master_churncity` AS
SELECT City,
    Gender,
    Married,
    Dependents,
    faixa_etaria,
    COUNT(DISTINCT Customer_ID) AS total_clientes
FROM `laboratoria-telco-361604.Dataset_telco.master_churn`
GROUP BY 1,2,3,4,5

/* identificar se as pessoas casadas têm alguma relação com o número de referências, para isso será criada uma nova variável a partir dos seguintes intervalos: 0 referências, 1 a 4 referências, 5 a 8 referências e mais de 8 referências. */
create or replace table `laboratoria-telco-361604.Dataset_telco.master_churn` as
select *,
  case
    when Number_of_Referrals = 0 then '0 referências'
    when Number_of_Referrals BETWEEN 1 AND 4 then '1 a 4 referências'
    when Number_of_Referrals BETWEEN 5 AND 8 then '5 a 8 referências'
    else 'mais de 8 referências'
  end as reference_range
from `laboratoria-telco-361604.Dataset_telco.master_churn`

/* Para construir o painel a seguir, considere as variáveis ​​Contract, Multiple_Lines e range_tenure_months. Para a variável range_tenure_months, as categorias são 1 a 12 meses, 13 a 24 meses, 25 a 36 meses, 37 a 48 meses, 49 a 60 meses, 61 a 72 meses. */

create or replace table `laboratoria-telco-361604.Dataset_telco.master_churn` as
select
*,
  case
    when tenure_in_months BETWEEN 1 AND 12 then '1 a 12 meses'
    when tenure_in_months BETWEEN 13 AND 24 then '13 a 24 meses'
    when tenure_in_months BETWEEN 25 AND 36 then '25 a 36 meses'
    when tenure_in_months BETWEEN 37 AND 48 then '37 a 48 meses'
    when tenure_in_months BETWEEN 49 AND 60 then '1 a 12 meses'
    else '61 a 72 meses'
  end as faixa_meses
from `laboratoria-telco-361604.Dataset_telco.master_churn`

/* Os que têm uma probabilidade de saída muito elevada são os clientes cujo tipo de contrato é “Month-to-Month” e têm mais de 64 anos, este grupo denomina-se G1.
Aqueles com alta probabilidade de saída são aqueles clientes cujo tipo de contrato é “Month-to-Month”, têm menos de 64 anos e possuem menos de 2 referências, esse grupo é chamado de G2.
Aqueles com baixa probabilidade de saída são aqueles clientes cujo tipo de contrato é diferente de “Month-to-Month”, têm mais de 64 anos e possuem menos de 2 referências, esse grupo é chamado de G3.
Aqueles com probabilidade de saída muito baixa são aqueles clientes cujo tipo de contrato é diferente de “Month-to-Month” e antiguidade em meses menor que 40, esse grupo é chamado de G4. */

-- recriar essas hipóteses em linguagem SQL e criar uma variável chamada risk_group. 

CREATE OR REPLACE  TABLE `laboratoria-telco-361604.Dataset_telco.master_churn` AS (
SELECT *,
  CASE
    WHEN Contract = 'Month-to-Month' AND Age > 64 THEN 'G1'
    WHEN Contract = 'Month-to-Month' AND Age < 64 AND Number_of_Referrals <= 1 THEN 'G2'
    WHEN Contract != 'Month-to-Month' AND Age > 64 AND Number_of_Referrals <= 1 THEN 'G3'
    WHEN Contract != 'Month-to-Month' AND Tenure_in_Months < 40 THEN 'G4'
    ELSE 'sem grupo'
END AS risk_group

FROM `laboratoria-telco-361604.Dataset_telco.master_churn`
)

/*calcular o valor de um cliente, é necessário pensar na idade média (considere a variável Tenure_in_Months como referência) que um cliente pode ter de acordo com o tipo de contrato.Essa consulta nos permitirá projetar a receita total que o cliente poderá gerar se atingir a idade média de acordo com o tipo de contrato, essa variável é entendida como o número de meses que o cliente pode permanecer solicitando serviços TELCO. Podemos observar que o tempo médio de serviço para um cliente do tipo contrato "Month-to Month" tende a ficar 17 meses (1 ano e 5 meses), enquanto os clientes do tipo contrato “One year” permanecem por 41 meses (3 anos e 5 meses) e por fim o contrato tipo "Two Yea" com duração de 53 meses (4 anos e 5 meses). */

CREATE OR REPLACE  TABLE `laboratoria-telco-361604.Dataset_telco.master_churn_idademedia` AS
SELECT Contract,AVG(Tenure_in_Months) AS media_antiguidade
FROM `laboratoria-telco-361604.Dataset_telco.master_churn`
GROUP BY 1

/* Para poder determinar o valor de um cliente, temos que calcular a renda mensal total (os registros importados são trimestrais) multiplicada pela idade média que o cliente poderia durar de acordo com o tipo de contrato.  */

CREATE OR REPLACE  TABLE `laboratoria-telco-361604.Dataset_telco.master_churn` AS(
WITH base_tenure_prom AS (
        SELECT Contract,AVG(Tenure_in_Months) AS media_tenure
        FROM `laboratoria-telco-361604.Dataset_telco.master_churn`
        GROUP BY 1
)
SELECT a.*,
        b.media_tenure
FROM `laboratoria-telco-361604.Dataset_telco.master_churn` a
LEFT JOIN base_tenure_prom b
ON a.Contract = b.Contract
)

-- ver como está a tabela
SELECT *
FROM `laboratoria-telco-361604.Dataset_telco.master_churn`


/* Agora que você criou a variável media_tenure e a adicionou a sua tabela final, temos que criar a variável que valoriza o cliente. Para isso, são necessárias funções matemáticas básicas, como o produto que em linguagem SQL é simbolizado com “ * ”. */

-- valor do cliente com base na receita estimada
CREATE OR REPLACE  TABLE `laboratoria-telco-361604.Dataset_telco.master_churn` AS(
SELECT *,
    media_tenure*Total_Revenue/3 AS ingreso_estimado
FROM `laboratoria-telco-361604.Dataset_telco.master_churn` a
)

-- ver como está a tabela
SELECT *
FROM `laboratoria-telco-361604.Dataset_telco.master_churn`

/* criar segmentos ou quartis apenas para clientes que não se desligaram (a categorização no Churn Value é 0) e para cada tipo de contrato . */

CREATE OR REPLACE TABLE `laboratoria-telco-361604.Dataset_telco.master_churn` AS (
    SELECT *,NTILE(4) OVER( PARTITION BY Contract 
                    ORDER BY ingreso_estimado ASC) AS quartil_estimado  
    FROM  `laboratoria-telco-361604.Dataset_telco.master_churn`
    WHERE Churn_Value=0
)

-- ver como está a tabela
SELECT *
FROM `laboratoria-telco-361604.Dataset_telco.master_churn`

/* o cliente recebe um quartil mais alto (calculado com base na Receita Total), ele estaria em uma posição de Receita Total muito alta, ou seja, a receita futura que ele pode gerar é muito alta em relação aos outros quartis. Para o nosso desenvolvimento consideramos importantes os clientes que pertencem ao quartil 3 e 4, */

CREATE OR REPLACE TABLE `laboratoria-telco-361604.Dataset_telco.master_quartil` AS
SELECT Contract,
    risk_group,
    COUNT(Customer_ID) AS total_clientes 
FROM `laboratoria-telco-361604.Dataset_telco.master_churn`
WHERE quartil_estimado IN (3,4)
GROUP BY 1,2
ORDER BY 1

-- FILTRAR SAN DIEGO CLIENTES 
CREATE OR REPLACE TABLE `laboratoria-telco-361604.Dataset_telco.master_churnSANDIEGO`as 
SELECT city, 
    quartil_estimado, 
    risk_group, 
    customer_ID, 
    customer_status, 
    ingreso_estimado, 
    faixa_etaria, 
    gender, 
    married, 
    number_of_dependents, 
    payment_method, 
FROM `laboratoria-telco-361604.Dataset_telco.master_churn`
    WHERE city = 'San Diego'
    AND quartil_estimado >= 3
    AND risk_group = 'G1'


-- FILTRAR CLIENTES em risco
CREATE OR REPLACE TABLE `laboratoria-telco-361604.Dataset_telco.master_churnclientesemrisco`as 
SELECT city, 
    quartil_estimado, 
    risk_group, 
    customer_ID, 
    customer_status, 
    ingreso_estimado, 
    faixa_etaria, 
    gender, 
    married, 
    number_of_dependents, 
    payment_method, 
FROM `laboratoria-telco-361604.Dataset_telco.master_churn`
    WHERE quartil_estimado >= 3
    AND risk_group = 'G1'