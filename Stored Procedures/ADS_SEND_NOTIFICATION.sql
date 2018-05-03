create or replace 
PROCEDURE        "ADS_SEND_NOTIFICATION" 
(
leaseId varchar2
) AS
 v_item_key number;
 v_item_type varchar2(15);
 prev_status VARCHAR2 (50);
 leaseStatus VARCHAR2 (50);
 leaseNumber VARCHAR2 (50); 
 propertyName VARCHAR2 (100) := null; 
 propCount NUMBER;
BEGIN

select lease_status into leaseStatus from PN_LEASES_ALL where lease_id = leaseId;
select attribute1 into prev_status from pn_lease_details_all where lease_id = leaseId;

  
if prev_status is null or leaseStatus  != prev_status then

   if leaseStatus = 'IN_REVIEW' THEN

    v_item_type := 'JA_LN_RV';
    select ADS_LOAN_REV_S.nextval into v_item_key from dual;	
    select lease_num into leaseNumber from PN_LEASES_ALL where lease_id = leaseId;

    select count(props.property_name) into propCount from PN_LEASES_ALL leases, pn_locations_all locations, pn_properties_all props where leases.lease_id = leaseId 
    and leases.location_id = locations.location_id
    and locations.property_id = props.property_id;
    
    if propCount != 0 then
    
    select results.property_name   
    into propertyName from (
    select props.property_name from PN_LEASES_ALL leases, pn_locations_all locations, pn_properties_all props where leases.lease_id = leaseId 
    and leases.location_id = locations.location_id
    and locations.property_id = props.property_id) results
    where rownum = 1;
    
    end if;
    /*
    select results.property_name   
    into propertyName from
    ( select props.property_name
    from PN_TENANCIES_ALL tenancies, pn_locations_all locations, pn_properties_all props
    where tenancies.lease_id = leaseId 
    and tenancies.location_id = locations.location_id
    and locations.property_id = props.property_id
    order by tenancies.primary_flag desc ) results
    where rownum = 1;
*/
    wf_engine.CREATEPROCESS(v_item_type, v_item_key, 'LEASE_REVIEW',owner_role=>'OPERATIONS');
    wf_engine.SetItemAttrText(v_item_type,v_item_key,'LEASE_ID', leaseId);
    wf_engine.SetItemAttrText(v_item_type,v_item_key,'LEASE_NO', leaseNumber);
    wf_engine.SetItemAttrText(v_item_type,v_item_key,'PROP_NAME', propertyName);
    wf_engine.StartProcess(v_item_type,v_item_key);
   
  END IF;     

update pn_lease_details_all set attribute1 = leaseStatus where lease_id = leaseId;

END IF;  

END;
 