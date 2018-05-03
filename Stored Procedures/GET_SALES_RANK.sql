create or replace 
PROCEDURE        "GET_SALES_RANK" (
p_entity_id NUMBER,
x_sales_rank_tbl OUT JTF_VARCHAR2_TABLE_4000)
IS

i NUMBER := 1;

BEGIN
x_sales_rank_tbl := JTF_VARCHAR2_TABLE_4000();

FOR x IN (SELECT c.meaning
FROM as_sales_leads a,
as_sales_lead_opportunity b,
as_sales_lead_ranks_vl c
WHERE a.sales_lead_id = b.sales_lead_id AND
b.opportunity_id = p_entity_id AND
a.lead_rank_id = c.rank_id)
LOOP
x_sales_rank_tbl.EXTEND;
x_sales_rank_tbl(i) := UPPER(x.meaning);
i := i + 1;
END LOOP;
END;
