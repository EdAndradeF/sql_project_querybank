with
client_count as
(
SELECT	
	ac.account_id
	,count(*) client_count	
		FROM account as ac
		 left JOIN disposition as ds
	 		on ac.account_id = ds.account_id
	 	 left JOIN client as cl 
	 		on ds.client_id = cl.client_id
	group by ac.account_id
)

,account_num as(
select 
	ac.account_id
	,ac.frequency
	,cl.client_id
	,cl.sex
	,cl.district_id
	,ds.type
	,ds.disp_id
	,cc.client_count
	
		FROM account as ac
	 right JOIN disposition as ds
	 	on ac.account_id = ds.account_id
	 JOIN client as cl 
	 	on ds.client_id = cl.client_id
	 left join client_count as cc
	 	on cc.account_id = ac.account_id
)


,casais as (
/*	contas conjuntas tem 100% dos pagamentos em dia 
	porque n a liberação de contas conjuntas de pessoas do mesmo sexo?
	(sendo ou não casal)												*/
select 	
	a1.account_id
	,a1.client_id as OWNER_id
	,a1.disp_id as OWNER_disp
	,a2.client_id as DISPONENT_id
	,a2.disp_id as DISPONENT_disp
	,a1.district_id as district_id
	,case
		when a1.sex = 'M'
			then concat(a1.sex,'/', a2.sex)
		else concat(a2.sex, '/',a1.sex)
		end as sex_account
		from account_num as a1
		join account_num as a2
			on a1.client_id+1 = a2.client_id
	where a1.client_count = 2 and a2.client_count = 2
	and a1.account_id = a2.account_id
)

,conj_loan as(
select 
	c.*
	,l.status
	,l.amount 
	,l.payments
	
	from loan as l
		join casais as c
			on l.account_id = c.account_id
)

select 
	*
		from conj_loan
	
	













