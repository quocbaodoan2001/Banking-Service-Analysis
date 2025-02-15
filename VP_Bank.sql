----- data for visualization
create table vp_bank.VP_Bank_data as
select au.*, cu.segment ,cu.province_city ,ph.prod_ca ,ph.prod_td ,ph.prod_credit_card ,ph.prod_app ,ph.prod_secured_loan ,ph.prod_upl 
from VP_Bank.aum au
left JOIN VP_Bank.cust cu on au.customer_id = cu.customer_id 
left join VP_Bank.prod_holding ph on au.customer_id = ph.customer_id 

---- Total customers

select *
from VP_Bank.aum
left JOIN VP_Bank.cust on aum.customer_id = cust.customer_id 
left join VP_Bank.prod_holding ph on aum.customer_id = ph.customer_id 

-------- segmentation customer with revenue they brought

select cu.segment , sum(au.amount) as assets , count(*) Number_of_customers
from VP_Bank.aum au
left JOIN VP_Bank.cust cu on au.customer_id = cu.customer_id 
left join VP_Bank.prod_holding ph on au.customer_id = ph.customer_id 
group by cu.segment 

-------- location

select cu.province_city , sum(au.amount) as assets, count(*) as Number_of_customers
from VP_Bank.aum au
left JOIN VP_Bank.cust cu on au.customer_id = cu.customer_id 
left join VP_Bank.prod_holding ph on au.customer_id = ph.customer_id 
group by cu.province_city 

----------

select ph.prod_ca as Payment_Account_service, ph.prod_td as Time_Deposit_Product , ph.prod_credit_card as Credit_Card_service, ph.prod_app as Mobile_money_app_Service ,ph.prod_secured_loan as Mortgage_Loan_Product,ph.prod_upl as Personal_Loan_Product ,count(au.customer_id) as total_customers_without_using_serivces
from VP_Bank.aum au
left JOIN VP_Bank.cust cu on au.customer_id = cu.customer_id 
left join VP_Bank.prod_holding ph on au.customer_id = ph.customer_id
where ph.prod_ca = 0

--- create table vp_bank.withoutusingservice as

SELECT 
    COUNT(DISTINCT au.customer_id) AS total_customers,
    SUM(CASE WHEN COALESCE(ph.prod_ca, 0) = 0 THEN 1 ELSE 0 END) AS customers_without_checking_account,
    SUM(CASE WHEN COALESCE(ph.prod_td, 0) = 0 THEN 1 ELSE 0 END) AS customers_without_fixed_deposit,
    SUM(CASE WHEN COALESCE(ph.prod_credit_card, 0) = 0 THEN 1 ELSE 0 END) AS customers_without_credit_card,
    SUM(CASE WHEN COALESCE(ph.prod_app, 0) = 0 THEN 1 ELSE 0 END) AS customers_without_mobile_app,
    SUM(CASE WHEN COALESCE(ph.prod_secured_loan, 0) = 0 THEN 1 ELSE 0 END) AS customers_without_secured_loan,
    SUM(CASE WHEN COALESCE(ph.prod_upl, 0) = 0 THEN 1 ELSE 0 END) AS customers_without_unsecured_loan
FROM VP_Bank.aum au
LEFT JOIN VP_Bank.cust cu ON au.customer_id = cu.customer_id
LEFT JOIN VP_Bank.prod_holding ph ON au.customer_id = ph.customer_id;
--------

---- create table vp_bank.tracking_using_service as
SELECT 
    'Using' AS status,
    COUNT(DISTINCT au.customer_id) AS total_customers,
    SUM(CASE WHEN COALESCE(ph.prod_ca, 0) = 1 THEN 1 ELSE 0 END) AS Debit_Card_Prodcut,
    SUM(CASE WHEN COALESCE(ph.prod_td, 0) = 1 THEN 1 ELSE 0 END) AS Time_Deposit_Product,
    SUM(CASE WHEN COALESCE(ph.prod_credit_card, 0) = 1 THEN 1 ELSE 0 END) AS Credit_Card_Product,
    SUM(CASE WHEN COALESCE(ph.prod_app, 0) = 1 THEN 1 ELSE 0 END) AS Mobile_App_Product,
    SUM(CASE WHEN COALESCE(ph.prod_secured_loan, 0) = 1 THEN 1 ELSE 0 END) AS Mortgage_Loan_Product,
    SUM(CASE WHEN COALESCE(ph.prod_upl, 0) = 1 THEN 1 ELSE 0 END) AS Personal_Loan_Product
FROM VP_Bank.aum au
LEFT JOIN VP_Bank.cust cu ON au.customer_id = cu.customer_id
LEFT JOIN VP_Bank.prod_holding ph ON au.customer_id = ph.customer_id
UNION ALL
SELECT 
    'Without Using' AS status,
    COUNT(DISTINCT au.customer_id) AS total_customers,
    SUM(CASE WHEN COALESCE(ph.prod_ca, 0) = 0 THEN 1 ELSE 0 END) AS Debit_Card_Prodcut,
    SUM(CASE WHEN COALESCE(ph.prod_td, 0) = 0 THEN 1 ELSE 0 END) AS Time_Deposit_Product,
    SUM(CASE WHEN COALESCE(ph.prod_credit_card, 0) = 0 THEN 1 ELSE 0 END) AS Credit_Card_Product,
    SUM(CASE WHEN COALESCE(ph.prod_app, 0) = 0 THEN 1 ELSE 0 END) AS Mobile_App_Product,
    SUM(CASE WHEN COALESCE(ph.prod_secured_loan, 0) = 0 THEN 1 ELSE 0 END) AS Mortgage_Loan_Product,
    SUM(CASE WHEN COALESCE(ph.prod_upl, 0) = 0 THEN 1 ELSE 0 END) AS Personal_Loan_Product
FROM VP_Bank.aum au
LEFT JOIN VP_Bank.cust cu ON au.customer_id = cu.customer_id
LEFT JOIN VP_Bank.prod_holding ph ON au.customer_id = ph.customer_id

--------

create table vp_bank.HCM_HN_service as
select 
		'HCM' AS location,
		segment , 
		sum(prod_ca) as Debit_Card_Prodcut, 
		sum(prod_td) as Time_Deposit_Product ,
		sum(prod_credit_card) as Credit_Card_service,
		sum(prod_app) as Mobile_money_app_Service ,
		sum(prod_secured_loan) as Mortgage_Loan_Product,
		sum(prod_upl) as Personal_Loan_Product ,
		count(customer_id) as total_customers_HCM
from vp_bank.vp_bank_data vbd
where province_city = 'Ho chi minh'
group by segment
union ALL
select 
		'HN' AS location,
		segment , 
		sum(prod_ca) as Debit_Card_Prodcut, 
		sum(prod_td) as Time_Deposit_Product ,
		sum(prod_credit_card) as Credit_Card_service,
		sum(prod_app) as Mobile_money_app_Service ,
		sum(prod_secured_loan) as Mortgage_Loan_Product,
		sum(prod_upl) as Personal_Loan_Product ,
		count(customer_id) as total_customers_HN
from vp_bank.vp_bank_data vbd
where province_city = 'Ha Noi'
group by segment;

create table vp_bank.HCM_service as
select 
		segment , 
		sum(prod_ca) as Debit_Card_Prodcut, 
		sum(prod_td) as Time_Deposit_Product ,
		sum(prod_credit_card) as Credit_Card_service,
		sum(prod_app) as Mobile_money_app_Service ,
		sum(prod_secured_loan) as Mortgage_Loan_Product,
		sum(prod_upl) as Personal_Loan_Product ,
		count(customer_id) as total_customers_HCM
from vp_bank.vp_bank_data vbd
where province_city = 'Ho chi minh'
group by segment;

create table vp_bank.HN_service as
select 
		segment , 
		sum(prod_ca) as Debit_Card_Prodcut, 
		sum(prod_td) as Time_Deposit_Product ,
		sum(prod_credit_card) as Credit_Card_service,
		sum(prod_app) as Mobile_money_app_Service ,
		sum(prod_secured_loan) as Mortgage_Loan_Product,
		sum(prod_upl) as Personal_Loan_Product ,
		count(customer_id) as total_customers_HN
from vp_bank.vp_bank_data vbd
where province_city = 'Ha noi'
group by segment;

-----------------

select me(amount)
from vp_bank.vp_bank_data
where segment = 'GOLD' and province_city = 'HO CHI MINH'

select COUNT(*)
from vp_bank.vp_bank_data
where segment = 'GOLD' and province_city = 'HA NOI';

-------------

update vp_bank.vp_bank_data vbd 
set prod_credit_card = 0
where prod_credit_card = 'NA';

select *
from vp_bank.vp_bank_data vbd 







