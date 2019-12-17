
create view combined_geoms as (
	    select sa1_main16 as id, geom_3577 as geom, 'asgs16_sa1' as dataset from asgs16_sa1
	       UNION
	    select sa2_main16 as id, geom_3577 as geom, 'asgs16_sa2' as dataset from asgs16_sa2
	       UNION
	    select sa3_code16 as id, geom_3577 as geom, 'asgs16_sa3' as dataset from asgs16_sa3
	       UNION
	    select sa4_code16 as id, geom_3577 as geom, 'asgs16_sa4' as dataset from asgs16_sa4
	       UNION
	    select ste_code16 as id, geom_3577 as geom, 'asgs16_ste' as dataset from asgs16_ste
	       UNION
	    select cast(hydroid as varchar) as id, geom_3577 as geom, 'geofabric2_1_1_ahgfcontractedcatchment' as dataset from geofabric2_1_1_ahgfcontractedcatchment
	       UNION
	    select cast(hydroid as varchar) as id, geom_3577 as geom, 'geofabric2_1_1_riverregion' as dataset from geofabric2_1_1_riverregion
	       UNION
	    select cast(hydroid as varchar) as id, geom_3577 as geom, 'geofabric2_1_1_awradrainagedivision' as dataset from geofabric2_1_1_awradrainagedivision
);


CREATE TABLE combined_geom_count (
	    geom_total_count integer    
);
INSERT INTO combined_geom_count (geom_total_count) 
(SELECT count(*) FROM combined_geoms);


